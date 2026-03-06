#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


if [[ -s $CURRENT_DIR/markdown_dir.txt && "${1}" != 'reset' ]]; then

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

# print_md_section_from_heading(){
#
#     # glow "$FILE" | grep '^#' | fzf --preview 'glow --width 80 --pager "$FILE" --from-line {+2}' --preview-window=up:70%
#
# 	HEADING="$(echo "${1}" | sed -E 's:\r::' | sed -E 's:\s+$::')"	# Trim trailing newlines and spaces;	
# 	sed -nE "/^\s*${HEADING}/,$ p" $2 | glow -s dark -p			# Print everything after the matching heading
# }

print_md_section(){
    BASE_FILE=$(basename "${1}")
    MSG="Choose a heading (File: ${BASE_FILE})"
    HEADING="$(grep -E '^\s{0,3}#+' $1 | sort -k 2 -r | fzf -m --preview "grep -A 100 {} $1 " --preview-window right:50% --header "${MSG}")"
	# print_md_section_from_heading "${HEADING}" "${1}"
	HEADING="$(echo "${HEADING}" | sed -E 's:\r::' | sed -E 's:\s+$::')"	# Trim trailing newlines and spaces;	
	sed -nE "/^\s*${HEADING}/,$ p" $1 | glow -s dark -p			# Print everything after the matching heading

}

BASE_DIR=$(basename "${MARKDOWN_DIR}")
MSG="Choose a file (Folder: ${BASE_DIR})"
if command -v fd >/dev/null; then
    FILE="$(fd -H --type file -e md -e markdown . ${MARKDOWN_DIR} | fzf --header "${MSG}" --preview-window down:65% --preview 'glow -p --width=80 {} ' )"
else
    FILE="$(find $MARKDOWN_DIR -type f \( -iname "*.md" -o -iname "*.markdown" \) | fzf --header "${MSG}" )"
fi


if [[ ! -z "$FILE" ]]; then
    print_md_section $FILE
fi


