# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
# zinit snippet OMZL::git.zsh
# zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Aliases
alias b="cd .."
alias c="code ."
alias ci="code-insiders ."
alias cc="clear -x"
alias cat="bat"
alias ga="git add ."
alias gb="git branch"
alias gi="git init"
alias gcb="git checkout -b"
alias gl="git log"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gll="git log --pretty=oneline --abbrev-commit "
alias gllg="git log --oneline --graph"
alias gs="git status"
alias gcm="git checkout main"
alias k="claude code"
alias kk="codex"
# ---- Eza (better ls) -----
alias ls="eza --icons=always"
alias lsa="ls -a"
alias lsf="ls -af"
alias lsd="ls -aD"
alias o="open ."
alias sz='source ~/.zshrc'
alias tree="tree -a -I '.git|node_modules|venv'"
alias te="eza --tree --icons=always"
# alias z="code ~/.zshrc"

alias ~="cd ~/"
alias bkdev="~/bin/backup-dev.sh"


# source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# history setup
HISTSIZE=3000
HISTFILE=$HOME/.zhistory
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt sharehistory
setopt appendhistory
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
# With AUTO_CD enabled, whenever you type any directory path (like ~, .., or ~/Documents) directly into your terminal without cd, Zsh automatically changes into that directory for you.
setopt AUTO_CD

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# Load completions
# autoload -Uz compinit && compinit
# zinit cdreplay -q

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
# Bind Ctrl+X to clear the current line
#bindkey '^X' kill-whole-line
# Bind ESC, Clear line on pressing Escape twice
bindkey '\e\e' kill-whole-line

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
# alias cd="z"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"


# ########### functions
ll() {
  eza -lah --icons --only-dirs "$@"
  echo
  eza -lah --icons --only-files --show-symlinks "$@"
}

lla() {
  print -P "%B%F{yellow}Directories%f"
  echo ""
  eza -lah --icons --only-dirs "$@"
  echo ""
  echo "------------------------------------------------------"
  echo
  print -P "%B%F{yellow}Files%f"
  echo ""
  eza -lah --icons --only-files --show-symlinks "$@"
}

lll() {
  print -P "%B%F{blue}Directories%f%b"
  eza -lah --icons --only-dirs "$@"

  echo

  print -P "%B%F{green}Files%f%b"
  eza -lah --icons --only-files --show-symlinks "$@"
}

