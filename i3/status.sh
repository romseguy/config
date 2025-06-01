#!/bin/bash

get_pomo_status() {
  layout=$(i3-gnome-pomodoro status)
  echo "$layout"
}

get_tlp_status() {
  layout2=$(tlp-stat -s | grep Mode | cut -d= -f2)
  echo "$layout2"
}

i3status -c ~/.config/i3/i3status.conf | while :
do
    read line
    block="{\"full_text\":\"$(get_pomo_status)\"}"
    block2="{\"full_text\":\"$(get_tlp_status)\"}"
    echo "${line/\[\{/\[$block,\{}" || exit 1
done
