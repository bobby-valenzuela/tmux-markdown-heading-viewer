#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if a folder is set

if [[ -s $CURRENT_DIR/markdown_dir.txt ]]; then

    MARKDOWN_DIR=$(
        if command -v fd >/dev/null && command -v tree >/dev/null; then
            fd --type d --hidden --follow --exclude .git . /home/ 2>/dev/null | fzf --preview 'tree -C {}'
        else
            find /home/ -mindepth 1 -type d -not -path '*/\.*' 2>/dev/null | fzf --preview 'ls -la --color=always {}' --preview-window=right:40%
        fi
    )

    print "$MARKDOWN_DIR" > $CURRENT_DIR/markdown_dir.txt

else
    MARKDOWN_DIR=$(cat $CURRENT_DIR/markdown_dir.txt)
fi


if [[ -z "$MARKDOWN_DIR" ]]; then
    echo "No 'MARKDOWN_DIR' variable set" && exit
fi

print_md_section_from_heading(){
	HEADING="$(echo "${1}" | sed -E 's:\r::' | sed -E 's:\s+$::')"	# Trim trailing newlines and spaces;	
	sed -nE "/^\s*${HEADING}/,$ p" $2 | glow -s dark -p			# Print everything after the matching heading
}

print_md_section(){
	HEADING="$(grep -E '^\s{0,3}#+' $1 | sort -k 2 -r | fzf --preview "grep -A 100 {} $1  ")"
	print_md_section_from_heading "${HEADING}" "${1}"
}

FILE="$(find $MARKDOWN_DIR -type f \( -iname "*.md" -o -iname "*.markdown" \) | fzf )"


if [[ ! -z "$FILE" ]]; then
    print_md_section $FILE
fi


