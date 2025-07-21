#\!/bin/bash

# Development Environment Setup Script
# Installs Git, uv, Claude Code, and configures GitHub SSH

set -e  # Exit on any error

echo "🚀 Setting up development environment..."

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root"
   exit 1
fi

# Update system packages
log_info "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
log_info "Installing essential packages..."
sudo apt install -y curl git build-essential software-properties-common

# Install Node.js (required for Claude Code)
log_info "Installing Node.js..."
if \! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x  < /dev/null |  sudo -E bash -
    sudo apt install -y nodejs
else
    log_info "Node.js already installed: $(node --version)"
fi

# Install uv (Python package manager)
log_info "Installing uv..."
if \! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add uv to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.bashrc
else
    log_info "uv already installed: $(uv --version)"
fi

# Install Claude Code
log_info "Installing Claude Code..."
if \! command -v claude-code &> /dev/null; then
    npm install -g @anthropic-ai/claude-code
else
    log_info "Claude Code already installed"
fi

# Generate SSH key for GitHub
log_info "Setting up GitHub SSH key..."
if [[ \! -f ~/.ssh/id_ed25519 ]]; then
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_ed25519 -N ""
    log_info "SSH key generated at ~/.ssh/id_ed25519.pub"
    
    echo
    log_warn "=== ACTION REQUIRED ==="
    echo "Please add this SSH key to your GitHub account:"
    echo "https://github.com/settings/ssh/new"
    echo
    echo "Your public key:"
    cat ~/.ssh/id_ed25519.pub
    echo
    read -p "Press Enter after adding the key to GitHub..."
    
    # Test GitHub connection
    log_info "Testing GitHub SSH connection..."
    if ssh -T -o StrictHostKeyChecking=no git@github.com 2>&1 | grep -q "successfully authenticated"; then
        log_info "GitHub SSH connection successful\!"
    else
        log_error "GitHub SSH connection failed. Please check your key setup."
    fi
else
    log_info "SSH key already exists"
fi

# Configure Git
log_info "Configuring Git..."
read -p "Enter your GitHub username: " github_username
read -p "Enter your email (or press Enter for no-reply): " github_email

if [[ -z "$github_email" ]]; then
    github_email="${github_username}@users.noreply.github.com"
fi

git config --global user.name "$github_username"
git config --global user.email "$github_email"

log_info "Git configured:"
log_info "  Username: $(git config --global user.name)"
log_info "  Email: $(git config --global user.email)"

# Create common directories
log_info "Creating development directories..."
mkdir -p ~/projects ~/scripts ~/bin

# Add bin to PATH if not already there
if [[ ":$PATH:" \!= *":$HOME/bin:"* ]]; then
    echo "export PATH=\"\$HOME/bin:\$PATH\"" >> ~/.bashrc
fi

echo
log_info "✅ Development environment setup complete\!"
echo
echo "Installed tools:"
echo "  - Git: $(git --version)"
echo "  - Node.js: $(node --version)"
echo "  - npm: $(npm --version)"
echo "  - uv: $(uv --version 2>/dev/null || echo \"Not in current PATH - restart shell\")"
echo "  - Claude Code: $(claude-code --version 2>/dev/null || echo \"Not in current PATH - restart shell\")"
echo
log_info "Please restart your shell or run: source ~/.bashrc"
