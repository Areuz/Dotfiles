#!/usr/bin/env bash

MONITOR="eDP-1-1";
STATUS="$(xrandr | grep "$MONITOR")";

if [ "$STATUS" == *inverted* ]; then 
      xrandr -o 0;
      xinput set-prop 'ELAN22CA:00 04F3:22CA' 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1;
else  xrandr -o 2;
      xinput set-prop 'ELAN22CA:00 04F3:22CA' 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1;
fi;
