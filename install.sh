#!/bin/bash
set -e

# Colores
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

printf "\n"
printf "${BLUE}🎵 Kaset Skill Installer for OpenClaw${NC}\n"
printf "======================================\n\n"

# 1. Verificar macOS
if [[ "$(uname)" != "Darwin" ]]; then
    printf "${RED}Error: This skill only works on macOS${NC}\n"
    exit 1
fi
printf "${GREEN}✓${NC} macOS detected\n"

# 2. Verificar Homebrew
if ! command -v brew &> /dev/null; then
    printf "\n${YELLOW}Homebrew not found.${NC}\n"
    read -p "Install Homebrew? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        printf "${RED}Homebrew is required. Exiting.${NC}\n"
        exit 1
    fi
fi
printf "${GREEN}✓${NC} Homebrew available\n"

# 3. Instalar Kaset
if ! ls /Applications/Kaset.app &> /dev/null 2>&1; then
    printf "\n${YELLOW}Kaset not found${NC}\n"
    printf "Kaset is the YouTube Music player this skill controls.\n"
    read -p "Install Kaset via Homebrew? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        brew install sozercan/repo/kaset
    else
        printf "${RED}Kaset is required. Exiting.${NC}\n"
        exit 1
    fi
fi
printf "${GREEN}✓${NC} Kaset installed\n"

# 4. Instalar yt-dlp
if ! command -v yt-dlp &> /dev/null; then
    printf "\n${YELLOW}yt-dlp not found${NC}\n"
    printf "Required for searching YouTube Music.\n"
    read -p "Install yt-dlp via Homebrew? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        brew install yt-dlp
    else
        printf "${RED}yt-dlp is required for search. Exiting.${NC}\n"
        exit 1
    fi
fi
printf "${GREEN}✓${NC} yt-dlp available\n"

# 5. Instalar jq
if ! command -v jq &> /dev/null; then
    printf "\n${YELLOW}jq not found${NC}\n"
    printf "Required for processing search results.\n"
    read -p "Install jq via Homebrew? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        brew install jq
    else
        printf "${RED}jq is required. Exiting.${NC}\n"
        exit 1
    fi
fi
printf "${GREEN}✓${NC} jq available\n"

# 6. Determinar ubicación del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 7. Hacer ejecutables todos los scripts
chmod +x "$SCRIPT_DIR/bin/"*
printf "${GREEN}✓${NC} Scripts configured\n"
printf "${GREEN}✓${NC} Skill ready at $SCRIPT_DIR\n"

printf "\n"
printf "${GREEN}════════════════════════════════════════${NC}\n"
printf "${GREEN}✅ Kaset skill installed successfully!${NC}\n"
printf "${GREEN}════════════════════════════════════════${NC}\n"
printf "\n"
printf "Next steps:\n\n"
printf "1. Start Kaset (first time may require you to sign in)\n"
printf "   ${BLUE}open -a Kaset${NC}\n\n"
printf "2. Try it out!\n"
printf "   ${BLUE}openclaw 'play some led zeppelin'${NC}\n\n"
