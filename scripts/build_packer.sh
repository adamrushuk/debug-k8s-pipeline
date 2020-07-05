#!/usr/bin/env bash
#
# Build Packer configuration

# ensure strict mode and predictable pipeline failure
set -euo pipefail
trap "echo 'error: Script failed: see failed command above'" ERR

# show packer version
packer version

# enable logging
echo "Set Packer logging environment variables..."
timestamp=$(date +"%Y%m%d-%H%M")
export PACKER_LOG_PATH="./packer_$timestamp.log"

# check environment vars
echo "DEBUG: show environment variables..."
printenv | sort

# check syntax
echo "Checking syntax for Packer config [$PACKER_CONFIG_PATH]..."
packer validate -syntax-only "$PACKER_CONFIG_PATH"

# Run Packer
# https://www.packer.io/docs/commands/build.html#on-error-cleanup
echo "Running Packer config [$PACKER_CONFIG_PATH] with options: [-on-error=$PACKER_ON_ERROR_ACTION], [-color=$PACKER_COLOR_OUTPUT_ENABLED]..."
packer build -on-error="$PACKER_ON_ERROR_ACTION" -color="$PACKER_COLOR_OUTPUT_ENABLED" -force "$PACKER_CONFIG_PATH"
