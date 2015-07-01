# ==========================================================
# == .bashrc
# Loaded if interactive non-login shell

# Exit if not interactive
case "$-" in
    *i* ) ;;
    * ) return ;;
esac

# ----------------------------------------------------------
# -- Source

sourcefile '/etc/bashrc'
sourcefile "$HOME/perl5/perlbrew/etc/bashrc"
sourcefile "$HOME/.rvm/scripts/rvm"

if [ -d "$HOME/perl5" ]; then
    eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
fi

# ----------------------------------------------------------
# -- Interactive Shell Variables

case "$OSTYPE" in
    darwin*) export EDITOR="atom" ;;
    *) export EDITOR="vim" ;;
esac

export CLICOLOR=1

# Set ls colors
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx"
if type 'dircolors' > /dev/null 2>&1 && [ -f "$HOME/.dircolors-custom" ]; then
    eval $(dircolors ${HOME}/.dircolors-custom)
fi

# ----------------------------------------------------------
# -- Colors

# Foreground
function setfg() { tput setaf $1; }
function setbfg() { tput bold; tput setaf $1; }
function setbg() { tput setab $1; }

FGblack=$(setfg 0)
FGred=$(setfg 1)
FGgreen=$(setfg 2)
FGyellow=$(setfg 3)
FGblue=$(setfg 4)
FGmagenta=$(setfg 5)
FGcyan=$(setfg 6)
FGwhite=$(setfg 7)

# Bold Foreground
FGgray=$(setbfg 0)
FGbred=$(setbfg 1)
FGbgreen=$(setbfg 2)
FGbyellow=$(setbfg 3)
FGbblue=$(setbfg 4)
FGbmagenta=$(setbfg 5)
FGbcyan=$(setbfg 6)
FGbwhite=$(setbfg 7)

# Background
BGblack=$(setbg 0)
BGred=$(setbg 1)
BGgreen=$(setbg 2)
BGyellow=$(setbg 3)
BGblue=$(setbg 4)
BGmagenta=$(setbg 5)
BGcyan=$(setbg 6)
BGwhite=$(setbg 7)

RCLR=$(tput sgr0)

# ----------------------------------------------------------
# -- Shell Options

# Bash 4.00 specific options
if [[ $BASH_VERSINFO > 3 ]]; then
    shopt -s autocd # Allow cding to directories by typing the directory name
    shopt -s checkjobs # Defer exiting shell if any stopped or running jobs
    shopt -s dirspell # Attempts spell correction on directory names
fi

shopt -s cdable_vars # Allow passing directory vars to cd
shopt -s cdspell # Correct slight mispellings when cd'ing
shopt -s checkhash # Try to check hash table before path search
shopt -s cmdhist # Saves multi-line commands to history
shopt -s expand_aliases # Allows use of aliases
# shopt -s extdebug # Enables extra debug options like declare -F
shopt -s extglob # Extended pattern matching
shopt -s extquote # String quoting within parameter expansions
shopt -s histappend # Append history from a session to HISTFILE instead of overwriting
shopt -s no_empty_cmd_completion # Don't try to path search on an empty line
shopt -s nocaseglob # Case insensitive pathname expansion
shopt -s progcomp # Programmable completion capabilities
shopt -s promptvars # Expansion in prompt strings

set -o noclobber # Prevent clobbering of files with redirects

# ----------------------------------------------------------
# -- Aliases

# Filesystem
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias cdot="cd $HOME/.dotfiles"
alias cd="cd -P"
alias rm='rm -i'
alias cp='cp -ia'
alias mv='mv -i'
alias md='mkdir -p' # Make sub-directories as needed
alias rd='rmdir'

# System
alias _='sudo'
alias du='du -kh' # Human readable in 1K block sizes
alias df='df -kh' # Human readable in 1K block sizes with file system type
alias stop='kill -STOP'

# Editing - All roads lead to $EDITOR
alias vi=$EDITOR
alias svi="sudo $EDITOR"
alias nano=$EDITOR
alias emacs=$EDITOR

# Git
alias syncgit='for file in $(git status|grep modified|cut -d: -f2|tr -d " "); do scp $file lpetherbridge@devbox5.lotsofclouds.fonality.com:~/fcs/$file; done'

# Python
alias py='python'
alias dja='django-admin.py'
alias pym='python manage.py'
alias pyr='python manage.py runserver 0.0.0.0:10128'
alias pys='python manage.py syncdb'

# RPM
alias rpmi='rpm -ivh' # install rpm
alias rpmls='rpm -qlp' # list rpm contents
alias rpminfo='rpm -qip' # list rpm info

# Edit configurations
alias vv="vi $HOME/.vimrc"
alias vvrc="vi $HOME/.vim-runtime/vimrc"
alias vbo="vi $HOME/.bash_logout"
alias vbp="vi $HOME/.bash_profile"
alias vb="vi $HOME/.bashrc"
alias vs="vi $HOME/.screenrc"

