if [ "$USER" = "root" ]
then CARETCOLOR="red"
else CARETCOLOR="blue"
fi

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

function flazz_git_prompt_info() {
  local ref
  [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]] || return 0
  ref=$(command git symbolic-ref HEAD 2>/dev/null) || \
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
  print -r -- "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function flazz_prompt_header() {
  local git_info=$(flazz_git_prompt_info)
  local profile=${AWS_PROFILE:-}
  if (( $+functions[aws_prompt_profile] )); then
    profile=$(aws_prompt_profile)
  fi
  [[ -n $git_info || -n $profile ]] || return 0
  # The empty prompt escape preserves the newline in command substitution.
  print -rn -- "$git_info"$'\n%{%}'
}

PROMPT='$(flazz_prompt_header)%(?..%F{9}⚠️ %?%f )%D{%H:%M:%S} %{${fg[green]}%}%3~ %{$reset_color%}%{${fg_bold[$CARETCOLOR]}%}%#%{${reset_color}%} '

RPS1='$(vi_mode_prompt_info) ${return_code}'

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}"

MODE_INDICATOR="%{$fg_bold[magenta]%}<%{$reset_color%}%{$fg[magenta]%}<<%{$reset_color%}"

# TODO use 265 colors
#MODE_INDICATOR="$FX[bold]$FG[020]<$FX[no_bold]%{$fg[blue]%}<<%{$reset_color%}"
