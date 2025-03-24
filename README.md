# Pushbutton_Publisher

Stupid little Raspberry Pi program to publish state that changes with each button press.

The point is to provide an override for a motion sensitive sensor used to turn on lights after dark. Normally the lights are not durned on during daylight but some days and/or near dusk, it is desired to override this. The program will monitor a momentary pushbutton and report "on" or "off" to indicate state. When the state changes, that will be published as an MQTT message. In order to be responsive, the code will monitor the GPIO.

Home Assistant is the consumer of the messages.

## 2025-03-24 Plan

This should be relatively easily done using `gpiod` and a shell script. (See <https://github.com/HankB/GPIOD_Debian_Raspberry_Pi/tree/main/CLI> for more on that.)

The circuit used is s 6.8K ohm resistor in series with a momentary pushbutton all connected bewtween 3V3 and ground. In other words:

```text
     3V3
      |
     6.8K
      |
  pushbutton
      |
     GND
```

The GPIO input reads '0' when pulled high (when the button is pressed.) Let's put out a message like the following to the MQTT server.

```text
HA/zberry/office/lighting_override {"t":1742827537, "override":"on", "device":"pushbutton"}
HA/zberry/office/lighting_override {"t":1742827537, "override":"off", "device":"pushbutton"}
```

## 2025-03-24 Errata

Formatted and checked:

```text
hbarta@charon:~/Programming/Pushbutton_Publisher $ shfmt -i 4 -w pushbutton_publisher.sh 
hbarta@charon:~/Programming/Pushbutton_Publisher $ shellcheck ./pushbutton_publisher.sh 
hbarta@charon:~/Programming/Pushbutton_Publisher $ 
```