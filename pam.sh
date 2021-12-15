#!/bin/bash

# VARIABLES
REPO_BRANCHES=$(git branch)
REPO_BRANCHES=${REPO_BRANCHES/\*/}
# REPO_BRANCHES=${REPO_BRANCHES//\\n/}
REPO_REMOTES=$(git remote -v)
REMOTE=${3:-origin}

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

git switch "$1" &&
git pull "$REMOTE" "$1" &&
git switch "$2" &&
git merge "$1"