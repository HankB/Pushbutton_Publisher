#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

state="unknown"
gpio=20
was_pressed="false"

# Note: For this circuit the input reads '0' when the button is pressed

while (:); do
    button=$(gpioget -l /dev/gpiochip0 "$gpio")
    # echo "$button"
    if [ "$button" == "0" ] && [ "$was_pressed" == "false" ]; then
        # echo "press detected"
        was_pressed="true"
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
        echo "state $state"
        
    elif [ "$button" == "1" ]; then
        was_pressed="false"
        # echo "press off"
    fi
    sleep 0.1 # bash can sleep for fracti0onal seconds! Who knew?
done
