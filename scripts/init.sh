#!/usr/bin/env bash
#
# init tasks

# ensure strict mode and predictable pipeline failure
set -euo pipefail
trap "echo 'error: Script failed: see failed command above'" ERR

# start detached screen session
screen -dmS jenkins

# ssh keys
taskMessage="Creating SSH keys"
if [[ -e "$HOME/.ssh/id_rsa" ]]; then
    echo "SKIPPING: $taskMessage..."
else
    echo "STARTED: $taskMessage..."
    mkdir -p "$HOME/.ssh"
    chmod 0700 "$HOME/.ssh"
    ssh-keygen -f "$HOME/.ssh/id_rsa" -t rsa -N ''
    chmod 600 "$HOME/.ssh/id_rsa"
    echo "FINISHED: $taskMessage..."
fi
