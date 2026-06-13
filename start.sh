#!/bin/bash

# ═══════════════════════════════════════════════════════════
# GPX Purgamentorum Viewer - Launcher
# ═══════════════════════════════════════════════════════════

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ═══════════════════════════════════════════════════════════
# SÉLECTION DE LA LANGUE / LANGUAGE SELECTION
# ═══════════════════════════════════════════════════════════

clear
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║                                              ║${NC}"
echo -e "${CYAN}${BOLD}║   🗺️  GPX Purgamentorum Viewer              ║${NC}"
echo -e "${CYAN}${BOLD}║                                              ║${NC}"
echo -e "${CYAN}${BOLD}║   Choisissez votre langue / Choose language  ║${NC}"
echo -e "${CYAN}${BOLD}║                                              ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}[1]${NC} 🇫🇷  Français"
echo -e "  ${GREEN}[2]${NC} 🇬🇧  English"
echo ""
read -p "  $(echo -e ${YELLOW}Votre choix / Your choice${NC} [1/2]: )" lang_choice

case $lang_choice in
    1)
        LANG="FR"
        ;;
    2)
        LANG="EN"
        ;;
    *)
        LANG="EN"
        ;;
esac

# ═══════════════════════════════════════════════════════════
# TRADUCTIONS / TRANSLATIONS
# ═══════════════════════════════════════════════════════════

if [ "$LANG" = "FR" ]; then
    # ── Français ──
    MSG_TITLE="╔══════════════════════════════════════════════╗"
    MSG_TITLE2="║   GPX Purgamentorum Viewer - Lanceur        ║"
    MSG_TITLE3="╚══════════════════════════════════════════════╝"
    MSG_SUCCESS="✓"
    MSG_ERROR="✗"
    MSG_INFO="ℹ"
    MSG_WARN="⚠"
    
    MSG_DEBIAN_OK="Système Debian/Ubuntu détecté"
    MSG_DEBIAN_FAIL="Ce script est conçu pour Debian/Ubuntu uniquement."
    
    MSG_CHECK_PYTHON="Vérification de Python 3..."
    MSG_PYTHON_MISSING="Python 3 n'est pas installé"
    MSG_PYTHON_INSTALL="Installation de Python 3..."
    MSG_PYTHON_INSTALLED="Python 3 installé avec succès"
    MSG_PYTHON_OK="Python détecté"
    
    MSG_CHECK_PIP="Vérification de pip..."
    MSG_PIP_MISSING="pip3 n'est pas installé"
    MSG_PIP_INSTALL="Installation de pip3..."
    MSG_PIP_INSTALLED="pip3 installé avec succès"
    MSG_PIP_OK="pip3 détecté"
    
    MSG_CHECK_TK="Vérification de tkinter..."
    MSG_TK_MISSING="tkinter n'est pas installé"
    MSG_TK_INSTALL="Installation de python3-tk..."
    MSG_TK_INSTALLED="tkinter installé avec succès"
    MSG_TK_OK="tkinter détecté"
    
    MSG_VENV_CREATE="Création de l'environnement virtuel..."
    MSG_VENV_CREATED="Environnement virtuel créé"
    MSG_VENV_EXISTS="Environnement virtuel existant"
    MSG_VENV_ACTIVATE="Activation de l'environnement virtuel..."
    
    MSG_CHECK_FLASK="Vérification de Flask..."
    MSG_FLASK_INSTALL="Installation de Flask..."
    MSG_FLASK_INSTALLED="Flask installé avec succès"
    MSG_FLASK_OK="Flask détecté"
    
    MSG_CHECK_MD="Vérification de Markdown..."
    MSG_MD_INSTALL="Installation de Markdown..."
    MSG_MD_INSTALLED="Markdown installé avec succès"
    MSG_MD_OK="Markdown détecté"
    
    MSG_APP_MISSING="app.py n'a pas été trouvé dans le répertoire courant"
    MSG_APP_OK="app.py trouvé"
    MSG_TPL_MISSING="templates/index.html n'a pas été trouvé"
    MSG_TPL_OK="templates/index.html trouvé"
    
    MSG_ALL_OK="Toutes les dépendances sont installées !"
    MSG_STARTING="Démarrage de l'application..."
    MSG_INSTALL_FAIL="Échec de l'installation"
    
