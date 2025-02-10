#!/bin/bash
rm -f /opt/maxkb/app/tmp/*.pid

# Start MaxKB
python /opt/maxkb/app/apps/manage.py compilemessages
# start maxkb
python /opt/maxkb/app/main.py start