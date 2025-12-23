#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

state="unknown"
gpio=26
broker="mqtt"
hostname=$(hostname)
topic="HA/$hostname/office/lighting_override"
state="off"

# Note: For this circuit the input reads '2' when the button is pressed, 1 when released.

while (:); do
    button=$(/usr/bin/gpiomon -b pull-up -n 1 --idle-timeout 15m -F "%e" -p 10ms -c /dev/gpiochip0 "$gpio")
    # echo "$button"
    if [ -z "$button" ]; then
        # echo timeout 
        timestamp=$(date +%s)
        message="{\"t\":$timestamp, \"override\":\"$state\", \"device\":\"pushbutton\"}"
        /usr/bin/mosquitto_pub -h "$broker" -t "$topic" -m "$message" || true
    else
        if [ "$button" == "2" ] ; then
            # echo "press detected"
            case "$state" in
            "unknown")
                state="on"
                ;;
            "off")
                state="on"
                ;;
            "on")
                state="off"
                ;;
            esac
            # echo "state $state"
            timestamp=$(date +%s)
            message="{\"t\":$timestamp, \"override\":\"$state\", \"device\":\"pushbutton\"}"
            /usr/bin/mosquitto_pub -h "$broker" -t "$topic" -m "$message" || true
        fi
    fi
done
