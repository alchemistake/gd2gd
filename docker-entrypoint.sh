#!/bin/sh
set -e

# Google Drive OCAML Fuse connections
mkdir -p $FROM_PATH
mkdir -p $TO_PATH

# check if our config exists already
if [ -e "/config/.gdfuse/TO/config" ]; then
	echo "existing google-drive-ocamlfuse config found"
else
	if [ -z "${CLIENT_ID}" ]; then
		echo "no CLIENT_ID found"
		exit 1
	elif [ -z "${CLIENT_SECRET}" ]; then
		echo "no CLIENT_SECRET found"
		exit 1
	fi

  # Setup "FROM" google drive.
  # If the env var does not exists try interactive
	if [ -z ${VERIFICATION_CODE_FROM} ]; then
		google-drive-ocamlfuse -label FROM $FROM_PATH -headless -id "${CLIENT_ID}.apps.googleusercontent.com" -secret "${CLIENT_SECRET}"
	else
	  echo "${VERIFICATION_CODE_FROM}" | \
		 google-drive-ocamlfuse -label FROM $FROM_PATH -headless \
		 -id "${CLIENT_ID}.apps.googleusercontent.com" \
		 -secret "${CLIENT_SECRET}"
	fi

  # Setup "TO" google drive.
  # If the env var does not exists try interactive
	if [ -z ${VERIFICATION_CODE_TO} ]; then
		 google-drive-ocamlfuse -label TO $TO_PATH -headless \
		 -id "${CLIENT_ID}.apps.googleusercontent.com" \
		 -secret "${CLIENT_SECRET}"
	else
		 echo "${VERIFICATION_CODE_TO}" | \
		 google-drive-ocamlfuse -label TO $TO_PATH -headless \
		 -id "${CLIENT_ID}.apps.googleusercontent.com" \
		 -secret "${CLIENT_SECRET}"
	fi

	# Init restic if does not exists
  if [ -z "$(restic -r $TO_PATH cat config)" ] 2>/dev/null; then
    restic -r $TO_PATH init
  fi

  # Sweet Sweet Backup
  restic -r $TO_PATH backup $FROM_PATH
  restic -r $TO_PATH forget --keep-last $KEEP_LAST --prune
fi
