#!/bin/sh
#
# PreToolUse hook for Bash: deny commands that reach for credentials
# directly. A guardrail against mistakes, not a security boundary --
# string-matching shell commands is easy to get around.

command=$(jq -r '.tool_input.command')

# Command position: line start, after a separator, subshell, quote, or path.
cmd_start="(^|[;&|(\`\"'/])[[:space:]]*"

matches() {
    printf '%s\n' "$command" | grep -qiE "$1"
}

deny() {
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
    exit 0
}

matches "${cmd_start}security([[:space:]]|\$)" &&
    deny "Blocked: keychain access is not permitted; use agent-auth"

matches "${cmd_start}creds([[:space:]]|\$)" &&
    deny "Blocked: creds loads read-write credentials; use agent-auth"

matches '((sed|perl)[[:space:]].*-[[:alnum:]]*i|>|tee|mv|cp|ln|chmod|truncate).*agent_auth' &&
    deny "Blocked: agent_auth.sh is not editable by agents"

exit 0
