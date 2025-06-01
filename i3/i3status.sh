#!/bin/bash

get_tlp_status() {
  tlp=$(tlp-stat -s | grep Mode | cut -d= -f2)
  echo "$tlp"
}

i3status -c ~/.config/i3/i3status.conf | while :
do
    read line
    #block="{\"full_text\":\"\"}"
    block="{\"full_text\":\"$(get_tlp_status)\"}"
    echo "${line/\[\{/\[$block,\{}"|| exit 1
done
