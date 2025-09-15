#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

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

  # Deploy using docker-compose if the file exists
  if [ -f "docker-compose.yml" ]; then
    docker-compose up -d
  fi
 
  # Navigate back to the parent directory
  cd ..
done
