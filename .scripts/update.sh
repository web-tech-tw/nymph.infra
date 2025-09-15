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

  # Generate .env file from .env.tmpl using envsubst
  envsubst <.env.tmpl >.env

  # Deploy using docker-compose if the file exists
  if [ -f "compose.yml" ]; then
    docker-compose up -d
  fi
 
  # Navigate back to the parent directory
  cd ..
done
