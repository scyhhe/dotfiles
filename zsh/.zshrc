# Path to your dotfiles.
export DOTFILES=$HOME/.dotfiles

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path to brew
export PATH="/opt/homebrew/bin:$PATH"

# Minimal - Theme Settings
export MNML_INSERT_CHAR="$"
export MNML_PROMPT=(mnml_git mnml_keymap)
export MNML_RPROMPT=('mnml_cwd 20')

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$DOTFILES

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH

# ZSH integration with FZF
source <(fzf --zsh)
# Workaround for ALT-C 
bindkey "ç" fzf-cd-widget

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias whodis-newpr="gh pr create --assignee @me --fill --draft"
alias lg="lazygit"
alias ld="lazydocker"
alias cd="z"
alias ls="eza --icons"
alias cat="bat --color=always --theme=base16"

# k8s work stuff - move out in separate shell setup
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

alias gcloud_removebg="gcloud container clusters get-credentials removebg-app --no-user-output-enabled --zone europe-west4-b --project removebg-226919 && gcloud config set project removebg-226919 --no-user-output-enabled"
alias gcloud_tools="gcloud container clusters get-credentials tools --no-user-output-enabled --zone europe-west4 --project removebg-226919 && gcloud config set project removebg-226919 --no-user-output-enabled"

alias gcloud_danni="gcloud container clusters get-credentials danni --no-user-output-enabled --zone europe-west4-b --project danni-278921 && gcloud config set project danni-278921 --no-user-output-enabled"

alias kn="kubectl config set-context --current --namespace"

function kl() {
  echo "Connecting to running pod for workload '$1'"
  kubectl get pod --selector="app=$1"
}

function kc() {
  echo "Connecting to running pod for workload '$1'"
  kubectl exec -it $(kubectl get pod --selector="app=$1" --output jsonpath='{.items[0].metadata.name}') -- $2
}
##########


### Canva/canva specific

alias cookie-gen='bazel run //traffic/gateway/tools/auth_token_minter -- --username alice'

function regen_protos() {
  echo "regenerating for folder/namespace '$1'"
  cd dev/canva
  ./bin/regen_protos.sh --include $1
}

alias owners="./tools/code_review/ownership reviewers"
alias local_stack="./production/local/bin/init_local_stack.sh var_canva s3"
# alias cookie-gen-brand='bazel run //traffic/gateway/tools/auth_token_minter -- --user $0 --brand $1'

###

# General Helpers 
stowify() {
  local pkg="$1"
  if [[ -z "$pkg" ]]; then
    echo "Usage: stowify <package>\n"
    echo "Used to prepare config folders for usage with GNU stow"
    echo "Pre-configured for files and folders inside ~/.config"
    echo "Will create the  corresponding folder in ~/.dotfiles, move the package from ~/.config and execute a dry-run of stow <package>"
    return 1
  fi

  mkdir -p ~/.dotfiles/"$pkg"/.config
  mv ~/.config/"$pkg" ~/.dotfiles/"$pkg"/.config/
  (cd ~/.dotfiles && stow -nvt ~ "$pkg")  # dry-run first for safety
  echo "If dry-run looks good, run again without -n to apply."
  echo 'cd ~/.dotfiles && stow -vt ~ "$pkg"'
}

###

# pure setup
fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure

#add postgresql@15 to path to access psql // also libpq for ruby deps
path+=('/opt/homebrew/opt/postgresql@15/bin')
path+=('/opt/homebrew/opt/libpq/bin')
path+=("/opt/homebrew/opt/mysql-client/bin")
path+=("$HOME/.local/bin")
# add asdf shims to Path
path+=("opt/homebrew/opt/asdf/bin")
path+=("opt/homebrew/opt/asdf")
# asdf specific stuff
export ASDF_DATA_DIR="/Users/ivantoporkov/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
# needed to fix apple silicon macs when forking a thread pool (issues in running ruby puma server locally)
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export DISABLE_SPRING=true

# Claude Code for ACP 
export AWS_PROFILE="dev_app-editor_design-generation"
export CLAUDE_CODE_USE_BEDROCK="1"
export ANTHROPIC_DEFAULT_SONNET_MODEL="us.anthropic.claude-sonnet-4-5-20250929-v1:0"
export ANTHROPIC_MODEL="us.anthropic.claude-sonnet-4-5-20250929-v1:0"
export ZED_AWS_PROFILE="dev_app-editor_design-generation"

# zoxide setup
eval "$(zoxide init zsh)"
# atuin setup (disable-ctrl-r, that uses fzf)
eval "$(atuin init zsh --disable-ctrl-r)"
# 1password-cli autocomplete
eval "$(op completion zsh)"; compdef _op op
# Must be the last line in .zshrc
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# License Vault URL for activation of Jetbrains products at Canva
export JETBRAINS_LICENSE_SERVER=https://canva.fls.jetbrains.com/
