### Common Shell Aliases ###
#
# Common aliases across shells (bash, zsh, etc.)
#
# Table of Contents:
#   - ENVIRONMENT
#   - TOOLS & SERVICES  
#   - CORE ALIASES
#   - PACKAGE MANAGERS
#   - DEVELOPMENT TOOLS
#   - UTILITIES
#   - BONFY FUNCTIONS
#


## ENVIRONMENT ##

# Environment Variables #

export BONFY_GIT_DIR="$HOME/Developer/bonfy_repos"
export LOCAL_MODELS_DIR="$HOME/Developer/data/models"


# PATH Extensions #

# /usr/local/go/bin
if [ -d "/usr/local/go/bin" ]
then
    export PATH="$PATH:/usr/local/go/bin"
fi


# ~/.local/bin
if [ -d "$HOME/.local/bin" ]
then
    export PATH="$HOME/.local/bin:$PATH"
fi


# pyenv
if [ -d "$HOME/.pyenv" ]
then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi


# Go Configuration #

if [ -d "$HOME/Developer" ]
then
    export GOPATH="$HOME/Developer/go"
else
    export GOPATH="$HOME/.go"
fi


## TOOLS & SERVICES ##


## CORE ALIASES ##

# System & Navigation #

alias celar="clear"
alias cls="clear && ls -CF"


alias h="history"
alias hg="history | grep"


# ls with color
if command -v ls >/dev/null 2>&1
then
    if ls --color=auto >/dev/null 2>&1
    then
        alias ls="ls --color=auto"
    fi
fi


# ls
alias l="ls -CF"
alias la="ls -aCF"
alias ll="ls -lhF"
alias lla="ls -lahF"


# Grep with color
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"


# Make "open" portable
if command -v xdg-open >/dev/null 2>&1
then
    alias open='xdg-open'
fi


# Open VSC with 'code'
if [ -d "/Applications/Visual Studio Code.app" ] && ! command -v code >/dev/null
then
    alias code='open -a "/Applications/Visual Studio Code.app"'
fi


# Directory Navigation #

alias cdes="cd $HOME/Desktop"
alias cdev="cd $HOME/Developer"
alias cdoc="cd $HOME/Documents"
alias cdot="cd $HOME/.dotfiles"
alias cdow="cd $HOME/Downloads"

alias gogit="cd $BONFY_GIT_DIR && ls"


# Git #

alias gpo="git push origin"
alias gum="git checkout master && git pull upstream master"


## PACKAGE MANAGERS ##

# Homebrew #

if command -v brew >/dev/null 2>&1
then
    alias brewup="brew update && brew upgrade"
    alias brewc="brew cleanup"
fi


# APT #

if command -v apt-get >/dev/null 2>&1
then
    alias aptup="sudo apt-get update && sudo apt-get upgrade"
    alias aptupd="sudo apt-get update && sudo apt-get dist-upgrade"
    alias apti="sudo apt-get install"
    alias aptui="sudo apt-get remove"
    alias aptuia="sudo apt-get purge"
    alias aptrm="sudo apt-get autoremove"
    alias aptcl="sudo apt-get autoclean"
    alias apts="apt-cache search"
    alias aptsh="apt-cache show"
fi


## DEVELOPMENT TOOLS ##

# Python #

# python -> python3
if ! command -v python &> /dev/null
then
    alias python="python3"
fi


# pip -> pip3
if ! command -v pip &> /dev/null
then
    alias pip="pip3"
fi


# venv
venv() {
    local python_interpreter=python3
    local env_name
    local verbose=0

    while [[ "$1" ]]
    do
        case "$1" in
            -p)
                python_interpreter="$2"
                shift 2
                ;;
            -v)
                verbose=1
                shift
                ;;
            *)
                env_name="$1"
                shift
                ;;
        esac
    done

    if [ -z "$env_name" ]
    then
        echo "Usage: venv <env_name> [-p python_interpreter] [-v]"
        return 1
    fi

    local activate_script="$env_name/bin/activate"

    if [ -d "$env_name" ]
    then
        if [ -f "$activate_script" ]
        then
            [ $verbose -eq 1 ] && echo "Activating existing Python virtual environment in '$env_name'"
            source "$activate_script"
        else
            echo "Directory '$env_name' exists but does not appear to be a Python virtual environment."
            return 1
        fi
    else
        [ $verbose -eq 1 ] && echo "Creating new Python virtual environment in '$env_name' with interpreter $python_interpreter"
        $python_interpreter -m venv "$env_name"
        if [ -f "$activate_script" ]
        then
            [ $verbose -eq 1 ] && echo "Activating the new Python virtual environment"
            source "$activate_script"
        else
            echo "Failed to find the activate script. Virtual environment may not have been created correctly."
            return 1
        fi
    fi
}


# Terraform #

if command -v terraform &> /dev/null
then
    alias tf="terraform"
    alias tfi="terraform init"
    alias tfiu="terraform init -upgrade"
    alias tfv="terraform validate"
    alias tfp="terraform plan"
    alias tfa="terraform apply"
    alias tfd="terraform destroy"
    alias tfc="terraform console"
    alias tff="terraform fmt"
    alias tfg="terraform get"
    alias tfm="terraform modules"
    alias tfo="terraform output"
    alias tfs="terraform state"
    alias tfw="terraform workspace"
