# ==============================================================================
# 1. Startup Information
# ==============================================================================

# Run fastfetch when the shell starts
if command -v fastfetch &> /dev/null; then
    fastfetch
fi

# Initialize Oh My Posh and point it to your custom theme config.
if command -v oh-my-posh &> /dev/null; then
    # IMPORTANT: Change this path to where your actual OMP theme is located
    OMP_THEME_PATH="/Users/iancruz/dotfiles/.config/ohmyposh/zen.toml" 

    if [ -f "$OMP_THEME_PATH" ]; then
        eval "$(oh-my-posh init zsh --config "$OMP_THEME_PATH")"
    else
        # Optional: Print a warning if the theme file is missing
        echo "WARNING: Oh My Posh theme file not found at $OMP_THEME_PATH"
    fi


fi





# Initialize zoxide (if installed). 
# This automatically replaces the 'cd' command with 'z' for smart navigation.
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi


# --- FZF configurations
if command -v fzf &> /dev/null; then

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

    # =======================================================
    # 1. History Search Widget (Ctrl+R)
    # =======================================================
    fzf-history-widget() {
        # The history command output is filtered by fzf.
        LBUFFER=$(history -n -r 1 | fzf --no-sort +m -q "$LBUFFER" | sed 's/^[[:digit:]]*[[:space:]]*//' )
        zle redisplay
    }
    zle -N fzf-history-widget
    bindkey '^R' fzf-history-widget


    # =======================================================
    # 2. File/Directory Finder with Preview Widget (Ctrl+F)
    # =======================================================
    fzf-file-preview-widget() {
        # Define the preview command: use 'bat' for highlighting, fallback to 'cat'.
        local preview_cmd
        if command -v bat &> /dev/null; then
            # Show file content with syntax highlighting and line numbers.
            preview_cmd="bat --color=always --style=numbers --line-range :200 {}"
        else
            # Fallback to simple cat.
            preview_cmd="cat {}"
        fi

        # Execute FZF to find files and directories
        local result
        result=$(
            # Use find to get files and directories, excluding typical junk/hidden folders
            # Add -prune / -o to fine-tune exclusions (e.g., skip .git) for better performance
            find . -mindepth 1 \( -path '*/.git' -o -path '*/.cache' -o -path '*/node_modules' \) -prune \
            -o -type d -print \
            -o -type f -print \
            | fzf --ansi --preview "$preview_cmd" --height=80% --layout=reverse --border \
                --prompt="File/Dir > "
        )

        # Handle the selection
        if [[ -n "$result" ]]; then
            # If the selected item is a directory, insert 'cd <path>'
            if [[ -d "$result" ]]; then
                LBUFFER="cd $result"
            else
                # Otherwise, insert the file path
                LBUFFER="$LBUFFER $result"
            fi
        fi

        zle redisplay
    }

    # Bind the custom widget to Ctrl+F
    zle -N fzf-file-preview-widget
    bindkey '^F' fzf-file-preview-widget
    
    # Optional: Set custom fzf options here (e.g., theme)
    # export FZF_DEFAULT_OPTS='...'
fi




# --- Open Yazi terminal file manager just with y
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


# ==============================================================================
# 2. Hooks and Basic Settings
# ==============================================================================


export EDITOR="nvim"


# List contents of directory when cd'ing using eza
# -a = hidden, -l = list, -h headers, --icons show icons or not
function chpwd() {
  eza -alh --icons=always
}

# Enable basic auto-completion
autoload -Uz compinit
compinit

# Enable history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000



batdiff() {
    git diff --name-only --relative --diff-filter=d -z | xargs -0 bat --diff
}



# ==============================================================================
# 3. SHELL Aliases
# ==============================================================================

# Editor Aliases
alias vim='nvim'          # Use neovim when you type 'vim'
alias vi='nvim'           # Use neovim when you type 'vi'

# Directory Listing Aliases (using eza)
alias ls='eza -alh --icons=always'
alias la='eza -a --icons=always'

# System Navigation/Management
alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
alias up='cd ..'
alias path='echo $PATH'
alias reload='source ~/.zshrc' # Quick way to apply changes to this file

# use bat instead of cat for better file output formatting
alias cat='bat'

# LazyGit Git manager
alias lg='lazygit'


# Python 
alias python='python3'


# ==============================================================================
# 3. Exports
# ==============================================================================

export PATH="$(go env GOPATH)/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"




# ==============================================================================
# 4. Zsh Plugins
# ==============================================================================

# Initialize zsh-autosuggestions (must be loaded after compinit and before custom widgets)
# IMPORTANT: Change the path below if your installation location is different!
if [ -f "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Common path for Oh My Zsh installations
elif [ -f "$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
    # Fallback/Warning (optional)
    # echo "WARNING: zsh-autosuggestions not found in common paths."
    :
fi

plugins=(zsh-autosuggestions)
