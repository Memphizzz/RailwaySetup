#!/bin/bash

# Check if setup has already been completed
if [ -f ~/.init ]; then 
    echo "Setup already completed. Use '/app/storage/init' to attach to tmux."
    exit 0
fi

# Update packages and install required tools
echo "Installing Tools"
apt install -y wget tmux fish btop locales ripgrep ncdu exa nano

# Generate UTF-8 locale
echo "Generating Locale en_US.UTF-8"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

# Create tmux configuration
echo "Creating .tmux.conf"
cat > ~/.tmux.conf << 'TMUX_EOF'
set -g mouse on

set -g allow-rename off
setw -g automatic-rename off

set -g set-titles on
set -g default-terminal "screen-256color"
set -g set-titles-string '#{pane_current_command}'
set -g history-limit 5000
set -g visual-activity on
set -g status-position bottom
set -g renumber-windows on

set -g pane-border-style 'fg=colour235,bg=default'
set -g pane-active-border-style 'fg=colour240,bg=default'

set -g pane-border-status off
set -g base-index 0
set -g pane-base-index 0

set -g status-left '#[fg=white].:| #{client_tty} |:.'
set -g status-left-length 100
set -g status-right '#[fg=white].:| #[fg=green]%d.%m.%Y#[fg=white]∙#[fg=blue]%R#[fg=white]∙#h |:. '
set -g status-right-length 100
set -g status-style bg='#1A1A1A',fg=default

set -s escape-time 0

setw -g aggressive-resize on
setw -g monitor-activity off
setw -g window-status-format '#[fg=colour180,bold,bg=colour235,bold] #I #[fg=colour180,bold,bg=colour236,bold] #W '
setw -g window-status-current-format '#[fg=colour180,bold,bg=colour236,bold] #I #[fg=colour236,bold,bg=colour130,bold] #W '

set -g status-justify centre

set -g default-terminal "screen-256color"

if-shell "test -f /usr/bin/fish" "set -g default-shell /usr/bin/fish"
TMUX_EOF

# Create fish configuration
echo "Creating Fish config"
mkdir -p ~/.config/fish
cat > ~/.config/fish/config.fish << 'FISH_EOF'
alias ll 'ls -lah --color=always --group-directories-first'
alias lls 'ls -lahSr --color=always --group-directories-first'
alias ls exa
FISH_EOF

# Configure btop - start it briefly to generate config, then modify settings
echo "Creating btop config"
timeout 2s btop > /dev/null 2>&1 || true
if [ -f ~/.config/btop/btop.conf ]; then
    sed -i 's/theme_background = True/theme_background = False/' ~/.config/btop/btop.conf
    sed -i 's/proc_gradient = True/proc_gradient = False/' ~/.config/btop/btop.conf
fi

# Create the persistent init script
echo "Creating /app/storage/init script"
cat > /app/storage/init << 'INIT_SCRIPT'
#!/bin/bash
GIST_URL="https://raw.githubusercontent.com/Memphizzz/RailwaySetup/refs/heads/main/railway-setup.sh"

if [ -f ~/.init ]; then
    stty rows 45 cols 193
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LANGUAGE=en_US.UTF-8
    if tmux has-session 2>/dev/null; then
        tmux attach
    else
        tmux
    fi
else
    echo "Setup not completed. Running bootstrap..."
    stty rows 45 cols 193 && apt update && apt install -y curl && curl -s "$GIST_URL" | bash
fi
INIT_SCRIPT
chmod +x /app/storage/init

# Mark setup as completed
touch ~/.init

echo "Bootstrap setup completed!"