fi


# Terragrunt #

if command -v terragrunt &> /dev/null
then
    alias tg="terragrunt"
fi


# Terrascan #

if command -v terrascan &> /dev/null
then
    alias ts="terrascan"
    alias tss="terrascan scan -iac-type terraform"
fi


# Terraform Lint #

if command -v tflint &> /dev/null
then
    alias tfl="tflint"
    alias tfli="tflint -init"
fi


# Terraform Docs #

if command -v terraform-docs &> /dev/null
then
    alias tfdoc="terraform-docs"
    alias tfdoca="terraform-docs asciidoc"
    alias tfdocj="terraform-docs json"
    alias tfdocm="terraform-docs markdown"
    alias tfdocp="terraform-docs pretty"
    alias tfdoct="terraform-docs toml"
    alias tfdocv="terraform-docs tfvars"
    alias tfdocx="terraform-docs xml"
    alias tfdocy="terraform-docs yaml"
fi


# System Administration #

# Allows using sudo with other aliases
alias sudo='sudo '


# systemd (systemctl)
if command -v systemctl > /dev/null 2>&1
then
    alias sstatus="systemctl status"
    alias sstart="sudo systemctl start"
    alias sstop="sudo systemctl stop"
    alias srestart="sudo systemctl restart"
    alias sreload="sudo systemctl reload"
    alias senable="sudo systemctl enable"
    alias sdisable="sudo systemctl disable"
    alias smask="sudo systemctl mask"
    alias sunmask="sudo systemctl unmask"
fi


## UTILITIES ##

## Searching Files #

# find/grep shortcuts
alias pfind='find . -type f -name "*.py" | xargs -n 1 grep'
alias tfind='find . -type f -name "*.tf" | xargs -n 1 grep'


# Archives (tar) #

alias mktar="tar -cvf"
alias untar="tar -xvf"
alias mkgz="tar -czvf" 
alias ungz="tar -xzvf"


# SSH #

# Get SSH public key
pubkey() {
    local keyfile="${1:-id_ed25519.pub}"

    # Append .pub if not present
    case "$pubkeyfile" in
        *.pub) ;;
        *) pubkeyfile="$pubkeyfile.pub" ;;
    esac

    local fullpath="$HOME/.ssh/$pubkeyfile"

    if [ ! -f "$fullpath" ]
    then
        echo "Key not found: $fullpath" >&2
        return 1
    fi

    if command -v pbcopy >/dev/null 2>&1
    then
        tee >(pbcopy) < "$fullpath"
    else
        cat "$fullpath"
    fi
}


## Bonfy Functions ##

# act #

#act Function – wraps act for running GitHub Actions locally #
function act() {

    # Branch local gh-actions is on
    DEV_BRANCH=$(cd "$BONFY_GIT_DIR/gh-actions" && git rev-parse --abbrev-ref HEAD)

    # Mongo user/password (keep in sync with repo's config/default.env
    MONGODB_USER=root
    MONGODB_PASSWORD=root

    # Fetch current CodeArtifact token and ECR login (every time since they expire)
    CODEARTIFACT_AUTH_TOKEN=$(aws codeartifact get-authorization-token \
        --domain bonfy \
        --domain-owner 211125345717 \
        --query authorizationToken \
        --output text \
        --profile cicd \
        --region us-west-2
    )
    ECR_LOGIN_PASSWORD=$(aws ecr get-login-password --region us-west-2 --profile cicd)

    # Set ACT_ENV to cicd-dev unless ENV in environment
    ACT_ENV=${ACT_ENV:-cicd-dev}

    /opt/homebrew/bin/act \
        --container-architecture linux/arm64 \
        --secret GITHUB_TOKEN="$(gh auth token)" \
        --local-repository "https://github.com/Bonfy-AI/gh-actions@main=$BONFY_GIT_DIR/gh-actions" \
        --local-repository "https://github.com/Bonfy-AI/gh-actions@$DEV_BRANCH=$BONFY_GIT_DIR/gh-actions" \
        --platform ubuntu-latest=bonfy-act-runner \
        --platform self-hosted-amd64=bonfy-act-runner \
        --platform self-hosted-amd64-models=bonfy-act-runner \
        --platform self-hosted-arm64=bonfy-act-runner \
        --platform self-hosted-arm64-models=bonfy-act-runner \
        --pull=false \
        --env-file <(aws configure export-credentials --format env) \
        --env CODEARTIFACT_AUTH_TOKEN="$CODEARTIFACT_AUTH_TOKEN" \
        --env ECR_LOGIN_PASSWORD="$ECR_LOGIN_PASSWORD" \
        --env USING_ACT="true" \
        --env ENV="$ACT_ENV" \
        --env FORCE="$FORCE" \
        --secret MONGODB_USER="$MONGODB_USER" --secret MONGODB_PASSWORD="$MONGODB_PASSWORD" \
        --container-options "-v $LOCAL_MODELS_DIR:$LOCAL_MODELS_DIR" \
        --env EFS="$LOCAL_MODELS_DIR" \
        "$@"
}
