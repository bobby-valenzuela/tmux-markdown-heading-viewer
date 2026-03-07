#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FZF_DEFAULT_OPTS="\
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --border=rounded --info=inline"
FILE=

if [[ -s $CURRENT_DIR/markdown_dir.txt && "${1}" != 'reset' ]]; then

    MARKDOWN_DIR=$(cat $CURRENT_DIR/markdown_dir.txt)

else

    MARKDOWN_DIR=$(
        if command -v fd >/dev/null && command -v tree >/dev/null; then
            fd --type d --hidden --follow --exclude .git . /home/ 2>/dev/null | fzf $(printf "${FZF_DEFAULT_OPTS}") --layout=reverse --preview 'tree -C {}' --header 'Choose a folder' --preview-window=down:40%
        else
            find /home/ -mindepth 1 -type d -not -path '*/\.*' 2>/dev/null | fzf $(printf "${FZF_DEFAULT_OPTS}")  --layout=reverse --preview 'ls -la --color=always {}' --preview-window=down:40% --header 'Choose a folder'
        fi
    )

    printf "$MARKDOWN_DIR" > $CURRENT_DIR/markdown_dir.txt

fi


if [[ -z "$MARKDOWN_DIR" ]]; then
    echo "No folder saved/selected!" && exit
fi


print_md_section(){
    BASE_FILE=$(basename "${FILE}")

    HEADING_COUNT=$(grep -E '^\s{0,3}#+' "$FILE" | wc -l)

    FILENAME_ESC="$(printf $FILE | sed 's/\s/\ /g')"

    if [ "$HEADING_COUNT" -gt 0 ]; then
        MSG="Choose a heading (File: ${BASE_FILE})"
        HEADING="$(grep -E '^\s{0,3}#+' $FILE | fzf $(printf "${FZF_DEFAULT_OPTS}") --layout=reverse -m --preview "grep -A 100 {} $FILE " --preview-window down:50% --header "${MSG}")"
        HEADING="$(echo "${HEADING}" | sed -E 's:\r::' | sed -E 's:\s+$::')"	# Trim trailing newlines and spaces;	
        sed -n "/^${HEADING}/,$ p" "$FILE" | glow -s dark -p			# Print everything after the matching heading
    else
        glow -s dark -p "$FILE"
    fi

}

BASE_DIR=$(basename "${MARKDOWN_DIR}")
MSG="Choose a file (Folder: ${BASE_DIR})"
if command -v fd >/dev/null; then
    FILE="$(fd -H --type file -e md -e markdown . ${MARKDOWN_DIR} | fzf $(printf "${FZF_DEFAULT_OPTS}")   --layout=reverse --header "${MSG}" --preview-window down:60% --preview 'glow -p --width=80 {} ' )"
else
    FILE="$(find $MARKDOWN_DIR -type f \( -iname "*.md" -o -iname "*.markdown" \) | fzf $(printf "${FZF_DEFAULT_OPTS}")   --header "${MSG}" )"
fi


if [[ ! -z "$FILE" ]]; then
    print_md_section
fi


