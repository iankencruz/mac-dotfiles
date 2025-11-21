# ==============================================================================
# 1. Initializations (Visuals, Prompt, & Tools)
# ==============================================================================

# --- Fastfetch ---
if type -q fastfetch
    fastfetch
end

# --- Oh My Posh ---
if type -q oh-my-posh
    # IMPORTANT: Change this path to where your actual OMP theme is located
    set -l OMP_THEME_PATH "/Users/iancruz/dotfiles/.config/ohmyposh/zen.toml" 

    if test -f "$OMP_THEME_PATH"
        oh-my-posh init fish --config "$OMP_THEME_PATH" | source
    else
        echo "WARNING: Oh My Posh theme file not found at $OMP_THEME_PATH"
    end
end

# --- zoxide ---
# Fish handles its init with a standard function call
if type -q zoxide
    zoxide init fish | source
end

# --- FZF Keybindings (History Search: Ctrl+R) ---
if type -q fzf

    # Set up fzf key bindings
    fzf --fish | source

    # The history search keybinding is defined as a Fish function
    function fzf_history_widget
        # The history command output is filtered by fzf.
        # This is a direct translation of the Zsh history widget logic.
        history | fzf --no-sort --query="$LBUFFER" | read -l selected_command
        if [ -n "$selected_command" ]
            # Fish uses commandline to modify the input buffer
            commandline -r $selected_command
        end
    end
    # Bind the function to Ctrl+R
    bind \cr fzf_history_widget

    # --- FZF File/Directory Finder with Preview Widget (Ctrl+F) ---
    function fzf_file_preview_widget
        set -l preview_cmd
        if type -q bat
            # Show file content with syntax highlighting and line numbers.
            set preview_cmd "bat --color=always --style=numbers --line-range :200 {}"
        else
            # Fallback to simple cat.
            set preview_cmd "cat {}"
        end

        set -l result (
            # Use find to get files and directories, excluding typical junk/hidden folders
            find . -mindepth 1 \( -path '*/.git' -o -path '*/.cache' -o -path '*/node_modules' \) -prune \
            -o -type d -print \
            -o -type f -print \
            | fzf --ansi --preview "$preview_cmd" --height=80% --layout=reverse --border \
                --prompt="File/Dir > "
        )

        # Handle the selection
        if test -n "$result"
            if test -d "$result"
                # If directory, insert 'cd <path>'
                commandline "cd $result"
            else
                # Otherwise, append the file path
                commandline (commandline)$result
            end
        end
    end

    # Bind the custom widget to Ctrl+F
    bind \cf fzf_file_preview_widget
    
    # Optional: Set custom fzf options here (e.g., theme)
    # set -gx FZF_DEFAULT_OPTS '--color=...'
end

# --- Yazi File Manager Function ---
# This is a direct translation of the Zsh function
function y
	set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
    set -l cwd (cat $tmp)
	if test -n "$cwd"; and test "$cwd" != "$PWD"
        cd -- "$cwd"
    end
	rm -f -- "$tmp"
end

# Set the preferred editor globally
set -gx EDITOR "nvim"

# ==============================================================================
# 2. Hooks and Basic Settings
# ==============================================================================

# --- Directory Change Hook (eza) ---
# In Fish, the equivalent of the chpwd hook is the 'fish_postexec' event 
# combined with a check for the last executed command. However, the simplest 
# way to emulate a chpwd hook is to overwrite the 'cd' function. 
# Since zoxide is initializing, the safest way is to use a listener on $PWD.
# Fish's recommended way is using a function called 'fish_post_cd'.

function fish_post_cd
    if type -q eza
        eza -alh --icons=always
    end
end

# --- History Configuration ---
# Fish manages history automatically, but these ensure the variables are set
set -gx HISTSIZE 10000
set -gx SAVEHIST 10000
# Fish does not need manual compinit or zmodload

# --- Mouse Interactivity ---
# Fish handles mouse interactivity automatically if the terminal supports it.
# No manual escape codes are usually necessary.

# --- Custom Function for Git Diff ---
function batdiff
    git diff --name-only --relative --diff-filter=d -z | xargs -0 bat --diff
end

# ==============================================================================
# 3. SHELL Aliases
# ==============================================================================
# In Fish, aliases are created as simple wrapper functions for better handling.

# Editor Aliases
abbr --add vim nvim
abbr --add vi nvim

# Directory Listing Aliases (using eza)
alias ls='eza -alh --icons=always'
alias tree='eza -al --tree --icons=always'
alias btree='eza -al --tree --icons=always'

# System Navigation/Management
# Alias 'cd' is handled by zoxide init, so we skip it.
abbr --add up 'z ..' # Use z for smart navigation
abbr --add path 'echo $PATH'
# The 'reload' alias/function:
function reload
    source ~/.config/fish/config.fish
end

# Utility Aliases
abbr --add cat bat
abbr --add lg lazygit
