#!/bin/bash

set -e

GIT_URL="https://github.com/web-tech-tw/wings.git"
GEN_DIR="autogen_wings"

if [ ! -d "$GEN_DIR" ]; then
  git clone "$GIT_URL" "$GEN_DIR"
else
  (
    cd "$GEN_DIR"
    git fetch origin
    git reset --hard "origin/main"
    git clean -fdx
  )
fi
