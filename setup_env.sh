#!/bin/bash
# Run this as root on the Server (VM3)

echo ">>> Setting up Users..."
useradd -m student
useradd -m temphttp

echo ">>> Creating Files..."
mkdir -p /srv/webfiles
echo "This is public information." > /srv/webfiles/public.txt
echo "This is TOP SECRET." > /srv/webfiles/secret.txt

echo ">>> Locking down permissions..."
chown -R root:root /srv/webfiles
chmod 700 /srv/webfiles
chmod 700 /srv/webfiles/public.txt
chmod 700 /srv/webfiles/secret.txt

echo ">>> Applying ACLs..."
# Grant read access to 'student' and 'temphttp' for the public file only
setfacl -m u:student:r /srv/webfiles/public.txt
setfacl -m u:temphttp:r /srv/webfiles/public.txt
setfacl -m u:student:x /srv/webfiles
setfacl -m u:temphttp:x /srv/webfiles

echo ">>> Setup Complete. Verifying ACLs..."
getfacl /srv/webfiles/public.txt
