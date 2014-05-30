cite about-plugin
about-plugin 'denkhaus tools'

unix_ts2dt()
{
	about 'echo DateTime for unix timestamp'
	group 'base'
	echo `date -d  @$1`
}

get_js_val()
{
	c='import json,sys;obj=json.load(sys.stdin);print obj["theOb"]'	
	c=${c/theOb/$2}
	echo $1 | python -c "$c"
}

git_isdirty(){
	[[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
}

git_autopush(){
	epoch=$(date +%s)
	git_isdirty && git commit -am "autopush @ $epoch"
	git push --all
}

# From: http://julienrenaux.fr/2013/10/04/how-to-automatically-checkout-the-latest-tag-of-a-git-repository/
git_checkout_latest_tag()
{
        about 'Checkout the latest tag from repository'
        group 'git'

	# Get new tags from the remote
	git fetch --tags
 
	# Get the latest tag name
	local latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
 	
	if [ ! -z $latestTag ] 
	 then
		# Checkout the latest tag
		git checkout $latestTag
	 else
		echo 'The repository has no tags!'
	fi
}

cn_extract_error()
{
	json=$(echo $1 | grep -oP '\{[^\}]*\}')
	echo $(get_js_val "$json" message)
}

cn_unlock()
{
	about 'Unlock a cryptocurrency wallet'
        group 'cryptocur'

	if [[ -z $2 ]]; then
		read -s -p "Enter password:" pass
	else
		pass=$2
        fi

	if [[ -z $pass ]]; then
		echo "No unlock passphrase specified."
	        return
	fi

	if [[ -z $1 ]]; then
		timeout=60
	else
		timeout=$1
	fi
	
	echo "Try unlocking wallet with timeout $timeout seconds"
	ret=$($USER walletpassphrase $pass $timeout 2>&1)

	if [[ -z $ret ]]; then
                echo "Unlocking successfull."
        else
                echo "Unlocking $(cn_extract_error "$ret")"
        fi
}


cn_lock()
{
	about 'Lock a cryptocurrency wallet'
        group 'cryptocur'

	echo "Try to lock wallet."
	ret=$($USER walletlock 2>&1)

	if [[ -z  $ret ]]; then
                echo "Locking successfull"
        else
                echo "Locking :: $(cn_extract_error "$ret")"
        fi
}


cn_is_txid()
{
	if [ -n $1 ] && [ `expr "$1" : '[0-9a-fA-F]\{64\}'` -eq ${#1} ]; then		
		return 0
	else
		return 1
	fi
}

cn_send()
{
	about 'send amout to address'
        group 'cryptocur'

	local address=$1
	local amount=$2

	if [[ -z $address ]]; then
                read -p "Enter receiving address:" address
        fi

 	if [[ -z $address ]]; then
                echo "No receiving address specified."
                return
        fi

        if [[ $amount -le 0 ]]; then
		echo "Amount greater 0.0 is required."
		return
        fi

	cn_unlock 
	$USER senddtoaddress $address $amount &> /dev/null
	
	if [ ${cn_is_txid ?} ]; then
		echo "Sending successfull! TxId :: $?"
	else
		echo "Sending error :: $?"
	fi

	cn_lock	
}


#### RANDOM FUNCTIONS #####
# awesome!  CD AND LA. I never use 'cd' anymore...
function cl(){ cd "$@" && la; }
# Two standard functions to change $PATH
add_path() { export PATH="$PATH:$1"; }
add_pre_path() { export PATH="$1:$PATH"; }


# Check if given url is giving gzipped content
#
#   $ gzipped http://simplesideias.com.br
#
gzipped() {

 about 'Check if given url is giving gzipped content'
 group 'net'	

  local r=`curl -L --write-out "%{size_download}" --output /dev/null --silent $1`
  local g=`curl -L -H "Accept-Encoding: gzip,deflate" --write-out "%{size_download}" --output /dev/null --silent $1`
  local message

  local rs=`expr ${r} / 1024`
  local gs=`expr ${g} / 1024`

  if [[ "$r" =  "$g" ]]; then
    message="Regular: ${rs}KB\n\033[31m → Gzip: ${gs}KB\033[0m"
  else
    message="Regular: ${rs}KB\n\033[32m → Gzip: ${gs}KB\033[0m"
  fi

  echo -e $message
  return 0
}



# Open a new SSH tunnel.
#
#   $ tunnel                    # Open dynamic proxy for my own domain
#   $ tunnel example.com 2812   # Redirect localhost:2812 to example.com:2812, without exposing service/port.
#   $ tunnel -h                 # Show help
#
tunnel() {
  if [[ $# = 0 ]]; then
    echo "Opening dynamic tunnel to simplesideias..."
    sudo ssh -vND localhost:666 fnando@simplesideias.com.br
  elif [[ $# = 2 ]]; then
    echo "Forwarding port $2 to $1..."
    ssh -L $2:localhost:$2 $1
  else
    echo "Usage:"
    echo "  tunnel                         # Use simplesideias as proxy server"
    echo "  tunnel example.com 2345        # Redirect port from localhost:2345 to example.com"
    echo ""
    echo "Common ports:"
    echo "  2812: Monit"
    echo "  5984: CouchDB"
  fi
}



# Compress with tar + bzip2
function bz2 () {
  tar cvpjf $1.tar.bz2 $1
}

# Google the parameter
function google () {
  links http://google.com/search?q=$(echo "$@" | sed s/\ /+/g)
}

function dumptcp() {
 # TCPDUMP all the data on port $1 into rotated files /tmp/results.  Note,
 # this can get VERY large
  sudo /usr/sbin/tcpdump -i any -s0 tcp port $1 -A -w /tmp/results -C 100
}


# Repeat a command N times.  You can do something like
#  repeat 3 echo 'hi'
function repeat()
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do
        eval "$@";
    done
}

# Lets you ask a command.  Returns '0' on 'yes'
#  ask 'Do you want to rebase?' && git svn rebase || echo 'Rebase aborted'
function ask()
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

#Simple blowfish encryption
function blow()
{
    [ -z "$1" ] && echo 'Encrypt: blow FILE' && return 1
    openssl bf-cbc -salt -in "$1" -out "$1.bf"
}

function fish()
{
    test -z "$1" -o -z "$2" && echo \
        'Decrypt: fish INFILE OUTFILE' && return 1
    openssl bf-cbc -d -salt -in "$1" -out "$2"
}


# my search function
search() {
  find . -type f -exec grep -il $1 {} \;
}
