# Development Configurations

Personal development environment configurations and setup scripts.

## Contents

### 📁 Directories

- **`.devcontainer/`** - Development container configurations
- **`fonts/`** - Custom fonts for development
- **`ghostty/`** - Ghostty terminal configurations

### 🚀 Setup Scripts

#### `setup-dev-env.sh`

Automated development environment setup script that installs and configures essential development tools.

**What it installs:**
- Git - Version control
- Node.js & npm - JavaScript runtime and package manager  
- uv - Fast Python package manager and project manager
- Claude Code - AI-powered coding assistant CLI

**What it configures:**
- GitHub SSH key generation and setup
- Git user configuration with GitHub integration
- Development directory structure (`~/projects`, `~/scripts`, `~/bin`)
- PATH environment variables

**Usage:**
```bash
# Clone this repository
git clone https://github.com/svadivazhagu/dev-configs.git
cd dev-configs

# Run the setup script
./setup-dev-env.sh
```

**Manual steps required:**
1. The script will generate an SSH key and display the public key
2. Add the SSH key to your GitHub account at https://github.com/settings/ssh/new
3. Press Enter to continue when prompted
4. Enter your GitHub username and email when asked

**After installation:**
Restart your shell or run `source ~/.bashrc` to ensure all PATH changes take effect.

**Created directories:**
- `~/projects` - For code projects
- `~/scripts` - For utility scripts
- `~/bin` - For personal binaries (added to PATH)

## Recent Updates

### 2025-07-21 - Development Environment Setup Script
- Added automated setup script for new development environments
- Includes installation of Git, Node.js, uv, and Claude Code
- Automated GitHub SSH key generation and configuration
- Creates standardized development directory structure
- Configures environment variables and PATH settings

## Usage

Each configuration can be used independently or as part of a complete development environment setup using the provided scripts.
