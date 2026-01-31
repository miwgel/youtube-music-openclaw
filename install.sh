#!/bin/bash
set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}🎵 Kaset Skill Installer for OpenClaw${NC}"
echo "======================================"
echo ""

# 1. Verificar macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}Error: This skill only works on macOS${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} macOS detected"

# 2. Verificar Homebrew
if ! command -v brew &> /dev/null; then
    echo ""
    echo -e "${YELLOW}Homebrew not found.${NC}"
    read -p "Install Homebrew? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo -e "${RED}Homebrew is required. Exiting.${NC}"
        exit 1
    fi
fi
echo -e "${GREEN}✓${NC} Homebrew available"

# 3. Instalar Kaset
if ! ls /Applications/Kaset.app &> /dev/null 2>&1; then
    echo ""
    echo -e "${YELLOW}Kaset not found${NC}"
    echo "Kaset is the YouTube Music player this skill controls."
    read -p "Install Kaset via Homebrew? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        brew install sozercan/repo/kaset
    else
        echo -e "${RED}Kaset is required. Exiting.${NC}"
        exit 1
    fi
fi
echo -e "${GREEN}✓${NC} Kaset installed"

# 4. Instalar yt-dlp
if ! command -v yt-dlp &> /dev/null; then
    echo ""
    echo -e "${YELLOW}yt-dlp not found${NC}"
    echo "Required for searching YouTube Music."
    read -p "Install yt-dlp via Homebrew? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        brew install yt-dlp
    else
        echo -e "${RED}yt-dlp is required for search. Exiting.${NC}"
        exit 1
    fi
fi
echo -e "${GREEN}✓${NC} yt-dlp available"

# 5. Instalar jq
if ! command -v jq &> /dev/null; then
    echo ""
    echo -e "${YELLOW}jq not found${NC}"
    echo "Required for processing search results."
    read -p "Install jq via Homebrew? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        brew install jq
    else
        echo -e "${RED}jq is required. Exiting.${NC}"
        exit 1
    fi
fi
echo -e "${GREEN}✓${NC} jq available"

# 6. Crear directorio de skills si no existe
mkdir -p ~/.openclaw/skills

# 7. Determinar ubicación del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 8. Crear symlink
if [[ "$SCRIPT_DIR" != "$HOME/.openclaw/skills/youtube-music-openclaw" ]]; then
    if [[ -e ~/.openclaw/skills/youtube-music-openclaw ]]; then
        echo ""
        echo -e "${YELLOW}~/.openclaw/skills/youtube-music-openclaw already exists${NC}"
        read -p "Replace it? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf ~/.openclaw/skills/youtube-music-openclaw
        else
            echo "Keeping existing installation."
            exit 0
        fi
    fi
    ln -s "$SCRIPT_DIR" ~/.openclaw/skills/youtube-music-openclaw
    echo -e "${GREEN}✓${NC} Skill linked to ~/.openclaw/skills/youtube-music-openclaw"
else
    echo -e "${GREEN}✓${NC} Already in correct location"
fi

# 9. Hacer ejecutable el script de búsqueda
chmod +x "$SCRIPT_DIR/bin/youtube-search"
echo -e "${GREEN}✓${NC} Search script configured"

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Kaset skill installed successfully!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. Start Kaset (first time may require you to sign in)"
echo -e "   ${BLUE}open -a Kaset${NC}"
echo ""
echo "2. (Optional) Grant accessibility permissions to auto-close duplicate windows:"
echo -e "   ${BLUE}System Settings > Privacy & Security > Accessibility${NC}"
echo "   Add whatever app launches OpenClaw (Terminal, iTerm, Warp, VS Code, etc.)"
echo ""
echo "3. Try it out!"
echo -e "   ${BLUE}openclaw 'play some led zeppelin'${NC}"
echo ""
