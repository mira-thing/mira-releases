# Mira

<img width="3981" height="2654" alt="hero" src="https://github.com/user-attachments/assets/47ca0b41-b19e-4323-a39c-63d380604874" />


Free, open source, standalone firmware for the discontinued Spotify Car Thing.
No companion app, no extra account, no subscription. Flash it, connect your phone
(Bluetooth) or PC (USB) for internet, sign into Spotify once, and
see and control what's playing across all your devices. 

---

## Things to know before you flash

- Works **only** with Spotify.
- Flashing wipes any existing firmware. Bricking is very unlikely, and the Car Thing can always be recovered by re-entering flash mode.
- Mira needs internet from a Bluetooth tether (phone) or a USB tether (Windows, Mac, or Linux)
- iPhone tethering uses cellular data, never Wi-Fi (unlike Android). Real-world usage is light, but be mindful of your plan.

---

## Features

- **On-device voice control** play/queue/volume/pause/resume/next/previous
- **Album art/lyrics view** with optional karaoke style word by word highlighting
- **Podcast support** with synced transcripts
- **Full physical controls** volume knob (across all devices), 4 preset buttons, back, power menu
- **Gestures** swipe to skip, two-finger swipe to switch between album art and lyrics
- **Pick which of your devices plays** right from the Car Thing
- **Save the current song to Liked Songs**
- **Pair multiple Bluetooth phones**
- **Customizable Settings** lyric-sync offset, knob volume step, brightness (auto or manual)

### Voice control

Say **"hey mira"**, then a command:

- "play **[song]**"/"play **[song]** by **[artist]**"
- "play **[artist]**" (their discography)/"play **[album]**"/"play **[playlist]**"
- "play my liked songs"/"play a random liked song"
- "queue **[song]**"/"add **[song]** to the queue"
- "pause"/"resume"/"next"/"skip"/"previous"/"go back"
- "volume up"/"volume down"

Everything runs completely on the device. No cloud, no account, no subscription.

---

## What you need to flash

