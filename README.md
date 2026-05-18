# "Thing"

A standalone Spotify observer and controller for the Spotify Car Thing.
No companion app required, pair a phone over Bluetooth or plug into a PC,
scan a QR code to sign in, and see what's playing on any of your other Spotify
devices. With synced lyrics and full playback controls.

# "Thing" Setup Guide

This is beta firmware. Expect bugs, rough edges, and features that are not yet final. Please report any bugs and suggestions in the relevant Discord channels (#feedback, #suggestions). If you need help during setup, use the #setup-help Discord channel.

---

## Things to know before you proceed:
- Works ONLY with Spotify
- You will need to flash the car thing, this means that any pre-existing firmware will be wiped. Bricking is very unlikely.
- USB tethering does not work for Mac and may not work on Linux (not tested)
- Bluetooth is still in its early stages, expect bugs. Especially on Pixel, OnePlus, iPhone, etc
- Bluetooth over iPhone works but is not tested heavily (unsure how it handles reconnects etc.)
- iPhone tethering uses cellular data, never WiFi (unlike Android). Be mindful of your plan and its limits though it should not use that much data
- Bluetooth may drain battery faster on mobile devices
- Untested on free Spotify
- Physical buttons do not work yet


## Known bugs:
- You might not be able to disconnect from the car things connection or it may take a few attempts
- Lyrics and progress may not properly sync on the first few boots
- Shuffle and repeat buttons will not be reflected on the car thing if the change was made from the Spotify app
- Song timing might shift from the progress bar, should resolve itself in a few seconds or on an action event
- Occasionally a small delay when using the car thing controls to change songs
- Sometimes songs that should have lyrics may not be shown
- In some rare cases, if the car thing has been left idle for 30 minutes, it may not update any new songs or progress. The solution to this for now is to restart the car thing
- No formal way to unpair a device from the car thing, you will need to reset (this includes forgetting the device from the phone)
- If the car thing gets disconnected from Bluetooth, it may not manually reconnect and require manual action from the phone

## What you need to flash
- a pc (any platform)
- car thing
- A USB-C cable (data transfer capable)
- The flashed `thing_firmware_beta1.zip` (Download from here: https://github.com/thing-project/thing-releases/releases/tag/v0.4.0-beta1)
---

## Flashing

> Bricking is very unlikely, but flash custom firmware at your own risk. I am not responsible for any damage to your device. The Car Thing can always be recovered by re-entering flash mode.

1. **Windows only**: install the Terbium driver bundle:
   ```powershell
   irm https://driver.terbium.app/get | iex
   ```
2. Download `thing_firmware_beta1.zip` from the releases page.
3. Unzip the firmware file
4. Hold **buttons 1 + 4** on the Car Thing while plugging in the USB.
   - You will know the car thing is ready to be flashed if the screen stays black
5. Open [Terbium](https://terbium.app) and follow the instructions to get the car thing ready to flash new firmware.
6. Click on the "**Restore Local Folder**" option when shown and select the unzipped folder from step 3. 
   - Terbium may not work reliably on all browsers, if it does not try Google Chrome
7. Wait ~5-10 minutes. 
   - If you get any errors or the progress bar seems to have stopped moving for more than a few minutes start again from step 4
8. Once terbium says the flashing is complete unplug and replug the USB cable.
---

## First boot

Give the car thing ~5 minutes for the first boot.  Normal flow for a boot is:
- Orb -> blank screen -> Thing starting up -> choose a connection screen

### Method A: USB tethering (Windows only, untested on Linux)

1. Make sure the car thing is connected to a pc with a data transfer cable.
2. On the Thing, tap **Connect to PC**.
3. Setup the tethering for the carthing:

   **Windows** (PowerShell as Administrator) if this does not work try the alternative method at the bottom:
   ```powershell
   # Find your Car Thing adapter name
   Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*NDIS*"}

   # Setup the connection (replace "Ethernet 4" if your adapter has a different name)
   New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress 172.16.42.1 -PrefixLength 24 -ErrorAction SilentlyContinue
   New-NetNat -Name CarThingNAT -InternalIPInterfaceAddressPrefix 172.16.42.0/24
   ```

   **Linux** (AI generated instructions, untested on an actual machine):
      ```bash
      # Find the Car Thing interface
      ip link | grep -i "usb\|enx"

      # Setup (replace usb0 and wlan0 with your actual interface names)
      sudo ip addr add 172.16.42.1/24 dev usb0
      sudo ip link set usb0 up
      sudo sysctl -w net.ipv4.ip_forward=1
      sudo iptables -t nat -A POSTROUTING -s 172.16.42.0/24 -o wlan0 -j MASQUERADE
      ```
4. After a few seconds the Thing will show a QR code.
5. Scan the QR with your phone or open the link on a browser and sign in to Spotify.

#### Alternative Windows USB method:
1. Press Win+R, type `ncpa.cpl`, hit Enter to open Network Connections
2. Identify two adapters:
   - Your internet adapter (usually "Wi-Fi" or "Ethernet")
   - The car thing adapter (look for the one with "Remote NDIS" in the description, called "Ethernet 4" or similar)
3. Right-click your internet adapter -> Properties -> Sharing tab
4. Check "Allow other network users to connect through this computer's Internet connection"
5. In the dropdown, select the car thing adapter
6. Click OK


### Method B: Bluetooth (Should work for most users)
Note that the Bluetooth connection is required to be on at all times for the carthing to stay online, and is only tested on Android and iPhones. PC connection via Bluetooth is not tested, but may theoretically work if you can set it up.
1. **On your phone, enable Bluetooth tethering FIRST**. If you pair first then enable tethering, the Thing won't get internet and may fail to connect
   - Android: Settings -> Connections -> Mobile Hotspot and Tethering -> **Bluetooth tethering** -> ON
      - This gets reset every time you turn off Bluetooth. Re-enable it under the same Tethering menu if needed
   - iPhone: Settings -> Personal Hotspot -> **Allow Others to Join** -> ON
2. On the Thing, tap **Connect with Bluetooth**
3. The screen will show "Connect a phone", the thing is ready to pair
4. On your phone, open Bluetooth settings -> tap "Thing" in available devices.
5. Both devices show a 6-digit code -> tap confirm on your phone if the codes match.
6. After a few seconds the Thing will show a QR code.
7. Scan the QR with your phone or open the link on a browser and sign in to Spotify.
8. The "now playing" screen should now be shown (or a "Nothing playing" idle screen until you start listening to something on Spotify)

*Note: testing on iPhone was limited, you may need to enable personal hotspot each time you want to connect to the car thing* 

## After first time setup
- Boot up: Thing should auto-reconnect to the last paired phone if the setup was Bluetooth, or over the USB tether
- Start playing music on any Spotify device — the Thing displays it
- **Tap controls** for play/pause/next/prev. **Drag the progress bar** to scrub. **Tap a lyric line** to jump to that timestamp
- **Shuffle** and **repeat** are at the bottom of the controls 
- The **3-dot menu** has the "show/hide lyrics" toggle
- The **3-dot menu** has the a reset button that will reset any previous Bluetooth connections and the Spotify login credentials

*Note: testing on iPhone was limited,if you used Bluetooth over iPhone you may need to enable personal hotspot each time you want to connect to the car thing* 
---

## Troubleshooting

| Symptom | Try |
|---|---|
| Stuck on "starting up" splash for more than 60s | Unplug + replug the USB cable
| Pairing dialog never appears on the Thing | Make sure Bluetooth tethering is enabled on phone before pairing. Restart the Thing and try again |
| Phone says "Couldn't connect" but no internet on Thing either | Check that Bluetooth tethering is actually toggled ON in phone settings |
| QR code appears but never closes after sign-in | Wait ~30s. If still stuck, unplug/replug |
| Using windows tethering connection often results in connection drops or disconnect sounds | Try different cables, you may need to do the tethering command again from setup |

---

## Reporting bugs

Please include:
- What you were doing (step-by-step)
- What phone / OS version
- What you saw vs what you expected

---

## Where to get help or discuss the firmware

- **Discord**: https://discord.gg/SR2Pne7EPM
  - `#setup-help` — getting it running
  - `#feedback` — bugs, suggestions
  - `#showcase` — show off your setup
  - `#dev-chat` — discuss internals
