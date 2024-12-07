#!/usr/bin/env bash

dir=~/Wallpapers
interval=300
wall=""

# Start swww-daemon if not already running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
fi

while true; do
    # Get a random wallpaper file
    wallpaper=$(find "$dir" -type f -regex '.*\.\(jpg\|jpeg\|png\|webp\|gif\)' | shuf -n 1)

    # Check if we found any wallpapers
    if [ -z "$wallpaper" ]; then
        echo "No wallpapers found in $dir"
        echo "Please add some image files (jpg, jpeg, png, webp, or gif)"
        sleep "$interval"
        continue
    fi

    # Only change if it's a different wallpaper
    if [[ "$wall" != "$wallpaper" ]];then
        echo "Changing wallpaper to:$(basename "$wallpaper")"
        swww img \
            --transition-type grow \
            --transition-pos 0.854,0.977 \
            --transition-step 90 \
            "$wallpaper"

        wall="$wallpaper"
        sleep "$interval"
    fi
done