else
    # ── English ──
    MSG_TITLE="╔══════════════════════════════════════════════╗"
    MSG_TITLE2="║   GPX Purgamentorum Viewer - Launcher       ║"
    MSG_TITLE3="╚══════════════════════════════════════════════╝"
    MSG_SUCCESS="✓"
    MSG_ERROR="✗"
    MSG_INFO="ℹ"
    MSG_WARN="⚠"
    
    MSG_DEBIAN_OK="Debian/Ubuntu system detected"
    MSG_DEBIAN_FAIL="This script is designed for Debian/Ubuntu only."
    
    MSG_CHECK_PYTHON="Checking Python 3..."
    MSG_PYTHON_MISSING="Python 3 is not installed"
    MSG_PYTHON_INSTALL="Installing Python 3..."
    MSG_PYTHON_INSTALLED="Python 3 installed successfully"
    MSG_PYTHON_OK="Python detected"
    
    MSG_CHECK_PIP="Checking pip..."
    MSG_PIP_MISSING="pip3 is not installed"
    MSG_PIP_INSTALL="Installing pip3..."
    MSG_PIP_INSTALLED="pip3 installed successfully"
    MSG_PIP_OK="pip3 detected"
    
    MSG_CHECK_TK="Checking tkinter..."
    MSG_TK_MISSING="tkinter is not installed"
    MSG_TK_INSTALL="Installing python3-tk..."
    MSG_TK_INSTALLED="tkinter installed successfully"
    MSG_TK_OK="tkinter detected"
    
    MSG_VENV_CREATE="Creating virtual environment..."
    MSG_VENV_CREATED="Virtual environment created"
    MSG_VENV_EXISTS="Virtual environment already exists"
    MSG_VENV_ACTIVATE="Activating virtual environment..."
    
    MSG_CHECK_FLASK="Checking Flask..."
    MSG_FLASK_INSTALL="Installing Flask..."
    MSG_FLASK_INSTALLED="Flask installed successfully"
    MSG_FLASK_OK="Flask detected"
    
    MSG_CHECK_MD="Checking Markdown..."
    MSG_MD_INSTALL="Installing Markdown..."
    MSG_MD_INSTALLED="Markdown installed successfully"
    MSG_MD_OK="Markdown detected"
    
    MSG_APP_MISSING="app.py was not found in the current directory"
    MSG_APP_OK="app.py found"
    MSG_TPL_MISSING="templates/index.html was not found"
    MSG_TPL_OK="templates/index.html found"
    
    MSG_ALL_OK="All dependencies are installed!"
    MSG_STARTING="Starting application..."
    MSG_INSTALL_FAIL="Installation failed"
fi

# ═══════════════════════════════════════════════════════════
# FONCTIONS / FUNCTIONS
# ═══════════════════════════════════════════════════════════

success() {
    echo -e "${GREEN}${MSG_SUCCESS} $1${NC}"
}

error() {
    echo -e "${RED}${MSG_ERROR} $1${NC}"
}

info() {
    echo -e "${BLUE}${MSG_INFO} $1${NC}"
}

warn() {
    echo -e "${YELLOW}${MSG_WARN} $1${NC}"
}

# ═══════════════════════════════════════════════════════════
# DÉMARRAGE / STARTUP
# ═══════════════════════════════════════════════════════════

clear
echo ""
echo -e "${GREEN}${BOLD}${MSG_TITLE}${NC}"
echo -e "${GREEN}${BOLD}${MSG_TITLE2}${NC}"
echo -e "${GREEN}${BOLD}${MSG_TITLE3}${NC}"
echo ""

# Vérifier si on est sur Debian/Ubuntu
if [ ! -f /etc/debian_version ]; then
    error "$MSG_DEBIAN_FAIL"
    exit 1
