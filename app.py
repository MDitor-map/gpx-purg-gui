#!/usr/bin/env python3
from flask import Flask, render_template, jsonify, send_from_directory
import os
import sys
import tkinter as tk
from tkinter import filedialog, messagebox
from pathlib import Path
import threading
import webbrowser
import markdown
import json
from functools import partial

app = Flask(__name__)
REPO_PATH = None
CONFIG_FILE = Path.home() / '.gpx_viewer_config.json'

def load_config():
    if CONFIG_FILE.exists():
        try:
            with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except:
            pass
    return {'last_path': ''}

def save_config(path):
    try:
        config = {'last_path': path}
        with open(CONFIG_FILE, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=2)
    except Exception as e:
        print(f"⚠️  Erreur sauvegarde config: {e}")

def find_preview_png(folder_path, gpx_filename):
    """Trouve le PNG de prévisualisation associé à un GPX"""
    gpx_base = Path(gpx_filename).stem.lower()
    
    # Chercher un PNG avec le même nom de base
    for f in folder_path.iterdir():
        if f.suffix.lower() == '.png':
            if f.stem.lower() == gpx_base:
                return f.name
    
    # Sinon, prendre le premier PNG du dossier
    for f in folder_path.iterdir():
        if f.suffix.lower() == '.png':
            return f.name
    
    return None

def select_directory(last_path=''):
    root = tk.Tk()
    root.withdraw()
    
    dialog = tk.Toplevel(root)
    dialog.title("Sélection du répertoire GPX")
    dialog.geometry("600x150")
    dialog.resizable(False, False)
    dialog.configure(bg='#2a2a2a')
    
    dialog.update_idletasks()
    x = (dialog.winfo_screenwidth() // 2) - (600 // 2)
    y = (dialog.winfo_screenheight() // 2) - (150 // 2)
    dialog.geometry(f'600x150+{x}+{y}')
    
    label = tk.Label(
        dialog,
        text="Entrez le chemin du répertoire GPX-purgamentorum :",
        bg='#2a2a2a',
        fg='#4CAF50',
        font=('Arial', 12, 'bold')
    )
    label.pack(pady=(20, 10))
    
    frame = tk.Frame(dialog, bg='#2a2a2a')
    frame.pack(padx=20, pady=10, fill=tk.X)
    
    path_var = tk.StringVar(value=last_path)
    entry = tk.Entry(
        frame,
        textvariable=path_var,
        font=('Arial', 10),
        bg='#1a1a1a',
        fg='white',
        insertbackground='white',
        relief=tk.FLAT,
        bd=2
    )
    entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))
    
    def browse():
        initial_dir = last_path if last_path and os.path.exists(last_path) else os.path.expanduser('~')
        directory = filedialog.askdirectory(
            title="Sélectionner le dossier GPX-purgamentorum",
            initialdir=initial_dir
        )
        if directory:
            path_var.set(directory)
    
    browse_btn = tk.Button(
        frame,
        text="Parcourir...",
        command=browse,
        bg='#4CAF50',
        fg='white',
        font=('Arial', 10, 'bold'),
        relief=tk.FLAT,
        cursor='hand2',
        padx=15,
        pady=5
    )
    browse_btn.pack(side=tk.RIGHT)
    
    result = [None]
    
    button_frame = tk.Frame(dialog, bg='#2a2a2a')
    button_frame.pack(pady=10)
    
    def on_ok():
        path = path_var.get().strip()
        if not path:
            messagebox.showerror("Erreur", "Veuillez entrer un chemin")
            return
        if not os.path.exists(path) or not os.path.isdir(path):
            messagebox.showerror("Erreur", "Le chemin n'existe pas ou n'est pas un dossier")
            return
        result[0] = path
        save_config(path)
        dialog.destroy()
        root.quit()
    
    def on_cancel():
        dialog.destroy()
        root.quit()
    
    ok_btn = tk.Button(
        button_frame,
        text="OK",
        command=on_ok,
        bg='#4CAF50',
        fg='white',
        font=('Arial', 10, 'bold'),
        relief=tk.FLAT,
        cursor='hand2',
        width=10,
        pady=5
    )
    ok_btn.pack(side=tk.LEFT, padx=5)
    
    cancel_btn = tk.Button(
        button_frame,
        text="Annuler",
        command=on_cancel,
        bg='#666666',
        fg='white',
        font=('Arial', 10, 'bold'),
        relief=tk.FLAT,
        cursor='hand2',
        width=10,
        pady=5
    )
    cancel_btn.pack(side=tk.LEFT, padx=5)
    
    dialog.bind('<Return>', lambda e: on_ok())
    entry.focus_set()
    
    root.mainloop()
    root.destroy()
    
    return result[0]

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/structure')
def get_structure():
    """Scanne la structure et retourne uniquement les GPX avec leur PNG de prévisualisation"""
    if not REPO_PATH:
        return jsonify([])
    
    structure = []
    
    for root, dirs, files in os.walk(REPO_PATH):
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != '__pycache__']
        
        gpx_files = [f for f in files if f.lower().endswith('.gpx')]
        
        if gpx_files:
            rel_path = Path(root).relative_to(REPO_PATH)
            folder_path = Path(root)
            
            # Pour chaque GPX, trouver le PNG de prévisualisation associé
            gpx_with_preview = []
            for gpx in gpx_files:
                preview = find_preview_png(folder_path, gpx)
                gpx_with_preview.append({
                    'name': gpx,
                    'preview': preview
                })
            
            structure.append({
                'path': str(rel_path).replace('\\', '/'),
                'name': Path(root).name,
                'gpx': gpx_with_preview
            })
    
    return jsonify(structure)

@app.route('/files/<path:filepath>')
def serve_file(filepath):
    if not REPO_PATH:
        return "Répertoire non configuré", 404
    
    file_path = Path(REPO_PATH) / filepath
    if not file_path.resolve().is_relative_to(Path(REPO_PATH).resolve()):
        return "Accès refusé", 403
    
    if not file_path.exists():
        return "Fichier non trouvé", 404
    
    return send_from_directory(REPO_PATH, filepath)

@app.route('/api/readme')
def get_readme():
    if not REPO_PATH:
        return "Répertoire non configuré", 404
    
    readme_path = Path(REPO_PATH) / 'README.md'
    if readme_path.exists():
        try:
            content = readme_path.read_text(encoding='utf-8')
            html_content = markdown.markdown(
                content,
                extensions=['tables', 'fenced_code', 'codehilite', 'toc', 'nl2br'],
                output_format='html5'
            )
            return html_content
        except Exception as e:
            return f"Erreur de lecture: {str(e)}", 500
    return "README non trouvé", 404

def open_browser():
    import time
    time.sleep(1.5)
    webbrowser.open('http://localhost:5000')

def main():
    global REPO_PATH
    
    print("🗺️  GPX Purgamentorum Viewer")
    print("=" * 40)
    
    config = load_config()
    last_path = config.get('last_path', '')
    
    if last_path:
        print(f"💾 Dernier chemin: {last_path}")
    
    REPO_PATH = select_directory(last_path)
    
    if not REPO_PATH:
        print("❌ Aucun répertoire sélectionné. Fermeture.")
        sys.exit(0)
    
    print(f"✅ Répertoire sélectionné: {REPO_PATH}")
    print(f" Serveur démarré sur http://localhost:5000")
    print(f"📄 Rendu Markdown activé pour le README")
    print("=" * 40)
    
    threading.Thread(target=open_browser, daemon=True).start()
    
    app.run(host='0.0.0.0', port=5000, debug=False)

if __name__ == '__main__':
    main()
