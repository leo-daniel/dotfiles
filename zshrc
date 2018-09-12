# load custom executable functions
for function in ~/.zsh/functions/*; do
	source $function
done

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
	_dir="$1"
	if [ -d "$_dir" ]; then
		if [ -d "$_dir/pre" ]; then
			for config in "$_dir"/pre/**/*(N-.); do
				if [ ${config:e} = "zwc" ]; then continue; fi
				. $config
			done
		fi

		for config in "$_dir"/**/*(N-.); do
			case "$config" in
			"$_dir"/pre/*)
				:
				;;
			"$_dir"/post/*)
				:
				;;
			*)
				if [[ -f $config && ${config:e} != "zwc" ]]; then
					. $config
				fi
				;;
			esac
		done

		if [ -d "$_dir/post" ]; then
			for config in "$_dir"/post/**/*(N-.); do
				if [ ${config:e} = "zwc" ]; then continue; fi
				. $config
			done
		fi
	fi
}
_load_settings "$HOME/.zsh/configs"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

export ZSH="/Users/leodaniel/dotfiles/oh-my-zsh"



# POWERLEVEL9K FONTS
POWERLEVEL9K_MODE="awesome-fontconfig"

# ZSH_THEME
ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_PROMPT_ON_NEWLINE=true

POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_DISABLE_RPROMPT=true

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)

POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1

POWERLEVEL9K_SHORTEN_DELIMITER=""

POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"

plugins=(
	autojump
	colored-man-pages
	git
  osxt
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# print contents after moving to given directory
cdd()
{
    cd $@
    pwd
    exa
}

source $ZSH/oh-my-zsh.sh

export PATH="$PATH:$HOME/.bin:$PATH"
export PATH="$PATH:/usr/local/sbin:$PATH"
export PATH="$PATH:$HOME/.asdf/installs/nodejs/10.6.0/.npm/bin"
export PATH="$PATH:$(yarn global bin):$PATH"
export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/leodaniel/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
