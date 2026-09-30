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

    # AWS sets select a read-only SSO profile from ~/.aws/config. Resolving
    # its credentials up front makes the set fail closed on an expired SSO
    # session instead of failing inside the command that follows.
    _aws_profile_export() {
        aws configure export-credentials --profile "$1" >/dev/null || {
            echo "No credentials for AWS profile $1. If the SSO session" \
                "expired, ask the user to run: aws sso login" \
                "--sso-session bonfy-sso" >&2
            return 1
        }
        export AWS_PROFILE="$1"
    }

    # Scoped Atlassian tokens are rejected by bonfy.atlassian.net and only
    # work through the api.atlassian.com gateway, addressed by cloud ID.
    local atlassian_gateway="https://api.atlassian.com/ex"
    local atlassian_cloud_id="8bbc1007-9d5d-4d8a-b4a3-59ae40bff7c7"

    case "$1" in
        aws-cicd)
            _aws_profile_export agent-cicd
            ;;
        aws-dev01)
            _aws_profile_export agent-dev01
            ;;
        aws-prod01)
            _aws_profile_export agent-prod01
            ;;
        confluence)
            export ATLASSIAN_EMAIL="jacob.grant@bonfy.ai"
            export CONFLUENCE_API="$atlassian_gateway/confluence/$atlassian_cloud_id"
            _keychain_export ATLASSIAN_API_KEY "atlassian-api-key-ro-confluence"
            ;;
        jira)
            export ATLASSIAN_EMAIL="jacob.grant@bonfy.ai"
            export JIRA_API="$atlassian_gateway/jira/$atlassian_cloud_id"
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
            echo "  aws-cicd             AWS CLI/SDKs, CICD account (read-only)"
            echo "  aws-dev01            AWS CLI/SDKs, dev01 account (read-only)"
            echo "  aws-prod01           AWS CLI/SDKs, prod01 account (read-only)"
            echo "  confluence           Confluence API (read-only)"
            echo "  jira                 Jira API (read-only)"
            echo "  github-bonfy-ai      gh, Bonfy-AI org (read-only)"
            echo "  github-bonfy-devops  gh, Bonfy-DevOps org (read-only)"
            echo
            echo "AWS sets export AWS_PROFILE. Passing --profile overrides it; use"
            echo "a non-agent profile only when the user says to elevate."
            echo
            echo "Atlassian sets: curl -u \"\$ATLASSIAN_EMAIL:\$ATLASSIAN_API_KEY\" with"
            echo "\$JIRA_API or \$CONFLUENCE_API as the base, then the path from"
            echo "Atlassian's docs (\$JIRA_API/rest/api/3/..., \$CONFLUENCE_API/wiki/api/v2/...)."
            echo "The bonfy.atlassian.net site URL rejects these tokens."
            return 1
            ;;
    esac
}
