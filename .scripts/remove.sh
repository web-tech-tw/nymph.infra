#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Load environment variables from webhook if available
if [ -n "$1" ]; then
  eval "$(echo "$1" | jq -r '.env | to_entries[] | "export \(.key)=\(.value | @sh)"')"
fi

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

  # Deploy using docker-compose if the file exists
  if [ -f "compose.yml" ]; then
    docker-compose down
  fi
 
  # Navigate back to the parent directory
  cd ..
done
