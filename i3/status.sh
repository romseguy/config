#!/bin/bash

i3status -c ~/.config/i3/i3status.conf | while :
do
    read line
    tlp=`cat /etc/tlp.conf | grep TLP_DEFAULT_MODE`
    echo "$tlp | $line" || exit 1
done
