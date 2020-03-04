# Prompt for a password using Zenity

export SUDO_ASKPASS="${HOME}/code/personal/dotfiles/i3/scripts/password_prompt.sh"
# Editor Settings
export EDITOR=nvim
export SHELL=$(which zsh)
#Sets nvim's default colourscheme to Dracula
export VAMPIRE=1
export NVIM_CONFIG_BASE="${HOME}/code/personal/nvim"

# NodeJS path addition
export PATH=$PATH:~/.node/bin

# Ensure local python packages are on path
export PATH=$PATH:~/.local/bin

# Ensure various locally installed things are on the path
export PATH=$PATH:~/bin/

# Ensure Nix managed tooling is on PATH
export PATH=$PATH:~/.nix-profile/bin/

#Set the Go Path to ~/Coding/go
export GOPATH=$HOME/Coding/go
export PATH=$PATH:$GOPATH/bin

# Put Rust on the path
export PATH=$PATH:$HOME/.cargo/bin


#Python VirtualEnv Settings
export WORKON_HOME=~/.python
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
[ -f ~/.local/bin/virtualenvwrapper_lazy.sh ] && source ~/.local/bin/virtualenvwrapper_lazy.sh

# Rebind the terminal stop keybind so that we can use ^s to search forward
# in history
#stty stop ^J

# Start Autojump - quicker directory navigation
source /usr/share/autojump/autojump.sh

# Make Whalebrew work with local bin, rather than a global one which requres root
export WHALEBREW_INSTALL_PATH="$HOME/bin"

# Put a timestamp into my bash history
export HISTTIMEFORMAT="%d/%m/%y %T "

# Put ZPLUG under ~/.config/zplug
export ZPLUG_HOME="$HOME/.config/zplug"

# Use ~/code/personal/dotfiles/zsh/zplug.zsh for plugin definitions etc.
export ZPLUG_LOADFILE="$HOME/code/personal/dotfiles/zsh/zplug.zsh"

# Pull in FZF for shell usage.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Setup environment variables needed for pyenv
export PYENV_ROOT="$HOME/code/personal/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

pyenv () {
  unset -f pyenv
  eval "$(command pyenv init -)"
  pyenv $@
}

# Enable Pipenv Completions
pipenv () {
  unset -f pipenv
  eval "$(command pipenv --completion)"
  pipenv $@
}

# Setup the powerline daemon for use with tmux etc.
powerline-daemon -q
PYTHON_VERSION=$(python3 --version | sed -n 's/.*\(3\..\).*/\1/p')

if [ -f "$HOME/.local/pipx/venvs/powerline-status/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh" ]; then
  powerline_script="$HOME/.local/pipx/venvs/powerline-status/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh"
  source  $powerline_script
elif [ -f "$HOME/.local/venvs/powerline-status/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh" ]; then
  powerline_script="$HOME/.local/venvs/powerline-status/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh"
  source  $powerline_script
fi

# Enable Better Exceptions in python code
export BETTER_EXCEPTIONS=1

# AddCargo to PATH for work with rust
export PATH="~/.cargo/bin:$PATH"


# NVM settings
# placeholder nvm shell function
# On first use, it will set nvm up properly which will replace the `nvm`
# shell function with the real one
nvm() {
  if command -v nvm 1>/dev/null 2>&1; then
    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1090
    source "${NVM_DIR}/nvm.sh"
    if [[ -e ~/.nvm/alias/default ]]; then
      PATH="${PATH}:${HOME}.nvm/versions/node/$(cat ~/.nvm/alias/default)/bin"
    fi
    # invoke the real nvm function now
    nvm "$@"
  else
    echo "nvm is not installed" >&2
    return 1
  fi
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
rvm() {
  if command -v rvm 1>/dev/null 2>&1; then
    unset -f rvm
    source /home/sam/.rvm/scripts/rvm
    rvm "$@"
  else
    echo "RVM is not installed" >&2
    return 1
  fi
}


