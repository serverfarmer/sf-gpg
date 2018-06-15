#!/bin/sh
. /opt/farm/scripts/functions.custom


keyname=`gpg_backup_key`

if [ "$keyname" != "" ]; then
	/opt/farm/ext/gpg/setup-key.sh $keyname
fi
