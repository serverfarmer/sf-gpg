#!/bin/sh

keyname=`/opt/farm/ext/keys/get-gpg-backup-key.sh`

if [ "$keyname" != "" ]; then
	/opt/farm/ext/gpg/setup-key.sh $keyname
fi