- A PC (any platform)
- The Car Thing
- A **data-capable** USB-C cable
- `mira_firmware_v1.0.0.zip`, download it from the [latest release](https://github.com/mira-thing/mira-releases/releases/latest)

---

## Flashing

> Flash custom firmware at your own risk. Bricking is very unlikely, and the Car Thing can always be recovered by re-entering flash mode.

1. **Windows only**: install the Terbium driver bundle in PowerShell:
   ```powershell
   irm https://driver.terbium.app/get | iex
   ```
2. Download `mira_firmware_v1.0.0.zip` from the releases page and unzip it.
3. Hold **buttons 1 + 4** on the Car Thing while plugging in the USB cable.
   - The screen staying black means it's ready to flash.
4. Open [Terbium](https://terbium.app) and follow the prompts to prepare the device.
   - Terbium may not work reliably on all browsers, if it does not try Google Chrome
5. Choose **"Restore Local Folder"** and select the unzipped folder from step 2.
6. Wait ~5-10 minutes. If it errors or the progress bar stalls for more than a few minutes, start again from step 3.
7. When Terbium says flashing is complete, unplug and replug the USB cable.

---

## Setup

Give the Car Thing ~5 minutes on first boot, until the "choose a connection" screen appears.

### Method A: USB tethering (Windows/Mac/Linux)

1. Connect the Car Thing to your PC with a data-capable cable.
2. On the Mira, tap **Connect to PC**.
3. Set up tethering on your computer:

   **Windows (recommended path: Internet Connection Sharing via GUI):**
   > May be unreliable if you have WSL or Hyper-V enabled, use the alternative below if so.
   1. Press **Win+R**, type `ncpa.cpl`, Enter.
   2. Identify and take note of two adapters:
      - Your internet adapter (usually "Wi-Fi" or "Ethernet")
      - The Car Thing adapter (look for the one with "Remote NDIS" in the description)
   3. Right-click your **internet adapter -> Properties -> Sharing**.
   4. Check **"Allow other network users to connect through this computer's Internet connection"**, then select the Car Thing adapter in the dropdown -> **OK**.

   **Windows (alternative: some users report stutter):**
   ```powershell
   # Find your Car Thing adapter
   Get-NetAdapter | Where-Object {$_.InterfaceDescription -like "*NDIS*"}
   # Set it up (replace "Ethernet 4" with your adapter name)
   New-NetIPAddress -InterfaceAlias "Ethernet 4" -IPAddress 172.16.42.1 -PrefixLength 24 -ErrorAction SilentlyContinue
   New-NetNat -Name CarThingNAT -InternalIPInterfaceAddressPrefix 172.16.42.0/24
   ```

   **Mac:**
   1. **System Settings -> General -> Sharing**.
   2. Turn on **Internet Sharing**, share from **Wi-Fi** (or Ethernet).
   3. Under "To computers using", check the Car Thing's USB interface, then flip **Internet Sharing** on.

   **Linux:**
   ```bash
   # The Car Thing shows up as a USB Ethernet interface, its MAC starts with a0:b1:c2.
   # On Linux you may see TWO (it supports both USB-Ethernet modes); either works.
   ip -br link | grep -i a0:b1:c2

   # Option A: NetworkManager shared mode.
   # Replace enxXXXX with the Car Thing interface name from above.
   sudo nmcli connection add type ethernet ifname enxXXXX con-name carthing-shared \
     ipv4.method shared ipv6.method ignore

   # Option B: static IP. Use the interface whose MAC ends :e4:01 (the RNDIS one);
   # replace wlan0 with your internet interface.
   sudo ip addr add 172.16.42.1/24 dev enxXXXX
   sudo ip link set enxXXXX up
   sudo sysctl -w net.ipv4.ip_forward=1
   sudo iptables -t nat -A POSTROUTING -s 172.16.42.0/24 -o wlan0 -j MASQUERADE
   ```

4. After a few seconds Mira will pick up internet and show a QR code for signing in, scan it (or open the link) and sign into Spotify.

### Method B: Bluetooth

1. **Enable Bluetooth tethering on your phone FIRST**:
   - **Android:** Settings -> Connections -> Mobile Hotspot and Tethering -> **Bluetooth tethering -> ON** (resets whenever you turn Bluetooth off).
   - **iPhone:** Settings -> Personal Hotspot -> **Allow Others to Join -> ON**.
2. On Mira, tap **Connect with Bluetooth**.
3. Open Bluetooth settings on your phone and tap **Mira**.
4. Confirm on your phone and Mira that the 6 digit codes match.
5. After a few seconds Mira shows a QR code, scan it and sign into Spotify.

> If you paired on an older firmware version, remove Mira from your phone's Bluetooth list and pair again.

---

## Using Mira

- Play something on any Spotify device and Mira displays it.
- **Tap** the controls for play/pause/next/prev, **drag** the progress bar to scrub, **tap a lyric line** to jump to it.
- **Physical controls:** turn the **knob** for volume (press = play/pause), the **4 presets** jump to a saved context (press-and-hold a preset to save the current playlist/artist/podcast), **back** steps back, **power** opens the power menu (double press = sleep).
- **Gestures:** one-finger swipe left/right to skip; two-finger swipe up/down to switch album art or lyric views.
- The **3-dot menu** has the lyrics + karaoke + mic toggles, Bluetooth management, the device picker, and **Settings** (lyric offset, knob volume step, brightness).

---

## Known issues
- Waking from sleep or a long idle period can occasionally be flaky.
- On Bluetooth it may not always auto-reconnect on its own

---

## Support

Mira is free and open source. If you'd like to support development, you can do so on [GitHub Sponsors](https://github.com/sponsors/MustakimK) or [Ko-fi](https://ko-fi.com/MustakimK).

## Troubleshooting

| Symptom | Try |
|---|---|
| Stuck on "starting up" for over 60s | Unplug + replug the USB cable, or check tethering is on |
| Pairing dialog never appears | Make sure Bluetooth tethering is ON **before** pairing; restart Mira and retry |
| Phone says "Couldn't connect" and no internet on Mira | Confirm Bluetooth tethering is actually toggled ON in phone settings |
| QR appears but never closes after sign-in | Wait ~30s; if still stuck, unplug/replug |
| Windows: `New-NetNat` errors "Invalid class" | Your system likely doesn't support WinNAT out of the box, try the first method |

---

## Reporting bugs

Please include: what you were doing (step by step), Mira firmware version, your phone/OS version, and what you saw vs. what you expected.

## Help & community

- **Discord:** https://discord.gg/SR2Pne7EPM
  - `#setup-guide` - getting it running
  - `#support` - ask for help
  - `#feedback` - bugs, suggestions
  - `#showcase` - show off your setup

---
