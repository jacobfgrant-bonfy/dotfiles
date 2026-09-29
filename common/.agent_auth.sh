# Agent Credentials #

# Read-only credential sets that coding agents load on demand, one set per
# command: `agent-auth <set> && ...`. Each set exports the variable names its
# tool reads, and fails closed so `&&` stops if the keychain read fails.
# Keep this file to read-only credentials: agents are denied edits to it in
# claude/.claude/settings.json, and a PreToolUse hook blocks Bash commands
# that write to it.

agent-auth() {
    # Defined inside agent-auth because Claude Code's shell snapshot drops
    # top-level functions whose names start with an underscore.
    _keychain_export() {
        local value
        value=$(security find-generic-password -s "$2" -w) || return 1
        export "$1=$value"
    }

    case "$1" in
        confluence)
            export ATLASSIAN_EMAIL="jacob.grant@bonfy.ai"
            _keychain_export ATLASSIAN_API_KEY "atlassian-api-key-ro-confluence"
            ;;
        jira)
            export ATLASSIAN_EMAIL="jacob.grant@bonfy.ai"
            _keychain_export ATLASSIAN_API_KEY "atlassian-api-key-ro-jira"
            ;;
        github-bonfy-ai)
            _keychain_export GH_TOKEN "github-ro-bonfy-ai"
            ;;
        github-bonfy-devops)
            _keychain_export GH_TOKEN "github-ro-bonfy-devops"
            ;;
        *)
            [ -n "$1" ] && echo "Unknown credential set: $1" >&2
            echo "Usage: agent-auth <set> && <command>"
            echo "  confluence           Confluence API (read-only)"
            echo "  jira                 Jira API (read-only)"
            echo "  github-bonfy-ai      gh, Bonfy-AI org (read-only)"
            echo "  github-bonfy-devops  gh, Bonfy-DevOps org (read-only)"
            return 1
            ;;
    esac
}
