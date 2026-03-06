#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if a folder is set

if [[ -s $CURRENT_DIR/markdown_dir.txt ]]; then

    MARKDOWN_DIR=$(cat $CURRENT_DIR/markdown_dir.txt)

else

    MARKDOWN_DIR=$(
        if command -v fd >/dev/null && command -v tree >/dev/null; then
            fd --type d --hidden --follow --exclude .git . /home/ 2>/dev/null | fzf --preview 'tree -C {}' --header 'Choose a folder'
        else
            find /home/ -mindepth 1 -type d -not -path '*/\.*' 2>/dev/null | fzf --preview 'ls -la --color=always {}' --preview-window=right:40% --header 'Choose a folder'
        fi
    )

    printf "$MARKDOWN_DIR" > $CURRENT_DIR/markdown_dir.txt

fi


if [[ -z "$MARKDOWN_DIR" ]]; then
    echo "No folder saved/selected!" && exit
fi

print_md_section_from_heading(){
	HEADING="$(echo "${1}" | sed -E 's:\r::' | sed -E 's:\s+$::')"	# Trim trailing newlines and spaces;	
	sed -nE "/^\s*${HEADING}/,$ p" $2 | glow -s dark -p			# Print everything after the matching heading
}

print_md_section(){
    MSG="'Choose a heading (File: ${MARKDOWN_DIR}$1)'"
    HEADING="$(grep -E '^\s{0,3}#+' $1 | sort -k 2 -r | fzf --preview "grep -A 100 {} $1 " --header ${MSG})"
	print_md_section_from_heading "${HEADING}" "${1}"
}

MSG="'Choose a file (Folder: ${MARKDOWN_DIR})'"
FILE="$(find $MARKDOWN_DIR -type f \( -iname "*.md" -o -iname "*.markdown" \) | fzf --header ${MSG} )"


if [[ ! -z "$FILE" ]]; then
    print_md_section $FILE
fi


