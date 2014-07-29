#!/bin/bash
# -*- coding: utf-8 -*-

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
#HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#yusuke
alias まけ='make'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

##
#export ROS_HOME=$HOME/.ros_groovy
#source /opt/ros/groovy/setup.bash
#source $HOME/rosf/uerte/setup.bash
#source $HOME/catkin_ws/devel/setup.bash
source $HOME/ros/groovy/setup.bash
#source $HOME/ros/hydro/devel/setup.bash




#
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
#alias emacs='vim'

#euslisp
export PATH=$PATH:`rospack find roseus`/bin

#euslib
export CVSDIR=~/prog
source $(rospack find euslisp)/jskeus/bashrc.eus

# hrp2 old settings
export OPENHRPHOME=$CVSDIR/OpenHRP

# rviz
export OGRE_RTT_MODE=Copy  # ノートPCの人は


# # openrtm (openrtmのmakeを通す必要がある???)
# export RTCTREE_NAMESERVERS=localhost
# export PATH=$PATH:`rospack find openrtm`/bin
# export PYTHONPATH=$PYTHONPATH:`rospack find openrtm`/src/openrtm

# # 以下はrosmake openrtmをすると生成されるはず
# source `rospack find openrtm`/share/rtshell/shell_support
# source `rospack find openrtm`/scripts/rtshell-setup.sh

function rossetpr2() { # 自分のよく使うロボットのhostnameを入れる
    rossetrobot pr1012
    rossetip
}
function rossetrobot() {
    local hostname=${1-"pr1040"}
    local ros_port=${2-"11311"}
    export ROS_MASTER_URI=http://$hostname:$ros_port
    echo -e "\e[1;31mset ROS_MASTER_URI to $ROS_MASTER_URI\e[m"
    rossetip
}
function rossetlocal() {
    export ROS_MASTER_URI=http://localhost:11311
    echo -e "\e[1;31mset ROS_MASTER_URI to $ROS_MASTER_URI\e[m"
    rossetip
}

#yusuke 2012/10/02
# function rossetip() {
#  export ROS_IP=`LANGUAGE=en LANG=C ifconfig | grep inet\  | grep -v 127.0.0.1 | sed 's/.*inet addr:\([0-9\.]*\).*/\1/' | head -1`
#  export ROS_HOSTNAME=$ROS_IP
#  echo -e "\e[1;31mset ROS_IP and ROS_HOSTNAME to $ROS_IP\e[m"
# }

function rossetip() {
 export ROS_IP=`LANGUAGE=en LANG=C ifconfig | grep 'wlan|eth' -E -A 7 | grep inet\  | grep -v 127.0.0.1 | sed 's/.*inet addr:\([0-9\.]*\).*/\1/' | head -1`
 export ROS_HOSTNAME=$ROS_IP
 echo -e "\e[1;31mset ROS_IP and ROS_HOSTNAME to $ROS_IP\e[m"
}

function rossetme() {
 export ROS_MASTER_URI=http://`LANGUAGE=en LANG=C ifconfig | grep 'wlan|eth' -E -A 7 | grep inet\  | grep -v 127.0.0.1 | sed 's/.*inet addr:\([0-9\.]*\).*/\1/' | head -1`:11311
 echo -e "\e[1;31mset ROS_MASTER_URI to $ROS_MASTER_URI\e[m"
}

 # function rossetip() {
 #   export ROS_IP=`LANGUAGE=en LANG=C ifconfig | grep inet\  | grep -v 127.0.0.1 | sed 's/.*inet addr:\([0-9\.]*\).*/\1/' | tail -1`
 #   export ROS_HOSTNAME=$ROS_IP
 #   echo -e "\e[1;31mset ROS_IP and ROS_HOSTNAME to $ROS_IP\e[m"
 # }


#source /home/furuta/.bashrc.jsk

eval "$(fasd --init auto)"

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ros/fuerte/lib/

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/catkin_ws/devel/lib:/opt/ros/${ROS_DISTRO}/lib



function remacs() {
        [ -f "$1" ] || (echo "ファイルが見つかりませんでした: $1" >&2; exit 1)
	    emacs -nw "$1" --eval '(setq buffer-read-only t)'
}

# export ROS_PACKAGE_PATH=/home/furuta/prog/euslib/demo/furuta/visualization:/home/furuta/prog/euslib/demo/furuta/furuta-ros-pkg:$ROS_PACKAGE_PATH

export ROS_PACKAGE_PATH=/home/furuta/prog/euslib/demo/furuta/furuta-ros-pkg:$ROS_PACKAGE_PATH

export ROS_PACKAGE_PATH=/home/furuta/work/perception_pcl:$ROS_PACKAGE_PATH


alias em='emacs -nw'
alias ems='emacs -nw -f shell'
alias ..='cd ..'
alias gno='gnome-open'

