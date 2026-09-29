# Dotfiles

GNU Stow manages this repo. Each top-level directory is a package; `./stow.sh` symlinks its contents into `$HOME`.

## Layout

- **A package mirrors `$HOME`.** A file lives at the path it should occupy relative to `~`: `claude/.claude/settings.json` → `~/.claude/settings.json`.
- **Files at the repo root are never stowed** — `stow.sh` only iterates directories. Config dropped there is dead weight; put it in a package.
- **Stow links individual files, never whole directories.** `stow.sh` passes `--no-folding`, so a directory that exists only in the repo is still created as a real directory in `$HOME`. That keeps application data (`~/.claude/projects/`, `sessions/`, history) out of the repo. The tradeoff: a newly added file isn't live until you re-run `./stow.sh`.

## Editing

- **These files are live config.** `~/.claude/CLAUDE.md` and `~/.claude/settings.json` are symlinks into `claude/.claude/`. Editing either path edits this repo — commit it, don't treat it as scratch.
- **Stow aborts on conflict** when a target exists as a real file. Move the target aside first. Don't reach for `--adopt`: it resolves conflicts by pulling the live file into the repo, overwriting the version here.
- `**/.claude/settings.local.json` is gitignored globally, so machine-local permission grants stay out of the repo.

## Claude Code permissions

`claude/.claude/settings.json` is a security boundary, not just preferences. Two rules when adding to `permissions.allow`:

- **Put every `*` after the subcommand.** `Bash(git -C * status *)` matches options inserted at the wildcard, including `-c` and `--exec-path`, which make git run an arbitrary program. Claude Code warns about this shape at startup.
- **Don't allowlist an exec primitive.** `python -c`, `env`, and bare `gh api` approve anything that follows. Deny rules for `rm`, `sudo`, and secret paths don't constrain a subprocess that opens files itself.
