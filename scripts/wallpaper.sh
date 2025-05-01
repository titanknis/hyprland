#!/usr/bin/env bash

# Simple wallpaper switcher using swww
# Configure these settings at the top:
WALLPAPER_DIR="$HOME/Media/Pictures/Wallpapers" # Wallpaper location
INTERVAL=300                                    # Seconds between changes

# Transition settings (see 'swww img --help' for options)
TRANSITIONS=(fade left right wipe center any outer)
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=90

# Start swww daemon if not running
pgrep -x swww-daemon >/dev/null || swww-daemon

while true; do
    # Get a random wallpaper file
    wallpaper=$(find "$WALLPAPER_DIR" -type f -regex '.*\.\(jpg\|jpeg\|png\|webp\|gif\)' | shuf -n 1)

    # Check if we found any wallpapers
    if [[ -z "$wallpaper" ]]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        echo "Please add some image files (jpg, jpeg, png, webp, or gif)"
        sleep 10
        continue
    fi

    # Only change if it's a different wallpaper
    if [[ "$last_wallpaper" != "$wallpaper" ]]; then
        echo "Changing to: $wallpaper"
        swww img "$wallpaper" \
            --transition-type "${TRANSITIONS[$((RANDOM % ${#TRANSITIONS[@]}))]}" \
            --transition-angle $((RANDOM % 360))

        last_wallpaper="$wallpaper"
        sleep "$INTERVAL"
    fi
done
