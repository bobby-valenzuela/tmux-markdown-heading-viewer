# tmux-markdown-heading-viewer
Interactively select a Markdown heading from a file and then display the markdown file started at that section of the document in your terminal.


## Requirements

- `tmux`
- `fzf`
- `bash`
- `glow`

Optional to have (improved setup)  
- fd  
- tree  

## Installation

### Install using TPM

Put this in your configuration file,

```sh
set -g @plugin 'kenos1/tmux-cht-sh'
```

### Install manually using git

1. Clone the repository

```sh
git clone https://github.com/kenos1/tmux-cht-sh ~/clone/path
```

2. Put this line in your config

```sh
run-shell ~/clone/path/tmux-cht-sh.tmux
```

3. Restart `tmux`

## Usage

To invoke the cheatsheet use the keybind <kbd>prefix</kbd>–<kbd>M</kbd>

## Configuration

Change the pager by changing your `PAGER` environment variable. This means adding this to your shell config:

```sh
export PAGER="less"
```

<br />


Set the root folder in which your markdown files are located  

```sh
export MARKDOWN_DIR=/home/user/my_notes/
```
