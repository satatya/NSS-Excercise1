#!/bin/sh
echo "Current User ID:"
/usr/bin/id
echo "Attempting to read secret..."
cat /srv/webfiles/secret.txt
