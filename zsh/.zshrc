# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/shaho/.oh-my-zsh"

plugins=(git)

source $ZSH/oh-my-zsh.sh
# -------
# Aliases
# -------
# alias c="code ."
alias c="code ."
alias o="open ."
alias cc="clear"

alias n="npm start"
alias ni="npm install"
alias nl="npm list -g --depth=0"

alias dev="yarn run dev"
alias s="yarn start"
alias t="yarn test"
alias yd="yarn develop"

alias b="cd .."
alias bb="cd ../../"
alias lsa="ls -al"
alias ls1="ls -1"
alias d="cd /Users/shaho/Desktop/dev"

alias z="cd /Users/shaho && code .zshrc"

# ----------------------
# GIG Aliases
# ----------------------
alias gt="cd /Users/shaho/Desktop/dev/floyd/themes/gatsby-themes"
alias gtc="cd /Users/shaho/Desktop/dev/floyd/themes/gatsby-themes && code ."
alias gtcc="cd /Users/shaho/Desktop/dev/floyd/themes/gatsby-themes && code-insiders ."
alias ow="cd /Users/shaho/Desktop/dev/floyd/widgets/odds-widget"

alias gpo="git pull origin develop"
alias gcd="git checkout develop"

# ----------------------
# Git Aliases
# ----------------------
alias gi="git init"
# alias gs="git status"
alias gl="git log"
alias gb="git branch"
alias gc="git commit -m "
alias gll="git log --pretty=oneline --abbrev-commit "
alias gllg="git log --oneline --graph"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias ga="git add -A"
alias gp="git pull"
alias gf="git fetch"
alias gpp="git push"
# alias gpa="git push all master"
# alias gfm="git pull all master"
# alias gmd="git merge all/dev"
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status'


# function gc () { 
#     git commit -m "$@"
# }

function mkcd() {
	mkdir $1 && cd $1
}

function gcc() { 
    git clone "$@"
}

function ws() {
    yarn workspace $1 develop
}

function gcn() {
    git checkout -b $1
}

function gcb() {
    git checkout $1
}

# ssh-add ~/.ssh/gig_rsa
# ssh -T git@git.ilcd.rocks

# echo `whoami`

eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