# SSH
alias slp="ssh lp"
alias sshl='ssh-add -L' # List ssh-agent identities
alias st='ssh -A lpetherbridge@tech.fonality.com'
alias sw2='ssh -A lpetherbridge@web-dev2.fonality.com'
alias sfcsprod='ssh -A lpetherbridge@fcs-app1.fonality.com'
alias sfcs='ssh -A lpetherbridge@devbox5.lotsofclouds.fonality.com'
alias sfcsqa='ssh -A lpetherbridge@qa-app.lotsofclouds.fonality.com'
alias sfcsstg='ssh -A lpetherbridge@fcs-stg-app1.lax01.fonality.com'
alias sfcsstg2='ssh -A lpetherbridge@fcs-stg2-app1.lax01.fonality.com'
alias sfcsstgb='ssh -A lpetherbridge@fcs-stg-bastion.lax01.fonality.com'

# Sourcing
alias b="source $HOME/.bashrc"
alias bp="source $HOME/.bash_profile"
alias sa="source $HOME/.ssh/ssh-agent-$HOSTNAME"

# Screen
alias scls='screen -ls'
alias scr='screen -DR'
alias scm='screen -S "main"'

# Misc
alias g='grep -in'
alias da='date "+%Y-%m-%d %H:%M:%S"'
alias which='type -a'
alias path='echo -e ${PATH//:/"\n"}'
alias topmem='ps -eo pmem,pcpu,pid,user,args | sort -k 1 -r | head -20';
alias x='extract'
alias offenders='uptime;ps aux | perl -ane"print if \$F[2] > 0.9"'

# ls
if [[ "$OSTYPE" =~ 'darwin' ]]; then
    alias ls='ls -hFG' # Add colors for filetype recognition
else
    alias ls='ls -hF --color=tty'
fi
alias ll='ls -l' # Long listing
alias la='ls -Al' # Show hidden files
alias lx='ls -lXB' # Sort by extension
alias lk='ls -lSr' # Sort by size, biggest last
alias lc='ls -ltcr' # Sort by and show change time, most recent last
alias lu='ls -ltur' # Sort by and show access time, most recent last
alias lt='ls -ltr' # Sort by date, most recent last
alias lle='ls -al | less' # Pipe through 'less'
alias lr='ls -lR' # Recursive ls

# ----------------------------------------------------------
# -- Functions

# Echos and executes a command
_echodo () { echo "$*" && eval "$*"; }
_ask_yes_no() {
    echo -en "${FGred}$@ [y/n] ${RCLR}" ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}


# Converts SQL output to CSV formatting
sqlcsv() { cat | sed "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g"; }

# Syntax checks all new or modified perl files
schk() {
    for file in $(git status|egrep 'new file|modified'|egrep '(.pm|.pl)$' |cut -d: -f2|cut -d' ' -f4); do
        perl -c $file
    done
}

updatedb() {
    case "$OSTYPE" in
        darwin*) sudo /usr/libexec/locate.updatedb ;;
        *) updatedb ;;
    esac
}

# Various CD commands
export DEVHOME="$HOME/Dropbox/dev";
wa() { cd "$HOME/fcs/lib/Fap/WebApp/Action/"; }
f() { cd "$HOME/fcs/lib/Fap/"; }
s() { cd "$DEVHOME/websites"; }
d() { cd "$DEVHOME"; }
ios() { cd "$DEVHOME/ios"; }

tags() { ctags --exclude=@$HOME/.ctagsexclude; }

push() { _echodo "scp $* cael@lp:~/"; }
pull() { _echodo "scp cael@lp:~/$1 ./"; }

# mkdir & cd to it
mcd() { mkdir -p "$1" && cd "$1"; }

hist_stats() { history | cut -d] -f2 | sort | uniq -c | sort -rn | head; }

dl() {
    DEVDIR="${HOME}/.devlog/"
    YEAR=$(date "+%Y")
    FILE=$(date "+%Y_%m.txt")
    if [ ! -d "${DEVDIR}/${YEAR}" ]; then
        mkdir -p "${DEVDIR}/${YEAR}"
    fi
    ENTRY=$(date "+[%Y-%m-%d %H:%M:%S] ")" $*"
    echo ${ENTRY} >> "${DEVDIR}/${YEAR}/${FILE}"
}
jl() { command journal "$*"; }
jls() {
    # Allow to list past 7 days
    local date
    if [[ "$1" -gt 0 ]]; then
        date=$(date --date="$1 months ago" "+%Y-%m-%d")
    else
        date=$(date "+%Y-%m-%d")
    fi
    command journal -v $date | less
}

n() { echo -n -e "\033]0;$*\007"; export TERM_TITLE=$*; }
sn() { echo -n -e "\033k$*\033\\"; export SCREEN_TITLE=$*; }

_xtitle_do() { # sets screen/term title and executes command
    if [[ -f "$2" ]]; then
        title="$1 $(basename $2)"
    else
        title="$*"
    fi
    case "$TERM" in
        xterm* | rxvt ) echo -n -e "\033]0;$title\007" ;;
        screen* )      echo -n -e "\033k$title\033\\" ;;
        * ) ;;
    esac
    command "$@"
    case "$TERM" in
        xterm* | rxvt ) echo -n -e "\033]0;${TERM_TITLE:-${HOSTNAME}}\007" ;;
        screen* )      echo -n -e "\033k${SCREEN_TITLE:-${HOSTNAME}}\033\\" ;;
        * ) ;;
    esac
}

