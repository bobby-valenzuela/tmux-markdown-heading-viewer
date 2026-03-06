#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
unbind-key -T prefix m          # remove the default "mark pane"
unbind-key -T prefix M          # optional: if you don't use unmark either
tmux bind-key M run-shell "tmux display-popup -y 20 -w 80% -h 90% -E bash $CURRENT_DIR/bin/tmux-markdown-heading-viewer.sh"

