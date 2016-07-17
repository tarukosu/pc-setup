
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting


###########################
## my setting
###########################
## alias grep='grep --color=auto'

HISTSIZE=99999999
HISTFILESIZE=1000000000

alias em='emacs -nw'
alias ems='emacs -nw -f shell'
alias gno='gnome-open'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


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

autoload colors
colors

PROMPT="
 %{${fg[yellow]}%}%~%{${reset_color}%} 
[%n]$ "

PROMPT2='[%n]> ' 


####################
### http://qiita.com/uasi/items/c4288dd835a65eb9d709
####################


# Emacs ライクな操作を有効にする（文字入力中に Ctrl-F,B でカーソル移動など）
# Vi ライクな操作が好みであれば `bindkey -v` とする
bindkey -e

# 自動補完を有効にする
# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# 例： `cd path/to/<Tab>`, `ls -<Tab>`
autoload -U compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

# ↑を設定すると、 .. とだけ入力したら1つ上のディレクトリに移動できるので……
# 2つ上、3つ上にも移動できるようにする
alias ...='cd ../..'
alias ....='cd ../../..'

# "~hoge" が特定のパス名に展開されるようにする（ブックマークのようなもの）
# 例： cd ~hoge と入力すると /long/path/to/hogehoge ディレクトリに移動
hash -d hoge=/long/path/to/hogehoge

# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd

# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張 glob を有効にする
# glob とはパス名にマッチするワイルドカードパターンのこと
# （たとえば `mv hoge.* ~/dir` における "*"）
# 拡張 glob を有効にすると # ~ ^ もパターンとして扱われる
# どういう意味を持つかは `man zshexpn` の FILENAME GENERATION を参照
setopt extended_glob

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
# 例： <Space>echo hello と入力
setopt hist_ignore_space

# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

### minecraft
alias minecraft='cd ~/Downloads/minecraft; ./start.sh; tmux a'

##################もしかして##############################
# 色設定
autoload -U colors; colors

# もしかして機能
setopt correct

# PCRE 互換の正規表現を使う
setopt re_match_pcre

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプト指定
PROMPT="
[%n] %{${fg[yellow]}%}%~%{${reset_color}%}
%(?.%{$fg[green]%}.%{$fg[blue]%})%(?!(*'-') <!(*;-;%)? <)%{${reset_color}%} "

# プロンプト指定(コマンドの続き)
PROMPT2='[%n]> '

# もしかして時のプロンプト指定
SPROMPT="%{$fg[red]%}%{$suggest%}(*'~'%)? < もしかして %B%r%b %{$fg[red]%}かな? [そう!(y), 違う!(n),a,e]:${reset_color} "

export HISTFILE=${HOME}/.zsh_history # 履歴ファイルの保存先
export HISTSIZE=10000                 # メモリに保存される履歴の件数
export SAVEHIST=1000000               # 履歴ファイルに保存される履歴の件数
## setopt hist_ignore_dups              # 重複を記録しない
setopt EXTENDED_HISTORY              # 開始と終了を記録
# 履歴から補完を行う
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

[[ $EMACS = t ]] && unsetopt zle
##################もしかして##############################


alias 'cd ..'='\cd ..'
if [ -f ~/Applications/enhancd/enhancd.sh ]; then
    source ~/Applications/enhancd/enhancd.sh
fi

alias capy='(){cat $1|xsel --input --clipboard}'


################################
# notify command
################################
local COMMAND=""
local COMMAND_TIME=""
precmd() {
    if [ "$COMMAND_TIME" -ne "0" ] ; then
        local d=`date +%s`
        d=`expr $d - $COMMAND_TIME`
        if [ "$d" -ge "1" ] ; then
	   COMMAND="$COMMAND "
	   notify-send -i /usr/share/icons/application-default-icon.png "${${(s: :)COMMAND}[1]}" "${COMMAND}"
	fi
    fi
    COMMAND="0"
    COMMAND_TIME="0"
}
preexec () {
    COMMAND="${1}"
    COMMAND_TIME=`date +%s`
}


###################
# anaconda
###################
#export PATH=/home/yusuke/anaconda3/bin:$PATH


############################
# each machine setup
############################
export HOSTNAME=$(cat /etc/hostname)

case "$HOSTNAME" in
     "espeon" ) export PATH=${PATH}:~/Applications/peco_linux_amd64
     	        alias rakuten='python ~/Dropbox/pointClick/rakuten.py'
		export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

		#alias -g @c='|xsel --clipboard --input'
		export NVM_DIR="/home/furuta/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

		source ~/ros/indigo/devel/setup.zsh

		export NLOPT_INCLUDE_DIR=/home/furuta/ros/hydro/src/jsk-ros-pkg/jsk_common/3rdparty/nlopt/include;;
    "sylveon" ) # cuda setting
    	        export PATH=${PATH}:/usr/local/cuda-8.0/bin:/usr/lib/nvidia-367/bin
		export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:/usr/lib32/nvidia-367:/usr/lib/nvidia-367
		export CUDA_HOME=/usr/local/cuda
		source ~/ros/kinetic/devel/setup.zsh
		#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/local/lib
		export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/yusuke/lib/opencv2.4.13
esac
