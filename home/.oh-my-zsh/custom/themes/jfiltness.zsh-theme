# This prompt uses nerdfont icons: https://nerdfonts.com/

PROMPT='${ret_status} %{$fg_bold[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}( %{$reset_color%}%{$fg_bold[red]%}\uf418 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[blue]%})%  %{$fg[red]%}\uf00d%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[blue]%}%) %{$reset_color%}%{$fg[green]%}\uf42e%{$reset_color%}"