function rossethyperion() { 
    export ROS_MASTER_URI=http://hyperion:11311
    rossetip
}

function rossetindus() { 
    export ROS_MASTER_URI=http://indus:11311
    rossetip
}


##add drcsim

function drc_setup(){
    export ROS_PACKAGE_PATH_ORG=$ROS_PACKAGE_PATH
    source /usr/share/drcsim/setup.sh
    export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH_ORG:$ROS_PACKAGE_PATH
    # Add furuta
    export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/usr/share/sandia-hand-5.1/ros/
    export ROS_PACKAGE_PATH=`echo $(echo $ROS_PACKAGE_PATH | sed -e "s/:/\n/g" | awk '!($0 in A) && A[$0] = 1' | grep -v "opt/ros"; echo $ROS_PACKAGE_PATH | sed -e "s/:/\n/g" | awk '!($0 in A) && A[$0] = 1' | grep "opt/ros") | sed -e "s/ /:/g"`

    export VRC_CHEATS_ENABLED=1
    # export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/home/furuta/drcsim
    export ROS_PACKAGE_PATH=/home/furuta/drcsim:$ROS_PACKAGE_PATH
}

# ROS_PACKAGE_PATH_ORG=$ROS_PACKAGE_PATH
# ROS_WORKSPACE_ORG=$ROS_WORKSPACE
# PYTHONPATH_ORG=$PYTHONPATH
# source /usr/share/drcsim/setup.sh
# export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH_ORG:$ROS_PACKAGE_PATH
# export ROS_WORKSPACE=$ROS_WORKSPACE_ORG
# export PYTHONPATH=$PYTHONPATH_ORG:$PYTHONPATH
# export ROS_PACKAGE_PATH=`echo $(echo $ROS_PACKAGE_PATH | sed -e "s/:/\n/g" | awk '!($0 in A) && A[$0] = 1' | grep -v "opt/ros"; echo $ROS_PACKAGE_PATH | sed -e "s/:/\n/g" | awk '!($0 in A) && A[$0] = 1' | grep "opt/ros") | sed -e "s/ /:/g"`
# export VRC_CHEATS_ENABLED=1
#drc_setup

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -f $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm


#export LC_ALL="ja_JP.UTF-8"


#history の同期
# function share_history {
#     history -a
#     history -c
#     history -r
# }
# PROMPT_COMMAND='share_history'
# shopt -u histappend
HISTSIZE=99999999
HISTFILESIZE=1000000000

# for webots
export USB_DEVFS_PATH=/proc/bus/usb
export WEBOTS_HOME=/home/furuta/webots
export PATH=$PATH:$WEBOTS_HOME
#
# bashrc.eus : environment variable for euslisp 
#
#export EUSDIR=/home/furuta/ros/fuerte/jsk-ros-pkg/euslisp/jskeus/eus 
if [ ${ROS_DISTRO} == "groovy" ]; then
    export EUSDIR=/home/furuta/ros/${ROS_DISTRO}/jsk-ros-pkg/jsk_roseus/euslisp/jskeus/eus
elif [ ${ROS_DISTRO} == "hydro" ]; then
    export EUSDIR=/home/furuta/ros/${ROS_DISTRO}/src/jsk-ros-pkg/jsk_roseus/euslisp/jskeus/eus
fi


export ARCHDIR=Linux64 
export PATH=$EUSDIR/$ARCHDIR/bin:$EUSDIR/$ARCHDIR/lib:$PATH 
export LD_LIBRARY_PATH=$EUSDIR/$ARCHDIR/bin:$LD_LIBRARY_PATH 


alias webots='rosrun webots_simulator start_webots.sh'


function opt_groovy() { 
   . /opt/ros/groovy/setup.bash
}

#for android
export PATH=~/work/adt-bundle-linux-x86_64-20130522/sdk/tools:~/work/adt-bundle-linux-x86_64-20130522/sdk/platform-tools:$PATH

# source $(rospack find hrpsys_gazebo_tutorials)/setup.sh

export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:~/prog/euslib/demo/furuta/furuta-ros-pkg/gazebo_test/build

#for copy
export PATH=$PATH:~/Downloads/copy/x86_64

alias rtmlaunch='`rospack find hrpsys_ros_bridge`/scripts/rtmlaunch'

alias grep='grep --color=auto'

rossetlocal

function rossetgazebo() {
    local hostname=${1-"133.11.216.133"}
    local ros_port=${2-"11311"}
    export ROS_MASTER_URI=http://$hostname:$ros_port
    echo -e "\e[1;31mset ROS_MASTER_URI to $ROS_MASTER_URI\e[m"
    rossetip
    export GAZEBO_MASTER_URI=$hostname:11345
    export GAZEBO_IP=`LANGUAGE=en LANG=C ifconfig | grep inet\  | grep -v 127.0.0.1 | sed 's/.*inet addr:\([0-9\.]*\).*/\1/' | tail -1`
}



