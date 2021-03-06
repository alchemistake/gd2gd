#!/bin/sh
set -e
connect_to_gd.sh

# Init restic if does not exists
if [ -z "$(restic cat config)" ] 2>/dev/null; then
  restic init
fi

# Sweet Sweet Backup
restic unlock
restic backup $FROM_PATH
restic unlock
restic forget --keep-last $KEEP_LAST --prune
