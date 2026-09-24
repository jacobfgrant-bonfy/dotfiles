# Agent Credentials #

# Read-only tokens that coding agents load on demand (`agent-auth && ...`).
# Keep this file read-only-only: agents are denied edits to it in
# claude/.claude/settings.json, and a PreToolUse hook blocks Bash commands
# that reference it.

agent-auth() {
    export ATLASSIAN_API_KEY=$(security find-generic-password -s "atlassian-api-key-ro" -w)
    export ATLASSIAN_EMAIL="jacob.grant@bonfy.ai"
    export GH_TOKEN_BONFY_AI=$(security find-generic-password -s "github-ro-bonfy-ai" -w)
    export GH_TOKEN_BONFY_DEVOPS=$(security find-generic-password -s "github-ro-bonfy-devops" -w)
}
