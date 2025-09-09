#!/bin/bash
# Claude Code Auto-Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install-claude-code.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    error "Unsupported OS. Use Linux or macOS."
fi

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    error "Don't run as root. Use a regular user with sudo."
fi

log "Installing Claude Code for $OS..."

# Install Node.js if needed
if ! command -v node >/dev/null 2>&1; then
    log "Installing Node.js..."
    if [[ "$OS" == "linux" ]]; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        if command -v brew >/dev/null 2>&1; then
            brew install node
        else
            error "Install Homebrew first or get Node.js from nodejs.org"
        fi
    fi
fi

# Install system dependencies
log "Installing dependencies..."
if [[ "$OS" == "linux" ]]; then
    sudo apt-get update
    sudo apt-get install -y curl git build-essential
else
    if ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install
        log "Complete Xcode installation and re-run script"
        exit 0
    fi
fi

# Install Claude Code
log "Installing Claude Code..."
if curl -fsSL https://claude.ai/install.sh | bash; then
    success "Claude Code installed"
else
    log "Trying npm method..."
    npm install -g @anthropic-ai/claude-code
fi

# Update PATH
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
export PATH="$(npm config get prefix)/bin:$PATH"

# Verify
if command -v claude >/dev/null 2>&1; then
    success "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Restart terminal or run: source ~/.bashrc"
    echo "2. Run: claude"
    echo "3. Complete authentication"
else
    error "Installation failed"
fi