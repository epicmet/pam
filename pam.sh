#!/bin/bash

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
  if [[ "$(git branch --show-current)" -ne "$1" ]]; then
    echo "I AM HERE"
  fi
}

pull_and_merge() {  
  trap "reset_to_normal $INITIAL_BRANCH" SIGINT
  git switch "$1" && git pull "$REMOTE" "$1" && git switch "$2" && git merge "$1" && echo "Done :)"
}


if [ ! -d ".git" ]; then
  echo "ERROR: This is not a git repo. Please run the command in a git repository."
  exit 1
fi

if [[ -z $1 || -z $2 ]]; then
  echo "ERROR: You have to provide two branches as parameters. See \"pam -h\""
  exit 1
fi

if [[ -z $3 ]]; then
  echo "No remote has been provided. Default remote is \"origin\""
fi

if [[ ! "$REPO_BRANCHES" == *"$1"* ]]; then
  echo "ERROR: There is no branch called \"$1\""
  exit 1
fi

if [[ ! "$REPO_BRANCHES" == *"$2"* ]]; then
  echo "ERROR: There is no branch called \"$2\""
  exit 1
fi

if [[ ! "$REPO_REMOTES" == *"$REMOTE"* ]]; then
  echo "ERROR: There is no remote called \"$REMOTE\""
  exit 1
fi

while true; do
  read -p "Pull branch \"$1\" from the remote \"$REMOTE\" and merge it to branch \"$2\". right? [Yes, No] " USER_ANSWER
  case $USER_ANSWER in
      [Yy]* ) pull_and_merge $1 $2; exit 0;;
      [Nn]* ) reset_to_normal $INITIAL_BRANCH; exit 1;;
      * ) echo "Please answer yes or no.";;
  esac
done
