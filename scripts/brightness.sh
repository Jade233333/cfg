#!/bin/bash
# brightness.sh
# This script adjusts brightness using brightnessctl and shows a notification.

# Capture the current and maximum brightness values.
current=$(brightnessctl get)
max=$(brightnessctl max)

# Calculate the percentage.
perc=$(awk -v cur="$current" -v max="$max" 'BEGIN { printf "%.0f", cur/max*100 }')

case "$1" in
up)
  if [ "$perc" -le 9 ]; then
    brightnessctl set 10% >/dev/null
  else
    brightnessctl set 10%+ >/dev/null
  fi
  ;;
down)
  if [ "$perc" -le 10 ]; then
    brightnessctl set 1% >/dev/null
  else
    brightnessctl set 10%- >/dev/null
  fi
  ;;
*)
  echo "Usage: $0 {up|down}"
  exit 1
  ;;
esac

# Get the updated brightness percentage
current=$(brightnessctl get)
perc=$(awk -v cur="$current" -v max="$max" 'BEGIN { printf "%.0f", cur/max*100 }')

# Select the appropriate icon
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
