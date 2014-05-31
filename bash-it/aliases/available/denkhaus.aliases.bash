
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
alias docker_rm_untagged_images='docker rmi $(docker images | grep "<none>" | tr -s " " | cut -d " " -f 3)'
alias docker_rm_images_by_match='docker rmi $(docker images | grep $1 | tr -s " " | cut -d " " -f 3)'                                                                                                               
alias docker_rm_container='docker rm $(docker ps -a -q)'

#tripwire
alias tw_check='sudo tripwire --check --interactive'
