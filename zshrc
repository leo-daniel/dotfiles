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

# ZSH_THEME
ZSH_THEME="powerlevel9k/powerlevel9k"

# POWERLEVEL9K FONTS
POWERLEVEL9K_MODE="awesome-fontconfig"

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

export PATH="$HOME/.bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
