## How to build this project

### On a Mac

Create Dockerfile

Now build with:

```docker build --output=./out .```

This will:

1. Start from the .NET 9.0 SDK image
2. Install clang and zlib1g-dev (required for Native AOT)
3. Build the project
4. Export just the compiled output to ./out/ on your Mac

The binary will be at ./out/rt4k_pi ready to copy to your Pi.

Alternative one-liner (if you prefer not to use a Dockerfile):

```
docker run --rm -v "$(pwd):/src" -w /src mcr.microsoft.com/dotnet/sdk:9.0
  sh -c "apt-get update && apt-get install -y clang zlib1g-dev && dotnet publish rt4k_pi.csproj -c Release -r linux-arm64 -o /src/out"
```

This is slower since it installs dependencies every time, but works without creating files.

## Deploy binary to Pi

Copy the binary to the Pi using SCP:

```bash
scp out/rt4k_pi pi@rt4k.local:/home/pi/
```

## Run binary on Pi (First Time)

On first run, execute manually with sudo. It will install itself as a systemd service:

```bash
sudo ./rt4k_pi
```

## Managing the Service

Once installed, the service runs automatically on boot. Use these commands to manage it:

| Command | Action |
|---------|--------|
| `sudo systemctl stop rt4k` | Stop the service |
| `sudo systemctl start rt4k` | Start the service |
| `sudo systemctl restart rt4k` | Restart the service |
| `sudo systemctl status rt4k` | Check service status |
| `sudo journalctl -u rt4k -f` | View live logs |

## Redeploying Updates

To deploy a new binary:

```bash
# One-liner: stop, copy, start
ssh pi@rt4k.local "sudo systemctl stop rt4k" && scp out/rt4k_pi pi@rt4k.local:/home/pi/ && ssh pi@rt4k.local "sudo systemctl start rt4k"
```

Or step by step:

```bash
ssh pi@rt4k.local "sudo systemctl stop rt4k"
scp out/rt4k_pi pi@rt4k.local:/home/pi/
ssh pi@rt4k.local "sudo systemctl start rt4k"
```

## Usage

### Accessing Web UI

Web UI: http://rt4k.local or http://<pi-ip-address>


### Samba Share 

SMB Share: \\rt4k.local\sd from Windows

Not sure what th epoint of this is yet...

### Serial Bridge

Serial Bridge: TCP port 2000


## RetroTink4K Remote

Remote Control Commands
Remote Control Emulation Over Serial Commands List
Note that commands must terminate with \r or \n or a combination of both (simulating a carriage return or new line terminal command).
Remote buttons, add remote prefix before command.
Example: the command remote menu\n simulates a menu press on the remote.
Command:	Description:
pwr	        BUTTON PWR
menu	    BUTTON MENU
up	BUTTON UP
down	BUTTON DOWN
left	BUTTON LEFT
right	BUTTON RIGHT
ok	BUTTON OK
back	BUTTON BACK
diag	BUTTON DIAG
stat	BUTTON STAT
input	BUTTON INPUT
output	BUTTON OUTPUT
scaler	BUTTON SCALER
sfx	BUTTON SFX
adc	BUTTON ADC
col	BUTTON COL
aud	BUTTON AUD
prof	BUTTON PROF
prof1	BUTTON 1
prof2	BUTTON 2
prof3	BUTTON 3
prof4	BUTTON 4
prof5	BUTTON 5
prof6	BUTTON 6
prof7	BUTTON 7
prof8	BUTTON 8
prof9	BUTTON 9
prof10	BUTTON 10
prof11	BUTTON 11
prof12	BUTTON 12
gain	BUTTON GAIN
phase	BUTTON PHASE
pause	BUTTON PAUSE
safe	BUTTON SAFE
genlock	BUTTON GENLOCK
buffer	BUTTON BUFFER
res4k	BUTTON 4K
res1080p	BUTTON 1080P
res1440p	BUTTON 1440P
res480p	BUTTON 480P
res1	BUTTON RES1
res2	BUTTON RES2
res3	BUTTON RES3
res4	BUTTON RES4
aux1	BUTTON AUX1
aux2	BUTTON AUX2
aux3	BUTTON AUX3
aux4	BUTTON AUX4
aux5	BUTTON AUX5
aux6	BUTTON AUX6
aux7	BUTTON AUX7
aux8	BUTTON AUX8
Power on command while sleeping. All other commands do nothing (no "remote" prefix)
pwr on	TURNS RT4K ON IF IT IS OFF


## Home Assistant

edit our config/confiuration.yml file to include the following:

```
rest_command:
  rt4k_command:
    url: "http://rt4k.local/RemoteCommand/{{ command }}"
    method: POST
  # res1080p:
  #   url: "http://rt4k.local/RemoteCommand/res1080p"
  #   method: POST
```