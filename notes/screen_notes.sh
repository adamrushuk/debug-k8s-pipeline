#!/usr/bin/env bash
#
# Testing methods of attaching to TTY session / process

# open bash shell (tty1)
# show current tty
tty

# show processes
ps -ef

# open another bash shell (tty2)
# show current tty
tty

# show processes
ps -ef


#region screen
# common commands for managing Linux Screen Windows:
# Ctrl+a, ? list commands
# Ctrl+a, c Create a new window (with shell)
# Ctrl+a, " List all window
# Ctrl+a, 0 Switch to window 0 (by number)
# Ctrl+a, A Rename the current window
# Ctrl+a, S Split current region horizontally into two regions
# Ctrl+a, | Split current region vertically into two regions
# Ctrl+a, tab Switch the input focus to the next region
# Ctrl+a, Ctrl+a Toggle between the current and previous region
# Ctrl+a, Q Close all regions but the current one
# Ctrl+a, X Close the current region

# enter root session (as jenkins container runs as root)
sudo su

# info
screen --version
screen --help

# [OPTION 1] start attached with a named session
screen -S jenkins

# [OPTION 2] start detached with a named session - useful in CI pipeline with no tty available
screen -dmS jenkins

# list sessions
screen -ls

# start long running command
watch date


# FROM A NEW TERMINAL SESSION
# -d detaches the already-running screen session, and screen -r reattaches the existing session
screen -d -r

# Detach from Linux Screen Session
Ctrl+a d


# Reattach to a Linux Screen
# find the session ID list the current running screen sessions with:
screen -ls

# attach a single detached session without specifying ID
screen -r

# attach a detached session by ID
screen -r <SESSION_ID>


# show terminal / screen env vars
env | egrep -i "STY|TERM"
#endregion screen
