########
#
# MyBash profile file
#
# Primarily used to setup environment variables
#
# written by Marcus Grant (2016) of thepatternbuffer.com
#
########

# TODO Move exports to correct new file that flattens exports
#      - Look here for good info http://bit.ly/2RMAzFR
# TODO Consider also making profile exports into ansible templates

# Determine Host OS type & export to 'MACHINE'
# NOTE: this needs to happen first because various other variables &
# configs depend on what the host system is
machine=""
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)	machine="linux";;
    Darwin*)    machine="mac";;
    *Microsoft*) machine="wsl";;
    CYGWIN*)    machine="cygwin";;
    MINGW*)     machine="minGw";;
    *)          machine="UNKNOWN:${unameOut}"
esac
# override linux in machine if uname -a contains "Microsoft"
if [[ $machine == "linux" ]]; then
    if [[ "$(uname -a)" = *"Microsoft"* ]]; then
        machine="wsl"
    fi
fi
export MACHINE="$machine"

# Termite & iTerm with Tmux work best with xterm-256color
# export TERM=xterm-256color
# from  https://www.queryxchange.com/q/2_399296/256-color-support-for-vim-background-in-tmux/
if [[ -z $TMUX ]]; then
    # TODO: for some reason this path isn't in Ubuntu? Find alternative
    #if [ -e /usr/share/terminfo/x/xterm+256color ]; then # may be xterm-256 depending on your distro
        #export TERM='xterm-256color'
    #else
        #export TERM='xterm'
    #fi
    # Alternative, just force xterm-256color
    export TERM='xterm-256color'
else
    if [ -e /usr/share/terminfo/s/screen-256color ]; then
        export TERM='screen-256color'
    else
        export TERM='screen'
    fi
  fi
# Editor vars
export VISUAL="gedit"
# determine if nvim is installed and use instead of vim if so
if hash nvim 2>/dev/null; then
  export GIT_EDITOR="nvim"
  export EDITOR="nvim"
else
  export GIT_EDITOR="vim"
  export EDITOR="vim"
fi

# use the right locale
export LANG=en_US.UTF-8

# PATHs
# TODO !!!!!! Be sure to migrate the .bashrc ones over to here instead

# /sbin should be in the path
export PATH="/sbin:$PATH"
# Add defulat local bin
export PATH="$HOME/.local/bin:$PATH"
# Home bin for my custom apps and scripts
export PATH="$HOME/bin:$PATH"
# Rust's cargo package manager needs for there to be some kind of standard path
# TODO track this issue to see if this can be moved someplace like .local & .config
# Heres the link: http://bit.ly/2RJmrxd
export PATH="$HOME/.cargo/bin:$PATH"
# Go's GOPATH
export GOPATH="$HOME/.local/share/go:$HOME/code/go"
export GOBIN="$HOME/.local/share/go/bin:$HOME/code/go/bin"
#export GOBIN="$HOME/$XDG_DATA_DIRS/go/bin" # necessary?
# its easier to let gopath determine
# export PATH="$PATH:$HOME/bin/go/bin"
export PATH="$PATH:$GOBIN"

# pyenv - is a devops nightmare
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"

# export GOBIN="$GOBIN:$HOME/bin/go/bin"
# export GOBIN="$HOME/bin/go/bin"
# add a GOPATH for the .dotfiles/bash/prompts/ dir so the go-powerline can run
# TODO: Disabled below for now because it might be fucking with resolutions.
# export GOPATH="$GOPATH:$BASH_CONFIGS_ROOT/prompts"

# Setup paths for virtualenv
if [ -d $HOME/.virtualenvs ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
    export PIP_VIRTUALENV_BASE=$WORKON_HOME
fi

# anaconda for 'marcus' only as userspace python (if it exists)
# if [ -d $HOME/.local/share/anaconda3/bin ]; then
#     if [ "$(whoami)" == "marcus" ]; then
#         export PATH=$HOME/.local/share/anaconda3/bin:$PATH
#     fi
# fi


# fzf exports - from https://mike.place/2017/fzf-fd/
export PATH="$PATH:$HOME/.local/share/fzf/bin"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git --exclude node_modules --exclude .cache --exclude .local --exclude .config"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --hidden --exclude .git --exclude node_modules --exclude .cache --exclude .local -t d . /"


# n version manager, using nvm for now
# export N_PREFIX=$HOME/.n

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# npm path at home
#if hash npm 2>/dev/null; then
#    npm config set prefix ~/.npm
#    export PATH="$PATH:$HOME/.npm/bin"
#fi

# Export for NVM_DIR part of NVM bash subsystem
# TODO: duplicate and look for cleaner methods
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# program opts
# compressors
# export XZ_OPT="--threads=0"

# set xdg's
# TODO: find better way to standardize this across systems particularly on arch
#export XDG_CONFIG_HOME="${XDG_CONFIG_HOME}:$HOME/.config"
