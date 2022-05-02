#!/bin/bash
# ~/.bashrc
# shellcheck disable=SC2034,SC1090,SC1094

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

source <(kitty + complete setup bash)

# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB':menu-complete

# Colour autocomplete suggestions
bind "set colored-stats on"

# Use up and down arrows to search command history
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# ===============
# HISTORY CONTROL
# ===============

shopt -s histappend

# Don't save duplicates
HISTCONTROL=ignoreboth:erasedups

# Append to the history file immediately with history -a
# Clear the current history in the shell session with history -c
# Reload the updated history back into the shell session with -r command
export PROMPT_COMMAND="history -a; history -c; history -r $PROMPT_COMMAND"

# If bpytop is installed then alias top to bpytop 
[ -e /usr/bin/bpytop ] && alias top="/usr/bin/bpytop"
alias ls='ls --color=auto -hv --group-directories-first'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Only use aliases according to the TERM we are in
case $TERM in
  xterm*|konsole*)
     alias vim='nvim';
     alias ssh='kitty +kitten ssh';;
  linux)
    alias vim="nvim";;
  *)
esac

command -v bat > /dev/null && alias cat='bat --paging=never' 
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

# Use bat as manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Default PS1 prompt if not using Starship
# export PS1="\[$(tput bold)\]\[$(tput setaf 4)\]╭─\[$(tput setaf 2)\u@\h \[$(tput setaf 4)\]\w \$(__git_prompt)\[$(tput setaf 4)\]\n╰>\[$(tput sgr0)\]"
export EDITOR="nvim"
export VISUAL="nvim"
export PATH=$PATH:~/.local/bin
export STARSHIP_CONFIG=~/.config/starship/config.toml
export BROWSER="qutebrowser"
export XDG_CONFIG_HOME="$HOME/.config"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP='Wayland / Qtile'
export XKB_DEFAULT_LAYOUT=us
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Start wm if on matching VT
[ "$(tty)" = "/dev/tty1" ] && exec qtile start -b wayland

# If not in xterm don't start starship
#case $TERM in
#  xterm*|konsole*)
#eval "$(starship init bash)";;
#  *)
#esac

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION

__git_check_untracked_changes() {
    local -i count
    count="$(git status --porcelain | sed -n '/??/p' | wc -l)"
    echo "$count"
}

__git_check_staged_changes() {
    local -i count
    count="$(git status --porcelain | sed -n '/A/p' | wc -l)"
    echo "$count"
}

__git_prompt() {
    [[ ! -d .git ]] && {
        # echo "[🔥no .git folder]"
        exit
    }

    local result="git "

    local branch
    branch="$(git branch --show-current)"
    local -i remote_branch_exists="$TRUE"

    result+="("

    if [[ -z $branch ]]; then
        result+="❌ not on branch"
    else
        [[ "$(git branch -r --contains "origin/$branch" 2> /dev/null)" == "" ]] && {
            result+="⚠️ "
            remote_branch_exists="$FALSE"
        }
        result+="$branch"
    fi

    (( remote_branch_exists == TRUE )) && {
        readarray -d $'\t' -t commit_difference < <(echo -e "$(git rev-list --left-right --count "origin/$branch...$branch")\t")

        local -i commits_behind="${commit_difference[0]}"
        local -i commits_ahead="${commit_difference[1]}"

        local commit_difference_info=

        (( commits_behind != 0 )) && commit_difference_info+="⬇️ $commits_behind"
        (( commits_ahead != 0 )) && {
            [[ -n $commit_difference_info ]] && commit_difference_info+=" "
            commit_difference_info+="⬆️ $commits_ahead"
        }

        [[ -n $commit_difference_info ]] && result+=" $commit_difference_info"
    }

    result+=")"

    local -i untracked_count
    local -i staged_count
    untracked_count="$(__git_check_untracked_changes)"
    staged_count="$(__git_check_staged_changes)"

    local status_info=
    
    (( untracked_count > 0 )) && {
        status_info+="❌untracked:$untracked_count"
    }
    (( staged_count > 0 )) && {
        [[ -n $status_info ]] && status_info+=" "
        status_info+="✅staged:$staged_count"
    }

    [[ -n $status_info ]] && result+="[$status_info]"

    echo "$(tput setaf 3)$result "
}

# If not in xterm don't start starship
case $TERM in
    xterm*|konsole*)
        export PS1="\[$(tput bold)\]\[$(tput setaf 4)\]╭─\[$(tput setaf 2)\u@\h \[$(tput setaf 4)\]\w \$(__git_prompt)\[$(tput setaf 4)\]\n╰>\[$(tput sgr0)\]";;
    *)
        export PS1="\[$(tput bold)\]\[$(tput setaf 2)\][\u@\h \w] \$(__git_prompt)\[$(tput sgr0)\]";;
esac
