#!/bin/bash
rm -f /opt/maxkb/app/tmp/*.pid

# start maxkb
python /opt/maxkb/app/main.py start