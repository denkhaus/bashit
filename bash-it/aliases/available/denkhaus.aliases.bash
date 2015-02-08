
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
_docker_rm_image_match(){ 
 docker rmi -f $(docker images | grep $1 | tr -s " " | cut -d " " -f 3) 
}
_docker_stp_cnt_match(){ 
 docker stop $(docker ps | grep $1 | tr -s " " | cut -d " " -f 1) 
}

_docker_rm_img_untagged(){
 docker rmi -f $(docker images | grep '^<none>' | awk '{print $3}')
}

alias dclean=_docker_rm_img_untagged
alias docker_rm_img_match=_docker_rm_image_match
alias docker_rm_cnt_all='docker rm $(docker ps -a -q)'
alias docker_rm_cnt_all_force='docker rm -f $(docker ps -a -q)'
alias docker_stp_cnt_all='docker stop $(docker ps -q)'
alias docker_stp_cnt_match=_docker_stp_cnt_match

#tripwire
alias tw_check='sudo tripwire --check --interactive'
