#!/bin/bash

# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || (echo "Already in a TMUX session" && exit 0)

function newSession() {
  read -p "Enter new session name: " SESSION_NAME
  tmux new-session -d -s $SESSION_NAME -n "nvim"
  tmux new-window -d -n "nu"
  tmux new-window -d -n "nu"
  tmux new-window -d -n "nu"
  tmux attach-session -d -t $SESSION_NAME
}

# present menu for user to choose which workspace to open
options=($(tmux list-sessions -F "#S" 2>/dev/null) "New Session")
if [ ${#options[@]} -eq 1 ]; then
  newSession
else
  PS3="Please choose your session: "
  echo "Available sessions"
  echo "------------------"
  select opt in "${options[@]}"
  do
    case $opt in
      "New Session")
        newSession
        break
        ;;
      *)
        tmux attach-session -t $opt
        break
        ;;
    esac
  done
fi
