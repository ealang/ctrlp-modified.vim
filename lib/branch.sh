#!/bin/sh -e
GITROOT=$(git rev-parse --show-toplevel)
FILES_GIT_REL="$(git diff $(git merge-base origin/HEAD HEAD 2> /dev/null || (git remote set-head origin -a > /dev/null && git merge-base origin/HEAD HEAD)).. --name-only)"
FILES_ABS=$(cd $GITROOT && realpath $FILES_GIT_REL)
FILES_PWD_REL=$(realpath --relative-to=$(pwd) $FILES_ABS)
if [ -n "$FILES_PWD_REL" ]; then
  echo "$FILES_PWD_REL" | sort -u | xargs find 2> /dev/null || true
fi
