#!/usr/bin/env bash
# Wallpaper
swww init &
swww img ~/.config/wallpaper.jpg &

# Bar
waybar &

# Notifications
mako

# Network applet
nm-applet --indicator &
