#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check directory variables
if [ ! -n "$1" ]; then
	exit 1
fi

# Assign to directory variable
dir="$1"

# Skip certain directories
if [ "$dir" == ".scripts/" ]; then
	exit 1
fi

if [ "$dir" == "static/" ]; then
	exit 1
fi

# Navigate into the directory
cd "$dir"

# Deploy using docker-compose if the file exists
if [ -f "compose.yml" ]; then
	docker-compose down --remove-orphans
else
  echo "No compose.yml found in $dir, nothing to bring down."
fi
