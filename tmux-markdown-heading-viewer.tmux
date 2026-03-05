#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key M run-shell "tmux display-popup -y 20 -w 80% -h 90% -E $CURRENT_DIR/bin/tmux-markdown-heading-viewer.sh"