dir() {
  local width=45
  local -a dirs files
  local i max

  dirs=("${(@f)$(command eza -1a \
    --icons=always \
    --color=always \
    --only-dirs \
    "${@:-.}")}")

  files=("${(@f)$(command eza -1a \
    --icons=always \
    --color=always \
    --only-files \
    --show-symlinks \
    "${@:-.}")}")

  printf "%-45s %s\n" \
    $'\e[1;34mDirectories\e[0m' \
    $'\e[1;32mFiles\e[0m'

  printf "%-45s %s\n" \
    "────────────────────────────────────────" \
    "────────────────────────────────────────"

  (( max = ${#dirs} > ${#files} ? ${#dirs} : ${#files} ))

  for (( i = 1; i <= max; i++ )); do
    printf "%-${width}s %s\n" \
      "${dirs[i]:-}" \
      "${files[i]:-}"
  done
}

dira() {
  local width=45
  local -a dirs files
  local i max

  dirs=("${(@f)$(command eza -1 \
    --all \
    --icons=always \
    --color=always \
    --only-dirs \
    --show-symlinks \
    "${@:-.}")}")

  files=("${(@f)$(command eza -1 \
    --all \
    --icons=always \
    --color=always \
    --only-files \
    --show-symlinks \
    "${@:-.}")}")

  printf "%-45s %s\n" \
    $'\e[1;34mDirectories\e[0m' \
    $'\e[1;32mFiles\e[0m'

  printf "%-45s %s\n" \
    "────────────────────────────────────────" \
    "────────────────────────────────────────"

  (( max = ${#dirs} > ${#files} ? ${#dirs} : ${#files} ))

  for (( i = 1; i <= max; i++ )); do
    printf "%-${width}s %s\n" \
      "${dirs[i]:-}" \
      "${files[i]:-}"
  done
}

check() {
    local orange='%F{208}'
    local green='%F{green}'
    local yellow='%F{yellow}'
    local red='%F{red}'
    local gray='%F{244}'
    local reset='%f'

    local separator="────────────────────────────────────────"
    local product_name
    local product_version
    local build_version
    local model_name
    local chip_name
    local architecture
    local battery_info
    local battery_percentage
    local battery_state
    local power_source
    local gateway
    local wifi_ip
    local ethernet_ip
    local tailscale_ip
    local memory_bytes
    local memory_gb
    local memory_pressure
    local filevault_status
    local brew_updates
    local macos_updates
    local thermal_pressure
    local time_machine_destination
    local time_machine_backup
    local tailscale_available=0

    # ── System information ─────────────────────

    echo "$separator"
    print -Pn "${orange}Host:${reset} "
    hostname

    echo "$separator"
    print -Pn "${orange}Computer Name:${reset} "
    scutil --get ComputerName 2>/dev/null ||
        print -P "${gray}Unavailable${reset}"

    echo "$separator"
    print -P "${orange}macOS:${reset}"

    product_name="$(sw_vers -productName)"
    product_version="$(sw_vers -productVersion)"
    build_version="$(sw_vers -buildVersion)"

    printf '%s %s — Build %s\n' \
        "$product_name" \
        "$product_version" \
        "$build_version"

    echo "$separator"
    print -Pn "${orange}Mac Model:${reset} "

    model_name="$(
        system_profiler SPHardwareDataType 2>/dev/null |
            awk -F': ' '/Model Name/{print $2; exit}'
    )"

    printf '%s\n' "${model_name:-Unavailable}"

    echo "$separator"
    print -Pn "${orange}Model Identifier:${reset} "

    sysctl -n hw.model 2>/dev/null ||
        print -P "${gray}Unavailable${reset}"

    echo "$separator"
    print -Pn "${orange}Chip:${reset} "

    chip_name="$(
        system_profiler SPHardwareDataType 2>/dev/null |
            awk -F': ' '/Chip/{print $2; exit}'
    )"

    printf '%s\n' "${chip_name:-Unavailable}"

    echo "$separator"
    print -Pn "${orange}Architecture:${reset} "

    architecture="$(uname -m)"
    printf '%s\n' "$architecture"

    echo "$separator"
    print -Pn "${orange}Kernel:${reset} "

    uname -r

    echo "$separator"
    print -Pn "${orange}Uptime:${reset} "

    uptime |
        sed -E \
            's/^[[:space:]]*[0-9:]+[[:space:]]+up[[:space:]]+/up /; s/,[[:space:]]+[0-9]+ users?.*$//'

    echo "$separator"
    print -P "${orange}System Load:${reset}"

    sysctl -n vm.loadavg 2>/dev/null |
        tr -d '{}'

    # ── Battery and power ──────────────────────

    echo "$separator"
    print -P "${orange}Battery and Power:${reset}"

    battery_info="$(pmset -g batt 2>/dev/null)"

    if [[ -n "$battery_info" ]]; then
        power_source="$(
            printf '%s\n' "$battery_info" |
                awk -F"'" 'NR == 1 {print $2}'
        )"

        battery_percentage="$(
            printf '%s\n' "$battery_info" |
                awk -F';' '/%/ {
                    value=$1
                    sub(/^.*\t/, "", value)
                    gsub(/ /, "", value)
                    print value
                    exit
                }'
        )"

        battery_state="$(
            printf '%s\n' "$battery_info" |
                awk -F';' '/%/ {
                    state=$2
                    gsub(/^[[:space:]]+/, "", state)
                    gsub(/[[:space:]]+$/, "", state)
                    print state
                    exit
                }'
        )"

        printf 'Battery: %s — %s | Power: %s\n' \
            "${battery_percentage:-Unavailable}" \
            "${battery_state:-Unknown}" \
            "${power_source:-Unknown}"
    else
        print -P "${gray}Battery information is unavailable${reset}"
    fi

    # ── Thermal and power conditions ───────────

    echo "$separator"
    print -P "${orange}Thermal Status:${reset}"

    thermal_pressure="$(
        pmset -g therm 2>/dev/null |
            sed '/^[[:space:]]*$/d'
    )"

    if [[ -n "$thermal_pressure" ]]; then
        printf '%s\n' "$thermal_pressure"
    else
        print -P "${green}No thermal warnings reported${reset}"
    fi

    # ── Service and application status ─────────

    echo "$separator"
    print -P "${orange}Service Status:${reset}"

    # SSH / Remote Login
    if pgrep -x sshd >/dev/null 2>&1; then
        print -P "SSH is ${green}running${reset}"
    else
        print -P \
            "SSH has ${yellow}no active server process${reset}"
    fi

    # Tailscale
    if pgrep -if \
        'Tailscale.app|tailscaled' \
        >/dev/null 2>&1
    then
        print -P "Tailscale is ${green}running${reset}"
    else
        print -P "Tailscale is ${yellow}not running${reset}"
    fi

    # Docker Desktop and Docker Engine
    if command -v docker >/dev/null 2>&1; then
        if docker info >/dev/null 2>&1; then
            print -P "Docker is ${green}running${reset}"
        else
            print -P \
                "Docker is installed but ${yellow}not running${reset}"
        fi
    else
        print -P "Docker is ${gray}not installed${reset}"
    fi

    # ── Failed user agents ─────────────────────


    # ── Network information ────────────────────

    echo "$separator"
    print -P "${orange}Network Addresses:${reset}"

    wifi_ip="$(ipconfig getifaddr en0 2>/dev/null)"
    ethernet_ip="$(ipconfig getifaddr en1 2>/dev/null)"

    if [[ -n "$wifi_ip" ]]; then
        printf 'en0: %s\n' "$wifi_ip"
    else
        print -P "en0: ${gray}Not connected${reset}"
    fi

    if [[ -n "$ethernet_ip" ]]; then
        printf 'en1: %s\n' "$ethernet_ip"
    else
        print -P "en1: ${gray}Not connected${reset}"
    fi

    echo "$separator"
    print -Pn "${orange}Default Gateway:${reset} "

    gateway="$(
        route -n get default 2>/dev/null |
            awk '/gateway:/ {print $2; exit}'
    )"

    if [[ -n "$gateway" ]]; then
        printf '%s\n' "$gateway"
    else
        print -P "${red}Unavailable${reset}"
    fi

    # ── Wi-Fi information ──────────────────────

    echo "$separator"
    print -P "${orange}Wi-Fi Status:${reset}"

    if command -v networksetup >/dev/null 2>&1; then
        networksetup -getairportnetwork en0 2>/dev/null ||
            print -P "${gray}Wi-Fi information unavailable${reset}"
    else
        print -P "${gray}networksetup is unavailable${reset}"
    fi

    # ── Tailscale information ──────────────────

    echo "$separator"
    print -Pn "${orange}Tailscale IP:${reset} "

    if command -v tailscale >/dev/null 2>&1; then
        tailscale_available=1

        tailscale_ip="$(
            tailscale ip -4 2>/dev/null
        )"

        if [[ -n "$tailscale_ip" ]]; then
            printf '%s\n' "$tailscale_ip"
        else
            print -P "${red}Unavailable${reset}"
        fi
    else
        print -P "${gray}Tailscale CLI is unavailable${reset}"
    fi

    echo "$separator"
    print -P "${orange}Tailscale Status:${reset}"

    if (( tailscale_available )); then
        if ! tailscale status 2>/dev/null; then
            print -P \
                "${red}Unable to retrieve Tailscale status${reset}"
        fi
    elif pgrep -if 'Tailscale.app' >/dev/null 2>&1; then
        print -P \
            "${green}Tailscale app is running${reset}, but its CLI is not in PATH"
    else
        print -P "${gray}Tailscale is unavailable${reset}"
    fi

    # ── Docker information ─────────────────────

    echo "$separator"
    print -P "${orange}Docker Containers:${reset}"

    if command -v docker >/dev/null 2>&1; then
        if ! docker ps 2>/dev/null; then
            print -P \
                "${yellow}Docker Desktop is not running${reset}"
        fi
    else
        print -P "${gray}Docker is not installed${reset}"
    fi

    echo "$separator"
    print -P "${orange}Docker Disk Usage:${reset}"

    if command -v docker >/dev/null 2>&1; then
        if ! docker system df 2>/dev/null; then
            print -P \
                "${yellow}Docker Desktop is not running${reset}"
        fi
    else
        print -P "${gray}Docker is not installed${reset}"
    fi

    # ── Storage information ────────────────────

    echo "$separator"
    print -P "${orange}Root Filesystem:${reset}"

    df -h /

    # ── Memory information ─────────────────────

    echo "$separator"
    print -P "${orange}Memory:${reset}"

    memory_bytes="$(sysctl -n hw.memsize 2>/dev/null)"

    if [[ "$memory_bytes" == <-> ]]; then
        memory_gb="$(( memory_bytes / 1024 / 1024 / 1024 ))"
        printf 'Installed memory: %s GB\n' "$memory_gb"
    else
        print -P "${gray}Installed memory unavailable${reset}"
    fi

    memory_pressure="$(
        memory_pressure 2>/dev/null |
            awk -F': ' \
                '/System-wide memory free percentage/ {
                    print $2
                    exit
                }'
    )"

    if [[ -n "$memory_pressure" ]]; then
        printf 'System memory free: %s\n' "$memory_pressure"
    fi

    echo
    vm_stat

    # ── FileVault status ───────────────────────

    echo "$separator"
    print -P "${orange}FileVault:${reset}"

    filevault_status="$(fdesetup status 2>/dev/null)"

    if [[ "$filevault_status" == *"FileVault is On"* ]]; then
        print -P "${green}${filevault_status}${reset}"
    elif [[ -n "$filevault_status" ]]; then
        print -P "${yellow}${filevault_status}${reset}"
    else
        print -P "${gray}Unable to determine FileVault status${reset}"
    fi

    # ── Time Machine information ───────────────

    echo "$separator"
    print -P "${orange}Time Machine:${reset}"

    time_machine_destination="$(
        tmutil destinationinfo 2>/dev/null |
            awk -F': ' '/Name/{print $2; exit}'
    )"

    time_machine_backup="$(
        tmutil latestbackup 2>/dev/null
    )"

    if [[ -n "$time_machine_destination" ]]; then
        printf 'Destination: %s\n' "$time_machine_destination"
    else
        print -P "Destination: ${gray}Not configured or unavailable${reset}"
    fi

    if [[ -n "$time_machine_backup" ]]; then
        printf 'Latest backup: %s\n' "$time_machine_backup"
    else
        print -P "Latest backup: ${gray}Unavailable${reset}"
    fi

    # ── macOS updates ──────────────────────────

    echo "$separator"
    print -P "${orange}macOS Updates:${reset}"

    macos_updates="$(
        softwareupdate -l 2>&1
    )"

    if [[ "$macos_updates" == *"No new software available"* ]]; then
        print -P "${green}macOS is up to date${reset}"
    elif [[ "$macos_updates" == *"Label:"* ]]; then
        print -P "${yellow}macOS updates are available${reset}"
    else
        print -P \
            "${gray}Unable to determine macOS update status${reset}"
    fi

    # ── Homebrew updates ───────────────────────

    echo "$separator"
    print -P "${orange}Homebrew Updates:${reset}"

    if command -v brew >/dev/null 2>&1; then
        brew_updates="$(brew outdated 2>/dev/null)"

        if [[ -n "$brew_updates" ]]; then
            print -P "${yellow}Outdated packages:${reset}"
            printf '%s\n' "$brew_updates"
        else
            print -P "${green}Homebrew packages are up to date${reset}"
        fi
    else
        print -P "${gray}Homebrew is not installed${reset}"
    fi

    # ── Installed tool versions ────────────────

    echo "$separator"
    print -Pn "${orange}Git Version:${reset} "

    if command -v git >/dev/null 2>&1; then
        git --version
    else
        print -P "${gray}Not installed${reset}"
    fi

    echo "$separator"
    print -Pn "${orange}Micro Version:${reset} "

    if command -v micro >/dev/null 2>&1; then
        micro --version
    else
        print -P "${gray}Not installed${reset}"
    fi

    echo "$separator"
    print -Pn "${orange}Rust Version:${reset} "

    if command -v rustc >/dev/null 2>&1; then
        rustc --version
    else
        print -P "${gray}Not installed${reset}"
    fi

    echo "$separator"
    print -Pn "${orange}Cargo Version:${reset} "

    if command -v cargo >/dev/null 2>&1; then
        cargo --version
    else
        print -P "${gray}Not installed${reset}"
    fi

    echo "$separator"
}



source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Update Environment Path
export PATH="/opt/homebrew/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Added by codebase-memory-mcp install
export PATH="/Users/shaho/.local/bin:$PATH"
export PATH="/Users/shaho/.local/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/shaho/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
