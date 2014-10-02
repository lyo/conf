#history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
function history-all { history -E 1 }
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt extended_history

#tcsh like...
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "OA" history-beginning-search-backward-end
bindkey "OB" history-beginning-search-forward-end
bindkey "[A" history-beginning-search-backward-end
bindkey "[B" history-beginning-search-forward-end


#prompt
autoload -U colors; colors
autoload -U compinit
compinit -u
zstyle ':completion:*:default' menu select true

local GREEN=$'%{\e[1;32m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'

PROMPT=$BLUE'[%n@%m] > '$DEFAULT  
RPROMPT=$GREEN'[%~]'$DEFAULT
setopt prompt_subst


#etc.
autoload -U predict-on
zle -N predict-on
zle -N predict-off

#C-x,pで自動補間モード発動
bindkey '^xp' predict-on
#C-x,C-pで自動補間モード中止
bindkey '^x^p' predict-off

# 単語の一部とみなす記号(/は除外)
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# 8 ビット目を通すようになり、日本語のファイル名を表示可能
setopt print_eight_bit

# ディレクトリ名だけでディレクトリの移動をする
setopt auto_cd

setopt menu_complete correct auto_name_dirs auto_remove_slash
setopt prompt_subst pushd_ignore_dups rm_star_silent sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys
setopt auto_pushd pushd_ignore_dups

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完
setopt magic_equal_subst

#setopt bsd_echo

## alias & function
alias -g L="| less"
alias -g G="| grep"
alias les="less"   #for typo
alias vi="vim"
alias diff="colordiff"
alias svn="colorsvn"
alias ls="gnuls --color=auto"
alias ll="ls -al"

#export LANG=ja_JP.eucJP
#export LC_ALL=ja_JP.eucJP
#export JAVA_HOME=/usr/local/diablo-jdk1.5.0/

# UTF-8
export PAGER='lv'
export LV='-Ou8'
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export LC_TYPE=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export JLESSCHARSET=utf-8
export LESSCHARSET=japanese
export MANPAGER=$PAGER

alias less='lv'
alias jman='env LC_ALL=ja_JP.eucJP jman'

#preexec () {
#  echo -e "\ek${(s: :)1[1]}\e\\"
#}
if [ "$TERM" = "screen" ]; then
	chpwd () { echo -n "_`dirs`\\" }
	preexec() {
		# see [zsh-workers:13180]
		# http://www.zsh.org/mla/workers/2000/msg03993.html
		emulate -L zsh
		local -a cmd; cmd=(${(z)2})
		case $cmd[1] in
			fg)
				if (( $#cmd == 1 )); then
					cmd=(builtin jobs -l %+)
				else
					cmd=(builtin jobs -l $cmd[2])
				fi
				;;
			%*) 
				cmd=(builtin jobs -l $cmd[1])
				;;
			cd)
				if (( $#cmd == 2)); then
					cmd[1]=$cmd[2]
				fi
				;&
			*)
				echo -n "k$cmd[1]:t\\"
				return
				;;
		esac

		local -A jt; jt=(${(kv)jobtexts})

		$cmd >>(read num rest
			cmd=(${(z)${(e):-\$jt$num}})
			echo -n "k$cmd[1]:t\\") 2>/dev/null
	}
	chpwd
fi
