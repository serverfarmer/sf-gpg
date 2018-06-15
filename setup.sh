#!/bin/bash
. /opt/farm/ext/keys/functions


keyname=`gpg_backup_key`

if [ "$keyname" != "" ]; then
	/opt/farm/ext/gpg/setup-key.sh $keyname
fi
