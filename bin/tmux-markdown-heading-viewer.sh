#!/usr/bin/env bash
print_md_section_from_heading(){
	HEADING="$(echo "${1}" | sed -E 's:\r::' | sed -E 's:\s+$::')"	# Trim trailing newlines and spaces;	
	sed -nE "/^\s*${HEADING}/,$ p" $2 | glow -s dark -p			# Print everything after the matching heading
}

print_md_section(){
	HEADING="$(grep -E '^\s{0,3}#+' $1 | sort -k 2 -r | fzf --preview "grep -A 100 {} $1  ")"
	print_md_section_from_heading "${HEADING}" "${1}"
}

if [[ -z "$MARKDOWN_DIR" ]]; then
    echo "No 'MARKDOWN_DIR' variable set" && exit
fi

FILE="$(find $MARKDOWN_DIR -type f \( -iname "*.md" -o -iname "*.markdown" \) | fzf )"


if [[ ! -z "$FILE" ]]; then
    print_md_section $FILE
fi