function rossethku() {
    local hostname=${1-"172.16.3.193"}
    local ros_port=${2-"11311"}
    export ROS_MASTER_URI=http://$hostname:$ros_port
    echo -e "\e[1;31mset ROS_MASTER_URI to $ROS_MASTER_URI\e[m"
    rossetip
    export GAZEBO_MASTER_URI=$hostname:11345
    export GAZEBO_IP=`LANGUAGE=en LANG=C ifconfig | grep inet\  | grep -v 127.0.0.1 | sed 's/.*inet addr:\([0-9\.]*\).*/\1/' | tail -1`
}

export PYTHONPATH=$PYTHONPATH:$HOME/Downloads/LeapDeveloperKit/LeapSDK/lib:$HOME/Downloads/LeapDeveloperKit/LeapSDK/lib/x64

#source /home/furuta/.bashrc.jsk
#source /home/furuta/.bashrc.nao
alias eclipse-android='/home/furuta/work/adt-bundle-linux-x86_64-20130522/eclipse/eclipse &'


export ROS_PACKAGE_PATH=$HOME/catkin_ws/src:$ROS_PACKAGE_PATH

export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$HOME/ros/groovy/humanitarian_assistance_robotics

export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$HOME/catkin_ws/devel
export PYTHONPATH=$PYTHONPATH:/home/furuta/catkin_ws/devel/lib/python2.7/dist-packages

export PATH=$PATH:/usr/local/go/bin


if [ ${ROS_DISTRO} == "groovy" ]; then
    export ROS_PACKAGE_PATH=$HOME/ros/groovy/pr2_simulator:$ROS_PACKAGE_PATH
fi
source `rospack find gazebo`/scripts/setup.sh
export ROS_PACKAGE_PATH=`rosstack find simulator_gazebo`:$ROS_PACKAGE_PATH



pkgdir=`rospack find hrpsys_gazebo_general`
tpkgdir=`rospack find hrpsys_gazebo_tutorials`
drcdir=`rospack find drcsim_model_resources`
if [ ${ROS_DISTRO} == "groovy" ]; then
    hectdir=`rosstack find hector_models` # for groovy
elif [ ${ROS_DISTRO} == "hydro" ]; then
    hectdir=`rospack find hector_models` # for hydro
fi

if [ -e ${pkgdir} -a -e ${tpkgdir} ]; then
    for dname in `find ${tpkgdir}/robot_models -mindepth 1 -maxdepth 1 -type d -regex '.*[^\.svn]'`; do export ROS_PACKAGE_PATH=${dname}:$ROS_PACKAGE_PATH; done
#    export ROS_PACKAGE_PATH=${pkgdir}/ros:$ROS_PACKAGE_PATH
    export GAZEBO_RESOURCE_PATH=${tpkgdir}/worlds:$GAZEBO_RESOURCE_PATH
    export GAZEBO_MODEL_PATH=${tpkgdir}/robot_models:${tpkgdir}/environment_models:$GAZEBO_MODEL_PATH:${drcdir}/gazebo_models/environments:${hectdir}:${tpkgdir}/..
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${pkgdir}/plugins
    # export GAZEBO_PLUGIN_PATH=${pkgdir}/plugins:$GAZEBO_PLUGIN_PATH
fi


# export GAZEBO_MODEL_PATH=`rospack find jsk_interactive_marker`/launch/models/environment_models:$GAZEBO_MODEL_PATH

capy(){
    cat $1 | xsel --clipboard --input
}

export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/home/furuta/ros/groovy/sandbox/tf2_evaluate

alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//"'
alias alert='notify-send -i /usr/share/icons/gnome/32x32/apps/gnome-terminal.png "[$?] $(alert_helper) finished."'

function rosmake(){
    `which rosmake` $@; alert;speak-text "メイクおわりました"
}

function make(){
    `which make` $@; alert;speak-text "メイクおわりました"
}

#for pr2 gazebo
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ros/groovy/stacks/pr2_simulator/pr2_gazebo_plugins/lib


function git-status-subdirs () 
{
    for dir in `ls ` ; do 
	if [ -d $dir ] ; then
	    cd $dir
	    echo "---------------------"
	    pwd
	    git status
	    cd ..
	fi
    done
}
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH="/home/furuta/.cask/bin:$PATH"
alias emacs=emacs23



alias ros_groovy='source $HOME/ros/groovy/setup.bash'
alias ros_hydro='source $HOME/ros/hydro/devel/setup.bash'

export PATH=/opt/lampp/bin:$PATH

function speak-text()
{
    (curl  "https://api.voicetext.jp/v1/tts" -u "8q97n704pt1sbeq1:" -d "text=$1" -d "speaker=haruka" -k 2>/dev/null) | play - > /dev/null 2>&1

}