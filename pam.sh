#!/bin/bash

if [ ! -d ".git" ]; then
  echo "ERROR: This is not a git repo. Please run the command in a git repository."
  exit 1
fi

if [[ -z $1 || -z $2 ]]; then
  echo "ERROR: You have to provide two branches as parameters. See \"pam -h\""
  exit 1
fi

# VARIABLES
REPO_BRANCHES=$(git branch)
REPO_BRANCHES=${REPO_BRANCHES/\*/}
INITIAL_BRANCH=$(git branch --show-current)
# REPO_BRANCHES=${REPO_BRANCHES//\\n/}
REPO_REMOTES=$(git remote -v)
REMOTE=${3:-origin}

reset_to_normal() {
  echo
  echo "Reseting to inital state before running command ..."
  git switch "$1"
}

pull_and_merge() {  
  trap "reset_to_normal $INITIAL_BRANCH" SIGINT
  git switch "$1" && git pull "$REMOTE" "$1" && git switch "$2" && git merge "$1" && echo "Done :)"
}

show_help() {
  echo "pam PULLING_BRANCH MERGING_BRANCH [ORIGIN]"
}

check_existance() {
  for B in $1; do
    if [[ "$B" == "$2" ]]; then
      return 0
    fi
  done
  return 1
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

check_existance "$REPO_BRANCHES" "$1"
if [ "$?" -ne "0" ]; then
  echo "ERROR: There is no branch called \"$1\""
  exit 1
fi

check_existance "$REPO_BRANCHES" "$2"
if [ "$?" -ne "0" ]; then
  echo "ERROR: There is no branch called \"$2\""
  exit 1
fi

check_existance "$REPO_REMOTES" "$3"
if [ "$?" -ne "0" ]; then
  echo "ERROR: There is no remote called \"$REMOTE\""
  exit 1
fi

if [[ -z $3 ]]; then
  echo "No remote has been provided. Default remote is \"origin\""
fi

while true; do
  read -p "Pull branch \"$1\" from the remote \"$REMOTE\" and merge it to branch \"$2\". right? [Yes, No] " USER_ANSWER
  case $USER_ANSWER in
    [Yy]* ) pull_and_merge $1 $2; exit 0;;
    [Nn]* ) reset_to_normal $INITIAL_BRANCH; exit 1;;
    * ) echo "Please answer yes or no.";;
  esac
done
