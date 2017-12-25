#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.custom



if [ "$HWTYPE" = "container" ]; then
	echo "skipping gpg backup encryption key configuration"
	exit 0
fi


if [ ! -x /usr/bin/gpg ]; then
	if [ -x /usr/local/bin/gpg ]; then
		ln -s /usr/local/bin/gpg /usr/bin/gpg  # FreeBSD
	elif [ -x /usr/pkg/bin/gpg ]; then
		ln -s /usr/pkg/bin/gpg /usr/bin/gpg  # NetBSD
	fi
fi

if [ -d /.gnupg ] && [ ! -h /.gnupg ] && [ ! -d /root/.gnupg ]; then
	echo "applying fix for Proxmox VE 3.x key setup bug"
	mv -f /.gnupg /root
	ln -sf /root/.gnupg /.gnupg
fi

keyname=`gpg_backup_key`

if [ "`gpg --list-keys |grep $keyname`" = "" ]; then
	echo "setting up gpg backup encryption key"
	gpg --import /opt/farm/ext/keys/gpg/$keyname.pub

	if [ "$SF_UNATTENDED" = "" ]; then
		echo "#######################################################"
		echo "# Public key imported. Now enter 'trust' command at   #"
		echo "# the below command prompt, and set trust level to 5. #"
		echo "#######################################################"

		gpg --edit-key $keyname
	fi

	if [ "$OSTYPE" = "redhat" ]; then
		echo "applying fix for RHEL 6.x crontab bug"
		if [ -d /.gnupg ] && [ ! -h /.gnupg ]; then
			mv -f /.gnupg /.gnupg-orig
		fi
		ln -sf /root/.gnupg /.gnupg
	fi
fi
