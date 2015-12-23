sf-gpg extension provides backup encryption ability for Server Farmer backup
scripts. If is compatible with all operating systems supported by Server Farmer.

**How to add your own GPG key?**

Previously, when GPG functionality was in the core Server Farmer repository, it
was enough just to fork it and replace the original key with yours one.

Currently you have to fork Server Farmer repository and replace the key name in
/opt/farm/scripts/functions.custom file just like before, but it's not enough.
You have 2 options:

- fork all extensions that you plan to use and change extension_repository
address to point to your Github account (harder)
- fork this repository, add your key and create pull request (quick and simple)

**All pull requests following the convention will be accepted - with:**

- valid ssh keys (importable by GnuPG 1.4.x, unencrypted)
- valid email addresses (syntax, existing domain)
- valid file names (<email>.pub)
- unix-like line endings
- no other changes
