## キーバインドをviにセット
bindkey -v
export KEYTIMEOUT=8

## "fd" = [esc]
bindkey "fd" vi-cmd-mode

## phpbrew
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

## nodenv
eval  "$(nodenv init -)"

## goenv, go
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

## pyenv pyenv-virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

## コマンドエイリアス
alias reshell="exec -l $SHELL"
alias ll="ls -la"

## git 関係
alias ga="git add"
alias gmt="git commit -m"
alias gsw="git switch"
alias gswc="git switch -c"
alias gswC="git switch -C"
alias gb="git branch"
alias gbD="git branch -D"
alias gpush="git push"
alias gpull="git pull"

## cd
alias ...="cd ../../"
alias ....="cd ../../../"
setopt auto_cd
setopt pushd_ignore_dups

## 色
autoload colors
colors
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
alias ls="gls --color" # alias ls="ls -GF"
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

## 補完
autoload -Uz compinit
compinit

## ターミナルのマシン名とユーザ名非表示
PS1="%{$fg[blue]%}%1~%{$reset_color%} $ "
# PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

## カーソルモードで文字を消せるように
bindkey "^?" backward-delete-char

## カーソル関連
# mode切替でカーソルの形を切替
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
           [[ $1 = 'block' ]]; then
        echo -ne '\e[2 q'

    elif [[ ${KEYMAP} == main ]] ||
             [[ ${KEYMAP} == viins ]] ||
             [[ ${KEYMAP} = '' ]] ||
             [[ $1 = 'beam' ]]; then
        echo -ne '\e[6 q'
    fi
}
zle -N zle-keymap-select
# beamカーソルで開始
echo -ne '\e[6 q'
# 新しいタブもbeamカーソルで開始
preexec() {
    echo -ne '\e[6 q'
}
