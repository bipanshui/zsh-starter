# ┌──────────────────────────────────────────────────────────┐
# │                  Kali Linux Style .zshrc                  │
# └──────────────────────────────────────────────────────────┘

# ─── Oh My Zsh (comment out if not installed) ───────────────
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME=""   # We're using a custom prompt below
# plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
# source $ZSH/oh-my-zsh.sh

# ─── History ────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ─── Options ────────────────────────────────────────────────
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS

# ─── Colors ─────────────────────────────────────────────────
autoload -U colors && colors

# ─── Kali Linux Style Prompt ────────────────────────────────
# Looks like: ┌──(user㉿hostname)-[~/current/dir]
#             └─$ 

setopt PROMPT_SUBST

# Git branch helper
_git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
  branch=$(git rev-parse --short HEAD 2>/dev/null) || return
  echo " git:($branch)"
}

# Kali-style two-line prompt
PROMPT='%F{blue}┌──(%F{red}%n%F{white}㉿%F{red}%m%F{blue})-[%F{white}%~%F{blue}]%F{yellow}$(_git_branch)%f
%F{blue}└─%F{white}$%f '

# Right-side prompt: shows exit code if non-zero
RPROMPT='%(?..%F{red}✘ %?%f)'

# ─── Completion ─────────────────────────────────────────────
autoload -Uz compinit
compinit -d ~/.zcompdump

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ─── Key Bindings ───────────────────────────────────────────
bindkey -e                          # Emacs key bindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char

# ─── Environment ────────────────────────────────────────────
export EDITOR='nano'
export VISUAL='nano'
export PAGER='less'
export LESS='-R'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ─── Aliases: Navigation ────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ─── Aliases: Listing ───────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lt='ls -lah --sort=time --color=auto'
alias lsize='ls -lah --sort=size --color=auto'

# ─── Aliases: Grep ──────────────────────────────────────────
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ─── Aliases: Safety ────────────────────────────────────────
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ─── Aliases: System ────────────────────────────────────────
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias top='htop 2>/dev/null || top'
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me && echo'
alias localip="ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1"

# ─── Aliases: Network (Kali essentials) ─────────────────────
alias ipa='ip a'
alias ipr='ip r'
alias ping='ping -c 4'
alias nmap='nmap --reason'

# ─── Aliases: Package Management (Debian/Kali) ──────────────
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'
alias autoremove='sudo apt autoremove -y'

# ─── Aliases: Misc ──────────────────────────────────────────
alias c='clear'
alias cls='clear'
alias h='history'
alias j='jobs -l'
alias now='date +"%Y-%m-%d %T"'
alias week='date +%V'
alias reload='source ~/.zshrc && echo "✔ .zshrc reloaded"'
alias zshconfig='${EDITOR:-nano} ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'

# ─── Functions ──────────────────────────────────────────────

# Extract any archive
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1"   ;;
      *.tar.gz)   tar xzf "$1"   ;;
      *.tar.xz)   tar xJf "$1"   ;;
      *.tar)      tar xf  "$1"   ;;
      *.bz2)      bunzip2 "$1"   ;;
      *.gz)       gunzip  "$1"   ;;
      *.zip)      unzip   "$1"   ;;
      *.7z)       7z x    "$1"   ;;
      *.rar)      unrar x "$1"   ;;
      *.Z)        uncompress "$1";;
      *)          echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Make a dir and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Quick HTTP server in current dir
serve() { python3 -m http.server "${1:-8080}"; }

# Find a file by name
ff() { find . -name "*$1*" 2>/dev/null; }

# Find files containing a string
fs() { grep -rl "$1" . 2>/dev/null; }

# Show listening ports
listening() { ss -tlnp | grep LISTEN; }

# Quick base64 encode/decode
b64enc() { echo -n "$1" | base64; }
b64dec() { echo -n "$1" | base64 -d; }

# URL encode/decode
urlencode() { python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$1"; }
urldecode() { python3 -c "import urllib.parse,sys; print(urllib.parse.unquote(sys.argv[1]))" "$1"; }

# Hex dump shortcut
hexdump() { xxd "$1" | less; }

# ─── Syntax Highlighting (install separately) ───────────────
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ─── Autosuggestions (install separately) ───────────────────
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# ─── Welcome Banner ─────────────────────────────────────────
echo ""
echo "  $(tput setaf 1)┌──────────────────────────────────────┐$(tput sgr0)"
echo "  $(tput setaf 1)│$(tput sgr0)  $(tput setaf 4)$(hostname)$(tput sgr0) @ $(tput setaf 2)$(date '+%Y-%m-%d %H:%M:%S')$(tput sgr0)  $(tput setaf 1)│$(tput sgr0)"
echo "  $(tput setaf 1)│$(tput sgr0)  $(tput setaf 3)Kernel:$(tput sgr0) $(uname -r)                  $(tput setaf 1)│$(tput sgr0)"
echo "  $(tput setaf 1)└──────────────────────────────────────┘$(tput sgr0)"
echo ""