#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher un message de succès
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Fonction pour afficher un message d'erreur
error() {
    echo -e "${RED}✗ $1${NC}"
}

# Fonction pour afficher un message d'information
info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Fonction pour afficher un message d'avertissement
warn() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   GPX Purgamentorum Viewer - Launcher     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""

# Vérifier si on est sur Debian/Ubuntu
if [ ! -f /etc/debian_version ]; then
    error "Ce script est conçu pour Debian/Ubuntu uniquement."
    exit 1
fi

success "Système Debian/Ubuntu détecté"

# Vérifier Python 3
info "Vérification de Python 3..."
if ! command -v python3 &> /dev/null; then
    error "Python 3 n'est pas installé"
    warn "Installation de Python 3..."
    sudo apt update
    sudo apt install -y python3 python3-pip python3-tk python3-venv
    if [ $? -ne 0 ]; then
        error "Échec de l'installation de Python 3"
        exit 1
    fi
    success "Python 3 installé avec succès"
else
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    success "Python $PYTHON_VERSION détecté"
fi

# Vérifier pip
info "Vérification de pip..."
if ! command -v pip3 &> /dev/null; then
    error "pip3 n'est pas installé"
    warn "Installation de pip3..."
    sudo apt install -y python3-pip
    if [ $? -ne 0 ]; then
        error "Échec de l'installation de pip3"
        exit 1
    fi
    success "pip3 installé avec succès"
else
    success "pip3 détecté"
fi

# Vérifier tkinter
info "Vérification de tkinter..."
if ! python3 -c "import tkinter" &> /dev/null; then
    error "tkinter n'est pas installé"
    warn "Installation de python3-tk..."
    sudo apt install -y python3-tk
    if [ $? -ne 0 ]; then
        error "Échec de l'installation de tkinter"
        exit 1
    fi
    success "tkinter installé avec succès"
else
    success "tkinter détecté"
fi

# Créer un environnement virtuel s'il n'existe pas
VENV_DIR="venv"
if [ ! -d "$VENV_DIR" ]; then
    info "Création de l'environnement virtuel..."
    python3 -m venv $VENV_DIR
    if [ $? -ne 0 ]; then
        error "Échec de la création de l'environnement virtuel"
        exit 1
    fi
    success "Environnement virtuel créé"
else
    success "Environnement virtuel existant"
fi

# Activer l'environnement virtuel
info "Activation de l'environnement virtuel..."
source $VENV_DIR/bin/activate

# Vérifier et installer Flask
info "Vérification de Flask..."
if ! python3 -c "import flask" &> /dev/null; then
    warn "Installation de Flask..."
    pip install flask
    if [ $? -ne 0 ]; then
        error "Échec de l'installation de Flask"
        exit 1
    fi
    success "Flask installé avec succès"
else
    FLASK_VERSION=$(python3 -c "import flask; print(flask.__version__)" 2>/dev/null)
    success "Flask $FLASK_VERSION détecté"
fi

# Vérifier et installer Markdown
info "Vérification de Markdown..."
if ! python3 -c "import markdown" &> /dev/null; then
    warn "Installation de Markdown..."
    pip install markdown
    if [ $? -ne 0 ]; then
        error "Échec de l'installation de Markdown"
        exit 1
    fi
    success "Markdown installé avec succès"
else
    MD_VERSION=$(python3 -c "import markdown; print(markdown.__version__)" 2>/dev/null)
    success "Markdown $MD_VERSION détecté"
fi

# Vérifier la présence de app.py
if [ ! -f "app.py" ]; then
    error "app.py n'a pas été trouvé dans le répertoire courant"
    exit 1
fi
success "app.py trouvé"

# Vérifier la présence de templates/index.html
if [ ! -f "templates/index.html" ]; then
    error "templates/index.html n'a pas été trouvé"
    exit 1
fi
success "templates/index.html trouvé"

echo ""
success "Toutes les dépendances sont installées !"
echo ""
info "Démarrage de l'application..."
echo ""

# Lancer l'application
python3 app.py

# Désactiver l'environnement virtuel à la sortie
deactivate