fi
success "$MSG_DEBIAN_OK"

# Vérifier Python 3
info "$MSG_CHECK_PYTHON"
if ! command -v python3 &> /dev/null; then
    error "$MSG_PYTHON_MISSING"
    warn "$MSG_PYTHON_INSTALL"
    sudo apt update
    sudo apt install -y python3 python3-pip python3-tk python3-venv
    if [ $? -ne 0 ]; then
        error "$MSG_INSTALL_FAIL (Python 3)"
        exit 1
    fi
    success "$MSG_PYTHON_INSTALLED"
else
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    success "$MSG_PYTHON_OK ($PYTHON_VERSION)"
fi

# Vérifier pip
info "$MSG_CHECK_PIP"
if ! command -v pip3 &> /dev/null; then
    error "$MSG_PIP_MISSING"
    warn "$MSG_PIP_INSTALL"
    sudo apt install -y python3-pip
    if [ $? -ne 0 ]; then
        error "$MSG_INSTALL_FAIL (pip3)"
        exit 1
    fi
    success "$MSG_PIP_INSTALLED"
else
    success "$MSG_PIP_OK"
fi

# Vérifier tkinter
info "$MSG_CHECK_TK"
if ! python3 -c "import tkinter" &> /dev/null; then
    error "$MSG_TK_MISSING"
    warn "$MSG_TK_INSTALL"
    sudo apt install -y python3-tk
    if [ $? -ne 0 ]; then
        error "$MSG_INSTALL_FAIL (tkinter)"
        exit 1
    fi
    success "$MSG_TK_INSTALLED"
else
    success "$MSG_TK_OK"
fi

# Créer un environnement virtuel s'il n'existe pas
VENV_DIR="venv"
if [ ! -d "$VENV_DIR" ]; then
    info "$MSG_VENV_CREATE"
    python3 -m venv $VENV_DIR
    if [ $? -ne 0 ]; then
        error "$MSG_INSTALL_FAIL (venv)"
        exit 1
    fi
    success "$MSG_VENV_CREATED"
else
    success "$MSG_VENV_EXISTS"
fi

# Activer l'environnement virtuel
info "$MSG_VENV_ACTIVATE"
source $VENV_DIR/bin/activate

# Vérifier et installer Flask
info "$MSG_CHECK_FLASK"
if ! python3 -c "import flask" &> /dev/null; then
    warn "$MSG_FLASK_INSTALL"
    pip install flask
    if [ $? -ne 0 ]; then
        error "$MSG_INSTALL_FAIL (Flask)"
        exit 1
    fi
    success "$MSG_FLASK_INSTALLED"
else
    FLASK_VERSION=$(python3 -c "import flask; print(flask.__version__)" 2>/dev/null)
    success "$MSG_FLASK_OK ($FLASK_VERSION)"
fi

# Vérifier et installer Markdown
info "$MSG_CHECK_MD"
if ! python3 -c "import markdown" &> /dev/null; then
    warn "$MSG_MD_INSTALL"
    pip install markdown
    if [ $? -ne 0 ]; then
        error "$MSG_INSTALL_FAIL (Markdown)"
        exit 1
    fi
    success "$MSG_MD_INSTALLED"
else
    MD_VERSION=$(python3 -c "import markdown; print(markdown.__version__)" 2>/dev/null)
    success "$MSG_MD_OK ($MD_VERSION)"
fi

# Vérifier la présence de app.py
if [ ! -f "app.py" ]; then
    error "$MSG_APP_MISSING"
    exit 1
fi
success "$MSG_APP_OK"

# Vérifier la présence de templates/index.html
if [ ! -f "templates/index.html" ]; then
    error "$MSG_TPL_MISSING"
    exit 1
fi
success "$MSG_TPL_OK"

echo ""
success "$MSG_ALL_OK"
echo ""
info "$MSG_STARTING"
echo ""

# Lancer l'application
python3 app.py

# Désactiver l'environnement virtuel à la sortie
deactivate
