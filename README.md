# dotfiles

*nix configuration files


### bash/

- `.bash_aliases`
  - Sources `.common_aliases.sh`
  - Sets Bash history length


### common/

- `.common_aliases.sh` – Common shell aliases used by bash, zsh, etc.
  - Configures PATH variable
  - General aliases
  - Python aliases/functions
  - `creds` function for loading credentials from the macOS Keychain

- `.agent_auth.sh` – `agent-auth` function that loads read-only credentials for coding agents


### git/

- `.gitconfig` – Global configuration for `git`

- `.gitignore_global` – Global `.gitignore` for files/directories that should always be ignored by `git`


### zsh/

- `.zprofile` – 
  - Configures Homebrew variables/PATH

- `.zshrc` – 
  - Sources `.common_aliases.sh`
  - Sets zsh prompt
  - Sets zsh right prompt using git info


### stow.sh

The `stow.sh` script can be used to quickly and easily symlink the dotfiles in this repository into a users home directory. Using GNU Stow, it creates symlinks in the user's home directory for the contents of each directory located in the same directory as the script.
