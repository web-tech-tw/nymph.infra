#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Load environment variables from webhook if available
if [ -n "$1" ]; then
  eval "$(echo "$1" | jq -r '.env | to_entries[] | "export \(.key)=\(.value | @sh)"')"
fi

# Pull the latest changes
git pull origin main

# Iterate over each directory in the current directory
for dir in */; do
  # Skip certain directories
  if [ "$dir" == ".scripts/" ]; then
    continue
  fi

  if [ "$dir" == "static/" ]; then
    continue
  fi

  # Navigate into the directory
  cd "$dir"

  # Run init.sh if needed and track its state
  if [ -f "init.sh" ] && { [ ! -f ".initialized" ] || ! md5sum -c .initialized >/dev/null 2>&1; }; then
    echo "Running init.sh in $dir"
    bash init.sh
    md5sum init.sh >.initialized
  fi

  # Generate config.env file from template using envsubst
  if [ -f "config.env.tmpl" ]; then
    envsubst <config.env.tmpl >config.env
  else
    echo "No environment template found in $dir"
  fi

  # Deploy using docker-compose if the file exists
  if [ -f "compose.yml" ]; then
    docker-compose up -d
  fi
 
  # Navigate back to the parent directory
  cd ..
done
