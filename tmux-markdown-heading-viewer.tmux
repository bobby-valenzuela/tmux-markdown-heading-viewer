#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux unbind-key -T prefix m         
tmux unbind-key -T prefix M        
tmux bind-key m run-shell "tmux display-popup -y 20 -w 80% -h 90% -E bash $CURRENT_DIR/bin/tmux-markdown-heading-viewer.sh"
echo "[TMUX] CURRENT_DIR: $CURRENT_DIR">> /home/bobby/.tmux/plugins/tmux-markdown-heading-viewer/log
