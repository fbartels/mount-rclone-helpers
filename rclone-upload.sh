#!/usr/bin/env bash

## Defaults
SOURCECLEARTEXT=/backup/data		# name of directory that should be backed up
RCLONEREMOTE=crypt:					# name of rclone remote to upload to
RCLONEULTYPE=check					# type of upload. can be check, sync or copy
RCLONETRANSFERS=4					# amount of simultaneous uploads

## no need to change anything below

# if a config file has been specified with BACKUP_CONFIG=myfile use this one, otherwise default to config
BASE_PATH="$(dirname "$(readlink -f "$0")")"
if [[ ! -n "$BACKUP_CONFIG" ]]; then
	BACKUP_CONFIG="$BASE_PATH/config"
fi

if [ -e $BACKUP_CONFIG ]; then
	echo "using config from file: $BACKUP_CONFIG"
	source "$BACKUP_CONFIG"
fi

# check dependencies
if [ ! "$(which rclone)" ]; then
	echo "rclone is not installed"
	exit 1
fi

# script logic begins here
rclone --verbose -checksum --no-traverse --no-update-modtime --transfers=$RCLONETRANSFERS $RCLONEULTYPE $SOURCECLEARTEXT $RCLONEREMOTE
