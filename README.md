# Railway Development Environment Bootstrap

A self-bootstrapping development environment setup for Railway containers with tmux, fish shell, and essential development tools.

## Quick Start

### One-time setup:
```bash
stty rows 45 cols 193 && apt update && apt install -y curl && curl -s https://raw.githubusercontent.com/Memphizzz/RailwaySetup/refs/heads/main/railway-setup.sh | bash
```

### Subsequent connections:
```bash
/app/storage/init
```

## What it does

The bootstrap script automatically:

- **Installs essential packages**: tmux, fish, btop, ripgrep, ncdu, exa, nano, wget
- **Configures UTF-8 locale** for proper character support
- **Sets up tmux** with a custom configuration including mouse support and statusbar
- **Configures fish shell** with useful aliases (`ll`, `lls`, `ls` → `exa`)
- **Creates a persistent init script** at `/app/storage/init` for future use
- **Handles terminal sizing** for Railway's SSH implementation

## Features

### Tmux Configuration
- Mouse support enabled
- Custom statusbar with date/time and hostname
- Proper color support (256 colors)
- Fish shell as default when available
- Aggressive resize for better Railway SSH compatibility

### Fish Shell Aliases
- `ll` - Detailed listing with colors and directories first
- `lls` - Detailed listing sorted by size
- `ls` - Modern `exa` replacement for traditional `ls`

### Smart Session Management
The `/app/storage/init` script automatically:
- Attaches to existing tmux sessions if available
- Creates new tmux sessions if none exist
- Re-runs bootstrap if container was recreated

## Files Created

- `~/.tmux.conf` - Tmux configuration
- `~/.config/fish/config.fish` - Fish shell configuration  
- `/app/storage/init` - Persistent init script for future connections
- `~/.init` - Flag file to track setup completion (resets on container recreation)

## Railway-Specific Fixes

This setup addresses several Railway SSH implementation quirks:

- **Terminal size detection**: Manual `stty` configuration for proper sizing
- **Locale issues**: Explicit UTF-8 locale generation and environment setup
- **TTY problems**: Conditional tmux session handling for wonky terminal support

## Workflow

1. **First connection**: Run the one-liner bootstrap command
2. **Future connections**: Simply run `/app/storage/init`
3. **Container recreation**: `/app/storage/init` detects missing setup and re-bootstraps automatically

## Customization

Edit the script variables to customize:
- Terminal dimensions (currently 45 rows × 193 cols)
- Package list
- Tmux configuration
- Fish aliases

## Why This Approach?

- **Persistent**: The init script survives container restarts
- **Self-healing**: Automatically detects and fixes broken setups
- **Minimal**: One command gets you a full development environment
- **Railway-optimized**: Specifically designed for Railway's SSH quirks

