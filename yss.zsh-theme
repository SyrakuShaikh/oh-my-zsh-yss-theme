# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood

# Time-stamp: <Sun, 10/09-2017 09:59:16 CST>
# Copyright (c) H.-K.Sun <spin.hk AT outlook DOT com>

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# Virtualenv: current working virtualenv
local virtualenv_info='$(ys_py_virtualenv_info)'
ys_py_virtualenv_info() {
    local virtualenv_path="$VIRTUAL_ENV"
    if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
        vir_info="$(basename $virtualenv_path)"
    elif which pyenv &> /dev/null; then
        vir_info="$(pyenv version | sed -e 's/ (set.*$//' | tr '\n' ' ' | sed 's/.$//')"
    fi
    if [[ -n $vir_info && $vir_info != 'system' ]]; then
        echo -n "${YS_VCS_PROMPT_PREFIX1}py${YS_VCS_PROMPT_PREFIX2}"
        echo -n "${vir_info}"
        echo -n "$YS_VCS_PROMPT_SUFFIX"
    else
        echo -n ""
    fi
}

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
	# make sure this is a hg dir
    if [ -d '.hg' ]; then
        echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
        echo -n $(hg branch 2>/dev/null)
        if [ -n "$(hg status 2>/dev/null)" ]; then
            echo -n "$YS_VCS_PROMPT_DIRTY"
        else
            echo -n "$YS_VCS_PROMPT_CLEAN"
        fi
        echo -n "$YS_VCS_PROMPT_SUFFIX"
    fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# % ys @ ys-mbp in ~/.oh-my-zsh on git:master x [21:47:42] C:0
# $
PROMPT="\
\033[1m%{$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n)\
%{$fg[white]%}@\
%{$fg[green]%}%m \
%{$fg[white]%}in \
\033[1m%{$fg[yellow]%}%~%{$reset_color%}\
${virtualenv_info}\
${hg_info}\
${git_info} \
%{$fg[white]%}[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
