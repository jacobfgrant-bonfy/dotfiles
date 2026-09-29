# dotfiles

*nix configuration files


### bash/

- `.bash_aliases`
  - Sources `.common_aliases.sh`
  - Sets Bash history length


### claude/

- `.claude/CLAUDE.md` – Global instructions for Claude Code

- `.claude/settings.json` – Global Claude Code settings
  - Permission allow/deny rules
  - Registers the credential-blocking hook

- `.claude/hooks/block-credential-access.sh` – PreToolUse hook that blocks agent Bash commands that use `security`, call `creds`, or write to `.agent_auth.sh`


### common/

- `.common_aliases.sh` – Common shell aliases used by bash, zsh, etc.
  - Configures PATH variable
  - General aliases
  - Python aliases/functions
  - `creds` function for loading credentials from the macOS Keychain

- `.agent_auth.sh` – `agent-auth <set>` function that loads one set of read-only credentials for coding agents


### git/

- `.gitconfig` – Global configuration for `git`

- `.gitignore_global` – Global `.gitignore` for files/directories that should always be ignored by `git`


### vim/

- `.vimrc` – Configuration for `vim`


### zsh/

- `.zprofile` – 
  - Configures Homebrew variables/PATH

- `.zshrc` – 
  - Sources `.common_aliases.sh`
  - Sets zsh prompt
  - Sets zsh right prompt using git info


### stow.sh

The `stow.sh` script can be used to quickly and easily symlink the dotfiles in this repository into a users home directory. Using GNU Stow, it creates symlinks in the user's home directory for the contents of each directory located in the same directory as the script. It links individual files rather than whole directories (`--no-folding`), so application data written to directories like `~/.claude/` stays out of the repository; re-run it after adding a file.
