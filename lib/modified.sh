#!/bin/sh -e
GITROOT=$(git rev-parse --show-toplevel)
if [ -e $GITROOT/.git/MERGE_HEAD ] || [ -d $GITROOT/.git/rebase-merge ] || [ -d $GITROOT/.git/rebase-apply ] || [ -e $GITROOT/.git/CHERRY_PICK_HEAD ]; then
  git status --porcelain -z | tr '\0' '\n' | grep '^[^?][^ ?] ' | cut -d ' ' -f 2-
else
  FILES_GIT_REL="$(git status --porcelain -z --untracked-files=all | tr '\0' '\n' | cut -c 4-)"
  FILES_ABS=$(cd $GITROOT && realpath $FILES_GIT_REL)
  FILES_PWD_REL=$(realpath --relative-to=$(pwd) $FILES_ABS)
  if [ -n "$FILES_PWD_REL" ]; then
    echo "$FILES_PWD_REL" | tr '\n' '\0' | xargs -0 find 2> /dev/null || true
  fi
fi
