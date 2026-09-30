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

decide() {
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' "$1" "$2"
    exit 0
}

deny() {
    decide deny "$1"
}

ask() {
    decide ask "$1"
}

# Every AWS profile named in the command, as `--profile x` or `AWS_PROFILE=x`.
aws_profiles() {
    printf '%s\n' "$command" |
        grep -oiE "(--profile[[:space:]=]+|AWS_PROFILE=)[^[:space:];&|)]+"
}

matches "${cmd_start}security([[:space:]]|\$)" &&
    deny "Blocked: keychain access is not permitted; use agent-auth"

matches "${cmd_start}creds([[:space:]]|\$)" &&
    deny "Blocked: creds loads read-write credentials; use agent-auth"

matches '((sed|perl)[[:space:]].*-[[:alnum:]]*i|>|tee|mv|cp|ln|chmod|truncate).*agent_auth' &&
    deny "Blocked: agent_auth.sh is not editable by agents"

# Agents default to the read-only agent-* AWS profiles. Naming any other
# profile uses the user's own permissions, so confirm each such command.
matches "${cmd_start}(aws|sam)[[:space:]]|AWS_PROFILE=" &&
    aws_profiles | grep -viqE "[[:space:]=\"']agent-[[:alnum:]_-]+[\"']?\$" &&
    ask "Uses an AWS profile beyond the read-only agent-* profiles"

exit 0
