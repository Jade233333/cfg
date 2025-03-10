#!/bin/bash
# brightness.sh
# This script adjusts brightness using brightnessctl and shows a notification.

case "$1" in
up)
  brightnessctl set +10% >/dev/null
  ;;
down)
  brightnessctl set 10%- >/dev/null
  ;;
*)
  echo "Usage: $0 {up|down}"
  exit 1
  ;;
esac

# Capture the current and maximum brightness values.
current=$(brightnessctl get | awk '{print $1}')
max=$(brightnessctl max | awk '{print $1}')

# Calculate the percentage.
perc=$(awk -v cur="$current" -v max="$max" 'BEGIN { printf "%.0f", cur/max*100 }')

if [ "$perc" -lt 33 ]; then
  icon="brightness-low-symbolic"
elif [ "$perc" -lt 67 ]; then
  icon="brightness-medium-symbolic"
else
  icon="brightness-high-symbolic"
fi

notificationID=99999
# Send a notification using dunstify with the correct hint format.
dunstify -t 1500 -r $notificationID -u low -i "$icon" -h "int:value:$perc" "Brightness: ${perc}%"
