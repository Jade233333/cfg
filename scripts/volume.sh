#!/bin/bash
# volume.sh
# Adjusts volume using wpctl and displays a notification with dunstify.

case "$1" in
up)
  # Increase volume by 5% (0.05 as a fraction)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ >/dev/null
  ;;
down)
  # Decrease volume by 5%
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- >/dev/null
  ;;
mute)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 0 >/dev/null
  ;;
*)
  echo "Usage: $0 {up|down|mute}"
  exit 1
  ;;
esac

# Get the current volume (fractional value, e.g. "0.70")
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | sed 's/%//')

# Convert the fractional volume to an integer percentage
vol_int=$(awk -v v="$vol" 'BEGIN { printf "%.0f", v * 100 }')

# Choose an icon based on the volume level
if [[ "$1" == "mute" ]] || wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "Mute: yes"; then
  icon="audio-volume-muted"
elif [ "$vol_int" -lt 33 ]; then
  icon="audio-volume-low"
elif [ "$vol_int" -lt 67 ]; then
  icon="audio-volume-medium"
else
  icon="audio-volume-high"
fi

notificationID=99998
# Show the notification with a progress bar
dunstify -t 1500 -r $notificationID -u low -i "$icon" -h "int:value:$vol_int" "Volume: ${vol_int}%"
