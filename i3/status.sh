#!/bin/bash

get_pomo_status() {
  layout=$(i3-gnome-pomodoro status)
  echo "$layout"
}

i3status -c ~/.config/i3/i3status.conf | while :
do
    read line
    block="{\"full_text\":\"$(get_pomo_status)\"}"
    echo "${line/\[\{/\[$block,\{}"|| exit 1
done
