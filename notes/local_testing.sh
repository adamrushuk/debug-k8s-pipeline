#!/usr/bin/env bash
#
# Local testing

# export env vars from Jenkins file
export CI_DEBUG_ENABLED="true"
export PACKER_ON_ERROR_ACTION="ask"
export PACKER_LOG=1
export PACKER_COLOR_OUTPUT_ENABLED="false"
export PACKER_CONFIG_PATH="./packer/ubuntu-ansible.json"

# info
printenv | sort | grep PACKER
ll ./packer
ll ./scripts

# enable logging
timestamp=$(date +"%Y%m%d-%H%M")
export PACKER_LOG_PATH="./packer_$timestamp.log"

# build with "-debug"
packer build -debug -color="$PACKER_COLOR_OUTPUT_ENABLED" -force "$PACKER_CONFIG_PATH"

# prompt on error
packer build -on-error="$PACKER_ON_ERROR_ACTION" -color="$PACKER_COLOR_OUTPUT_ENABLED" -force "$PACKER_CONFIG_PATH"
