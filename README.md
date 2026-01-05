# Pushbutton_Publisher

The `main` branch is now upgraded for GPIOD V2.2. If you need somethig that woirks with GPIOD V1.6 see the branch `GPIOD_V1.6`.

Stupid little Raspberry Pi program to publish state that changes with each button press.

The point is to provide an override for a motion sensitive sensor used to turn on lights after dark. Normally the lights are not durned on during daylight but some days and/or near dusk, it is desired to override this. The program will monitor a momentary pushbutton and report "on" or "off" to indicate state. When the state changes, that will be published as an MQTT message. In order to be responsive, the code will monitor the GPIO.

Home Assistant is the consumer of the messages.

## 2025-03-24 Plan

This should be relatively easily done using `gpiod` and a shell script. (See <https://github.com/HankB/GPIOD_Debian_Raspberry_Pi/tree/main/CLI> for more on that.)

The circuit used is s 6.8K ohm resistor in series with a momentary pushbutton connected to ground. The GPIO is configured with pull-up and reads high when the button is not pressed. `gpiomon` reports '2' on a transition to low and '1' on a transition to high.

 In other words:

```text
   GPIO pin
      |
     6.8K
      |
  pushbutton
      |
     GND
```

The GPIO input reads '2' when pulled low (when the button is pressed.) Let's put out a message like the following to the MQTT server.

```text
HA/zberry/office/lighting_override {"t":1742827537, "override":"on", "device":"pushbutton"}
HA/zberry/office/lighting_override {"t":1742827537, "override":"off", "device":"pushbutton"}
```

## 2025-03-24 Deploy

User `crontab` entry in `zberry` (test host)

```text
@reboot /home/hbarta/bin/pushbutton_publisher.sh >/tmp/pushbutton_publisher.txt 2&>1
```

Entry in Home Assistant configuration (`configuration.yaml`):

```text
# HA/zberry/office/lighting_override {"t":1742833594, "override":"on", "device":"pushbutton"}
# HA/zberry/office/lighting_override {"t":1742833595, "override":"off", "device":"pushbutton"}

    - name: lab_light_override
      state_topic: "HA/zberry/office/lighting_override"
      unique_id: "lab_light_override"
      value_template: "{{ value_json.override }}"
```

## 2026-01-05 Systemd Deploy

```text
# do once to install the template unit file
mkdir -p ~/.config/systemd/user/
cp pushbutton_publisher.service ~/.config/systemd/user/

mkdir -p /home/$USER/.config/pushbutton_publisher # create working dir
sudo loginctl enable-linger $USER # do once
systemctl --user daemon-reload
systemctl enable --user --now pushbutton_publisher
```

## 2025-03-24 Errata

Formatted and checked:

```text
hbarta@charon:~/Programming/Pushbutton_Publisher $ shfmt -i 4 -w pushbutton_publisher.sh 
hbarta@charon:~/Programming/Pushbutton_Publisher $ shellcheck ./pushbutton_publisher.sh 
hbarta@charon:~/Programming/Pushbutton_Publisher $ 
```