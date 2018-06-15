#!/bin/bash
. /opt/farm/scripts/init


if [ ! -x /usr/bin/gpg ]; then
	if [ -x /usr/bin/gpg1 ]; then
		ln -s /usr/bin/gpg1 /usr/bin/gpg  # Debian 9
	elif [ -x /usr/local/bin/gpg ]; then
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

if [ "$OSTYPE" = "qnap" ] && [ ! -d /root/.gnupg ] && [ ! -h /root/.gnupg ]; then
	echo "applying fix for QNAP"
	mkdir -p /etc/config/.gnupg
	rm -rf /share/homes/admin/.gnupg
	ln -sf /etc/config/.gnupg /share/homes/admin/.gnupg
	ln -sf /etc/config/.gnupg /root/.gnupg
fi

keyname=$1

if [ "$keyname" = "" ]; then
	echo "usage: $0 <keyname>"
elif [ "`gpg --list-keys |grep $keyname`" = "" ]; then

	if [ ! -f /opt/farm/ext/keys/gpg/$keyname.pub ]; then
		echo "key /opt/farm/ext/keys/gpg/$keyname.pub not found"
	else
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
fi
