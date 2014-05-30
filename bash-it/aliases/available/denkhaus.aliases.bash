
# Some custom aliases for denkhaus

cite 'about-alias'
about-alias 'denkhaus abbreviations'

alias sag='sudo apt-get'
alias sagd='sag dist-upgrade'
alias sagi='sag install'
alias sagu='sag update'
alias sagug='sag upgrade'

alias saar='sudo add-apt-repository'

alias ac='apt-cache'
alias acs='ac search'
alias acsp='ac showpkg'

alias n='f -e edit' # quick opening files with nano
alias o='a -e xdg-open' # quick opening files with xdg-open

alias chu='sudo su - $1 -s /bin/bash'

alias grm='git reset --merge'

alias portuse='sudo netstat -nap | grep $1'
alias findbig='sudo du -h $1 | grep [0-9]G'

#virtualbox

_vbstart(){
  vboxmanage startvm $1 --type gui
 }

alias vbstart=_vbstart

_vbstop(){
  vboxmanage controlvm $1 poweroff
}

alias vbstop=_vbstop

alias megadn='megacmd sync mega:/exchange/ ~/Downloads/mega-exch/'
alias megaup='megacmd sync ~/Downloads/mega-exch/ mega:/exchange/'

_tmuxpload(){
  tmuxp load -y ~/.tmuxp/$1.yaml
}

alias tl=_tmuxpload

#docker
alias docker-rm-untagged-images='docker rmi $(docker images | grep "^<none>" | awk "{print $3}")'


#tripwire
alias tw-check='sudo tripwire --check --interactive'

#bashit
alias bashit-pull='chu bashit && git pull --all && exit'
alias bashit-push='chu bashit && git push --all && exit'