# Title setting commands
ssh() { _xtitle_do ssh "$@"; }
vim() { _xtitle_do vim "$@"; }
less() { _xtitle_do less "$@"; }

# Grep commands
h() { if [ -z "$*" ]; then history; else history | egrep "$@"; fi; }
pg() {
    CMD=''
    case "$OSTYPE" in
        darwin*) CMD='ps aux' ;;
        *) CMD='ps auxf' ;;
    esac
    if [ -z $1 ]; then
        $CMD
    else
        $CMD | grep $*
    fi
}

# Convert unix epoc to current timezone
unixtime() { date --date="1970-01-01 $* sec GMT"; }

myps() { ps -f $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

ra() {
    if _ask_yes_no "Restart ssh-agent?"; then
        case "$TERM" in
            screen* )
                echo "We're in a screen. I refuse to restart ssh-agent."
                ;;
            * )
                echo "Killing existing ssh-agent instances..."
                while [ $(ps aux | grep ssh-agent | grep -v grep | wc -l) -gt 0 ]; do
                    pkill -f ssh-agent
                done
                unset SSH_AUTH_SOCK
                unset SSH_AGENT_PID
                sourcefile "$PLUGIN_DIR/ssh-agent/ssh-agent.plugin.sh"
                ;;
        esac
    fi
}
aweb() { [[ -f "$HOME/.ssh/webhost_key" ]] && /usr/bin/ssh-add "$HOME/.ssh/webhost_key"; }
akey() {
    ra
    # If Aladdin etoken connected
    if [ $(system_profiler SPUSBDataType 2> /dev/null| grep OMNIKEY -c) -gt 0 ]; then
        /usr/bin/ssh-add -s '/usr/local/lib/libaetpkss.dylib'
    fi
}

# Get current host related info
ii() {
    echo -e "\nYou are logged on ${FGblue}${HOSTNAME}${RCLR}";
    echo -e "\n${FGred}Additionnal information:${RCLR} " ; uname -a
    echo -e "\n${FGred}Users logged on:${RCLR} " ; w -h
    echo -e "\n${FGred}Current date :${RCLR} " ; date
    echo -e "\n${FGred}Machine stats :${RCLR} " ; uptime
    echo -e "\n${FGred}Memory stats :${RCLR} " ; free
    my_ip 2>&- ;
    echo -e "\n${FGred}Local IP Address :${RCLR}" ; echo ${MY_IP:-"Not connected"}
    echo
}

if [[ "$OSTYPE" =~ 'darwin' ]]; then
    hide() {
        echo "Hiding hidden files..."
        defaults write com.apple.finder AppleShowAllFiles TRUE
        defaults write com.apple.finder AppleShowAllFiles FALSE
        # force changes by restarting Finder
        killall Finder
    }
    show() {
        echo "Showing hidden files...";
        defaults write com.apple.finder AppleShowAllFiles TRUE
        # force changes by restarting Finder
        killall Finder
    }
fi

# Prompt functions
function active_screens() {
    screens=$(screen -ls 2>/dev/null | grep -c Detach | tr -d '[[:space:]]')
    if [[ $screens > 0 ]]; then
        echo ' scr:'$screens
    fi
}
function bg_jobs() {
    jobs=$(jobs -r | wc -l | tr -d '[[:space:]]')
    if [[ $jobs > 0 ]]; then
        echo ' bg:'$jobs
    fi
}
function st_jobs() {
    jobs=$(jobs -s | wc -l | tr -d '[[:space:]]')
    if [[ $jobs -gt 0 ]]; then
        echo ' st:'$jobs
    fi
}

# ----------------------------------------------------------
# -- Plugins

export PLUGIN_DIR="${HOME}/.plugins/"
export BASH_THEME="${HOME}/.themes/zhayedan.sh"

plugins=(host git ssh-agent)
export SSH_AGENT_FWD="yes"

# Load all of the plugins
for plugin in ${plugins[@]}
do
    if [ "${plugin}" == "host" ]
    then
        pfile="$PLUGIN_DIR/$plugin/${HOSTNAME}.plugin.sh"
        sfile="$PLUGIN_DIR/$plugin/secure/${HOSTNAME}.plugin.sh"
    else
        pfile="$PLUGIN_DIR/$plugin/$plugin.plugin.sh"
    fi
    sourcefile $pfile
    sourcefile $sfile
    unset pfile
done

# Load theme
sourcefile $BASH_THEME

# Because sourcing this slows down shell init and I don't use it that often, delay loading until needed
VIRTENV_LOADED=0
function workon() {
    case $VIRTENV_LOADED in
        0)
            sourcefile '/usr/local/bin/virtualenvwrapper.sh'
            VIRTENV_LOADED=1
            workon $*
            ;;
        1)
            workon $*
            ;;
    esac
}
