#!/bin/bash
# Starts the Python web server as the user 'temphttp'
cd /srv/webfiles
sudo -u temphttp python3 -m http.server 80
