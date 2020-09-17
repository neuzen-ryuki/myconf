
# ---------------------------------------------- Python ------------------------------------------
## pyenv from homebrew
export PYENV_ROOT="/usr/local/var/pyenv"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/fujitaryuki/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/fujitaryuki/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/fujitaryuki/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/fujitaryuki/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
## <<< conda initialize <<<


# ---------------------------------------------- Go ----------------------------------------------
## goenv, go
# export GOENV_ROOT="$HOME/.goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
# eval "$(goenv init -)"
# export PATH="$GOROOT/bin:$PATH"
# export PATH="$PATH:$GOPATH/bin"


# ---------------------------------------------- PHP ---------------------------------------------
## phpbrew
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc


# ---------------------------------------------- Node --------------------------------------------
## nodenv
# eval  "$(nodenv init -)"


# ---------------------------------------------- Homebrew ----------------------------------------
## 強制的にbrewコマンドのパスを通してる
alias brew="PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin: brew"


# ---------------------------------------------- Common ----------------------------------------------
## viキーバインドの設定
bindkey -v
export KEYTIMEOUT=8
bindkey "fd" vi-cmd-mode
bindkey "^?" backward-delete-char

## 色
autoload -Uz colors
colors
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
alias ls="gls --color" # alias ls="ls -GF"
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

## 表示名
prompt() {
    # ブランチ名，カレントディレクトリだけ表示
    # PS1="`git-current-branch`%{$fg[blue]%}%1~%{$reset_color%} $ "
    PS1="`git-current-branch`%{$fg[blue]%}%1~%{$reset_color%} $ "
}
precmd_functions+=(prompt)
# ## プロンプトが表示されるたびにプロンプト文字列を評価、置換する
# setopt prompt_subst

## カーソル
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

## 自作コマンド
alias reshell="exec -l $SHELL"
alias ll="ls -la"

## cd
alias ...="cd ../../"
alias ....="cd ../../../"
setopt auto_cd
setopt pushd_ignore_dups

## simsパスを通す
export PATH="/usr/local/sbin:$PATH"


# ---------------------------------------------- Git ---------------------------------------------
## コマンド省略alias
alias ga="git add"
alias gmt="git commit -m"
alias gsw="git switch"
alias gswc="git switch -c"
alias gswC="git switch -C"
alias gb="git branch"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gdiff="git diff"
alias gdiffc="git diff --cached"
alias gpush="git push"
alias gpull="git pull"

## 補完
autoload -Uz compinit && compinit

## git ブランチ名を色付きで表示させるメソッド
function git-current-branch {
    local branch_name st branch_status
    if [ ! -e  ".git" ]; then
        # git 管理されていないディレクトリは何も返さない
        return
    fi
    branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        # 全て commit されてクリーンな状態
        branch_status="%{$fg[green]%}"
    elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
        # git 管理されていないファイルがある状態
        branch_status="%{$fg[red]%}?"
    elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
        # git add されていないファイルがある状態
        branch_status="%{$fg[red]%}+"
    elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
        # git commit されていないファイルがある状態
        branch_status="%{$fg[yellow]%}!"
    elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
        # コンフリクトが起こった状態
        echo "%{$fg[red]%}!(no branch)"
        return
    else
        # 上記以外の状態の場合
        branch_status="%{$fg[blue]%}"
    fi
    # ブランチ名を色付きで表示する
    echo "%{$branch_status%}[$branch_name]%{$reset_color%}"
}
