#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/aaditron/dotfiles"
REPO_NAME="dotfiles"

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  cd "$REPO_NAME"
  cd config
  for file in $(ls -1)
  do
	  cp -r $file $HOME/.config/
  done
else
  echo "Failed to clone the repository."
  exit 1
fi

