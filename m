Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1HDQHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:07:22 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:57528 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab1HDQHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:07:18 -0400
Message-ID: <4E3AC3B1.9030400@lwfinger.net>
Date: Thu, 04 Aug 2011 11:07:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression in 3.0-git after commit c82693db52beced0419cecf09a3c81adfe95a544
 - sound does not work
References: <4E39C074.10007@lwfinger.net> <s5h7h6trc0x.wl%tiwai@suse.de>
In-Reply-To: <s5h7h6trc0x.wl%tiwai@suse.de>
Content-Type: multipart/mixed;
 boundary="------------020102090209030503080600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020102090209030503080600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/04/2011 12:17 AM, Takashi Iwai wrote:
>
> And reverting the above fixes your problem, right?
> Then please give alsa-info.sh outputs on both working and non-working
> kernels (run with --no-upload option).

Yes, reverting that one hunk fixes my problem.

The alsa-info.sh outputs for the working and nonworking cases are attached.

Thanks,

Larry

--------------020102090209030503080600
Content-Type: text/plain;
 name="alsa-info-nonworking.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-info-nonworking.txt"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.58
!!################################

!!Script ran on: Thu Aug  4 16:03:16 UTC 2011


!!Linux Distribution
!!------------------

Welcome to openSUSE 11.4 "Celadon" - Kernel \r (\l). openSUSE 11.4 (x86_64)


!!DMI Information
!!---------------

Manufacturer:      Hewlett-Packard
Product Name:      HP Pavilion dv2700 Notebook PC


!!Kernel Information
!!------------------

Kernel release:    3.0.0-Linus+
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         x86_64
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.24
Library version:    1.0.24.1
Utilities version:  1.0.24.2


!!Loaded ALSA modules
!!-------------------

snd_hda_intel


!!Sound Servers on this system
!!----------------------------

Pulseaudio:
      Installed - Yes (/usr/bin/pulseaudio)
      Running - No

ESound Daemon:
      Installed - Yes (/usr/bin/esd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [NVidia         ]: HDA-Intel - HDA NVidia
                      HDA NVidia at 0xfc380000 irq 21


!!PCI Soundcards installed in the system
!!--------------------------------------

00:07.0 Audio device: nVidia Corporation MCP67 High Definition Audio (rev a1)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:07.0 0403: 10de:055c (rev a1)
	Subsystem: 103c:30d6


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
	bdl_pos_adj : 32,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	single_cmd : N


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Conexant CX20561 (Hermosa)
Address: 0
AFG Function Id: 0x1 (unsol 1)
MFG Function Id: 0x2 (unsol 1)
Vendor Id: 0x14f15051
Subsystem Id: 0x103c30d6
Revision Id: 0x100000
Modem Function Group: 0x2
Default PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x10 [Audio Output] wcaps 0xc1d: Stereo Amp-Out R/L
  Control: name="Speaker Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Device: name="CONEXANT Analog", type="Audio", device=0
  Amp-Out caps: ofs=0x4a, nsteps=0x4a, stepsize=0x03, mute=0
  Amp-Out vals:  [0x00 0x00]
  Converter: stream=5, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x11 [Audio Output] wcaps 0xc1d: Stereo Amp-Out R/L
  Control: name="Headphone Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x4a, nsteps=0x4a, stepsize=0x03, mute=0
  Amp-Out vals:  [0x00 0x00]
  Converter: stream=5, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x12 [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
Node 0x13 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=0
  Amp-Out vals:  [0x00]
Node 0x14 [Audio Input] wcaps 0x100d1b: Stereo Amp-In R/L
  Control: name="Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Device: name="CONEXANT Analog", type="Audio", device=0
  Amp-In caps: ofs=0x4a, nsteps=0x50, stepsize=0x03, mute=0
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x1d 0x17*
Node 0x15 [Audio Input] wcaps 0x100d1b: Stereo Amp-In R/L
  Amp-In caps: ofs=0x4a, nsteps=0x50, stepsize=0x03, mute=0
  Amp-In vals:  [0x00 0x00]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x18
Node 0x16 [Pin Complex] wcaps 0x400581: Stereo
  Pincap 0x0000001c: OUT HP Detect
  Pin Default 0x01214030: [Jack] HP Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=37, enabled=1
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x10 0x11*
Node 0x17 [Pin Complex] wcaps 0x40048b: Stereo Amp-In
  Control: name="Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x00001224: IN Detect
    Vref caps: 50 80
  Pin Default 0x01a19020: [Jack] Mic at Ext Rear
    Conn = 1/8, Color = Pink
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x18 [Pin Complex] wcaps 0x40048b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x00001224: IN Detect
    Vref caps: 50 80
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00: VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x19 [Pin Complex] wcaps 0x400581: Stereo
  Pincap 0x00000014: OUT Detect
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x10 0x11*
Node 0x1a [Pin Complex] wcaps 0x400501: Stereo
  Pincap 0x00010010: OUT EAPD
  EAPD 0x2: EAPD
  Pin Default 0x92170110: [Fixed] Speaker at Int Front
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x10* 0x11
Node 0x1b [Pin Complex] wcaps 0x400500: Mono
  Pincap 0x00010010: OUT EAPD
  EAPD 0x2: EAPD
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x10* 0x11
Node 0x1c [Pin Complex] wcaps 0x400701: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x12
Node 0x1d [Pin Complex] wcaps 0x40040b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x00000020: IN
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x1e [Vendor Defined Widget] wcaps 0xf00000: Mono
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  4 Aug  4 10:56 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  3 Aug  4 10:56 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  2 Aug  4 10:57 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116,  1 Aug  4 10:57 /dev/snd/seq
crw-rw----+ 1 root audio 116, 33 Aug  4 10:56 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Aug  4 10:56 .
drwxr-xr-x 3 root root 160 Aug  4 10:56 ..
lrwxrwxrwx 1 root root  12 Aug  4 10:56 pci-0000:00:07.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: NVidia [HDA NVidia], device 0: CONEXANT Analog [CONEXANT Analog]
  Subdevices: 0/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: NVidia [HDA NVidia], device 0: CONEXANT Analog [CONEXANT Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [NVidia]

Card hw:0 'NVidia'/'HDA NVidia at 0xfc380000 irq 21'
  Mixer name	: 'Conexant CX20561 (Hermosa)'
  Components	: 'HDA:14f15051,103c30d6,00100000'
  Controls      : 8
  Simple ctrls  : 8
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 74
  Mono: Playback 57 [77%] [-17.00dB]
Simple mixer control 'Headphone',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 74
  Mono:
  Front Left: Playback 0 [0%] [-74.00dB]
  Front Right: Playback 0 [0%] [-74.00dB]
Simple mixer control 'Speaker',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 74
  Mono:
  Front Left: Playback 0 [0%] [-74.00dB]
  Front Right: Playback 0 [0%] [-74.00dB]
Simple mixer control 'PCM',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 252 [99%] [0.60dB]
  Front Right: Playback 252 [99%] [0.60dB]
Simple mixer control 'Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 4
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]
Simple mixer control 'Capture',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 80
  Front Left: Capture 0 [0%] [-74.00dB]
  Front Right: Capture 0 [0%] [-74.00dB]
Simple mixer control 'Auto-Mute Mode',0
  Capabilities: enum
  Items: 'Disabled' 'Enabled'
  Item0: 'Enabled'
Simple mixer control 'Digital',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 60 [50%] [0.00dB]
  Front Right: Capture 60 [50%] [0.00dB]


!!Alsactl output
!!-------------

--startcollapse--
state.NVidia {
	control.1 {
		iface MIXER
		name 'Speaker Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 74'
			dbmin -7400
			dbmax 0
			dbvalue.0 -7400
			dbvalue.1 -7400
		}
	}
	control.2 {
		iface MIXER
		name 'Headphone Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 74'
			dbmin -7400
			dbmax 0
			dbvalue.0 -7400
			dbvalue.1 -7400
		}
	}
	control.3 {
		iface MIXER
		name 'Auto-Mute Mode'
		value Enabled
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Disabled
			item.1 Enabled
		}
	}
	control.4 {
		iface MIXER
		name 'Mic Boost Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 4'
			dbmin 0
			dbmax 4000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.5 {
		iface MIXER
		name 'Capture Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 80'
			dbmin -7400
			dbmax 600
			dbvalue.0 -7400
			dbvalue.1 -7400
		}
	}
	control.6 {
		iface MIXER
		name 'Master Playback Volume'
		value 57
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 74'
			dbmin -7400
			dbmax 0
			dbvalue.0 -1700
		}
	}
	control.7 {
		iface MIXER
		name 'PCM Playback Volume'
		value.0 252
		value.1 252
		comment {
			access 'read write user'
			type INTEGER
			count 2
			range '0 - 255'
			tlv '0000000100000008ffffec1400000014'
			dbmin -5100
			dbmax 0
			dbvalue.0 -60
			dbvalue.1 -60
		}
	}
	control.8 {
		iface MIXER
		name 'Digital Capture Volume'
		value.0 60
		value.1 60
		comment {
			access 'read write user'
			type INTEGER
			count 2
			range '0 - 120'
			tlv '0000000100000008fffff44800000032'
			dbmin -3000
			dbmax 3000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
fuse
af_packet
snd_pcm_oss
snd_mixer_oss
snd_seq
snd_seq_device
edd
nouveau
ttm
drm_kms_helper
drm
i2c_algo_bit
mxm_wmi
nfs
lockd
auth_rpcgss
nfs_acl
sunrpc
cpufreq_conservative
cpufreq_userspace
cpufreq_powersave
powernow_k8
mperf
ext4
jbd2
crc16
dm_mod
ide_cd_mod
cdrom
snd_hda_codec_conexant
r8712u
ide_pci_generic
snd_hda_intel
snd_hda_codec
snd_pcm
snd_timer
serio_raw
snd
joydev
k8temp
forcedeth
hwmon
amd74xx
ide_core
i2c_nforce2
sg
soundcore
snd_page_alloc
i2c_core
wmi
battery
ac
button
ext3
jbd
mbcache
sd_mod
ohci_hcd
ahci
libahci
libata
scsi_mod
ehci_hcd
usbcore
fan
processor
thermal


!!ALSA/HDA dmesg
!!------------------

[   12.649364] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[   12.649397] snd_hda_intel 0000:00:07.0: PCI INT A -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
[   12.649409] hda_intel: Disabling MSI
[   12.649668] snd_hda_intel 0000:00:07.0: setting latency timer to 64
[   13.030379] r8712u: CustomerID = 0x0006
--
[   13.033712] usbcore: registered new interface driver r8712u
[   13.050108] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
[   13.104920] udev[1497]: renamed network interface wlan0 to wlan9
--
[   40.303426] start_kdeinit (3668): /proc/3668/oom_adj is deprecated, please use /proc/3668/oom_score_adj instead.
[   40.303433] Modules linked in: af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nouveau ttm drm_kms_helper drm i2c_algo_bit mxm_wmi nfs lockd auth_rpcgss nfs_acl sunrpc cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 mperf ext4 jbd2 crc16 dm_mod ide_cd_mod cdrom snd_hda_codec_conexant r8712u(C) ide_pci_generic snd_hda_intel snd_hda_codec snd_pcm snd_timer serio_raw snd joydev k8temp forcedeth hwmon amd74xx ide_core i2c_nforce2 sg soundcore snd_page_alloc i2c_core wmi battery ac button ext3 jbd mbcache sd_mod ohci_hcd ahci libahci libata scsi_mod ehci_hcd usbcore fan processor thermal
[   40.303612] Pid: 3668, comm: start_kdeinit Tainted: G         C  3.0.0-Linus+ #95



--------------020102090209030503080600
Content-Type: text/plain;
 name="alsa-info-working.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-info-working.txt"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.58
!!################################

!!Script ran on: Thu Aug  4 15:14:11 UTC 2011


!!Linux Distribution
!!------------------

Welcome to openSUSE 11.4 "Celadon" - Kernel \r (\l). openSUSE 11.4 (x86_64)


!!DMI Information
!!---------------

Manufacturer:      Hewlett-Packard
Product Name:      HP Pavilion dv2700 Notebook PC


!!Kernel Information
!!------------------

Kernel release:    3.0.0-Linus+
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         x86_64
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.24
Library version:    1.0.24.1
Utilities version:  1.0.24.2


!!Loaded ALSA modules
!!-------------------

snd_hda_intel


!!Sound Servers on this system
!!----------------------------

Pulseaudio:
      Installed - Yes (/usr/bin/pulseaudio)
      Running - No

ESound Daemon:
      Installed - Yes (/usr/bin/esd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [NVidia         ]: HDA-Intel - HDA NVidia
                      HDA NVidia at 0xfc380000 irq 21


!!PCI Soundcards installed in the system
!!--------------------------------------

00:07.0 Audio device: nVidia Corporation MCP67 High Definition Audio (rev a1)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:07.0 0403: 10de:055c (rev a1)
	Subsystem: 103c:30d6


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
	bdl_pos_adj : 32,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	single_cmd : N


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Conexant CX20561 (Hermosa)
Address: 0
AFG Function Id: 0x1 (unsol 1)
MFG Function Id: 0x2 (unsol 1)
Vendor Id: 0x14f15051
Subsystem Id: 0x103c30d6
Revision Id: 0x100000
Modem Function Group: 0x2
Default PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x10 [Audio Output] wcaps 0xc1d: Stereo Amp-Out R/L
  Control: name="Master Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Device: name="CONEXANT Analog", type="Audio", device=0
  Amp-Out caps: ofs=0x4a, nsteps=0x4a, stepsize=0x03, mute=0
  Amp-Out vals:  [0x39 0x39]
  Converter: stream=5, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x11 [Audio Output] wcaps 0xc1d: Stereo Amp-Out R/L
  Amp-Out caps: ofs=0x4a, nsteps=0x4a, stepsize=0x03, mute=0
  Amp-Out vals:  [0x4a 0x4a]
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x12 [Audio Output] wcaps 0x211: Stereo Digital
  Control: name="IEC958 Playback Con Mask", index=0, device=0
  Control: name="IEC958 Playback Pro Mask", index=0, device=0
  Control: name="IEC958 Playback Default", index=0, device=0
  Control: name="IEC958 Playback Switch", index=0, device=0
  Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
  Device: name="Conexant Digital", type="SPDIF", device=1
  Converter: stream=5, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
Node 0x13 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=0
  Amp-Out vals:  [0x00]
Node 0x14 [Audio Input] wcaps 0x100d1b: Stereo Amp-In R/L
  Control: name="Internal Mic Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Internal Mic Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Mic Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Mic Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Device: name="CONEXANT Analog", type="Audio", device=0
  Amp-In caps: ofs=0x4a, nsteps=0x50, stepsize=0x03, mute=0
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x1d 0x17*
Node 0x15 [Audio Input] wcaps 0x100d1b: Stereo Amp-In R/L
  Control: name="Docking Mic Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Docking Mic Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x4a, nsteps=0x50, stepsize=0x03, mute=0
  Amp-In vals:  [0x44 0x44]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x18
Node 0x16 [Pin Complex] wcaps 0x400581: Stereo
  Pincap 0x0000001c: OUT HP Detect
  Pin Default 0x01214030: [Jack] HP Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x00:
  Unsolicited: tag=37, enabled=1
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x10* 0x11
Node 0x17 [Pin Complex] wcaps 0x40048b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Pincap 0x00001224: IN Detect
    Vref caps: 50 80
  Pin Default 0x01a19020: [Jack] Mic at Ext Rear
    Conn = 1/8, Color = Pink
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=38, enabled=1
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x18 [Pin Complex] wcaps 0x40048b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Pincap 0x00001224: IN Detect
    Vref caps: 50 80
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=39, enabled=1
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x19 [Pin Complex] wcaps 0x400581: Stereo
  Pincap 0x00000014: OUT Detect
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x10 0x11*
Node 0x1a [Pin Complex] wcaps 0x400501: Stereo
  Pincap 0x00010010: OUT EAPD
  EAPD 0x2: EAPD
  Pin Default 0x92170110: [Fixed] Speaker at Int Front
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x10* 0x11
Node 0x1b [Pin Complex] wcaps 0x400500: Mono
  Pincap 0x00010010: OUT EAPD
  EAPD 0x2: EAPD
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x10* 0x11
Node 0x1c [Pin Complex] wcaps 0x400701: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x12
Node 0x1d [Pin Complex] wcaps 0x40040b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Pincap 0x00000020: IN
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
Node 0x1e [Vendor Defined Widget] wcaps 0xf00000: Mono
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  5 Aug  4 10:12 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  4 Aug  4 10:12 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  3 Aug  4 10:14 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116,  2 Aug  4 10:12 /dev/snd/pcmC0D1p
crw-rw----+ 1 root audio 116,  1 Aug  4 10:13 /dev/snd/seq
crw-rw----+ 1 root audio 116, 33 Aug  4 10:12 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Aug  4 10:12 .
drwxr-xr-x 3 root root 180 Aug  4 10:12 ..
lrwxrwxrwx 1 root root  12 Aug  4 10:12 pci-0000:00:07.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: NVidia [HDA NVidia], device 0: CONEXANT Analog [CONEXANT Analog]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 0: NVidia [HDA NVidia], device 1: Conexant Digital [Conexant Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: NVidia [HDA NVidia], device 0: CONEXANT Analog [CONEXANT Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [NVidia]

Card hw:0 'NVidia'/'HDA NVidia at 0xfc380000 irq 21'
  Mixer name	: 'Conexant CX20561 (Hermosa)'
  Components	: 'HDA:14f15051,103c30d6,00100000'
  Controls      : 15
  Simple ctrls  : 8
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch pswitch-joined penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 74
  Mono:
  Front Left: Playback 57 [77%] [-17.00dB] [on]
  Front Right: Playback 57 [77%] [-17.00dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 252 [99%] [0.60dB]
  Front Right: Playback 252 [99%] [0.60dB]
Simple mixer control 'Mic',0
  Capabilities: volume pswitch penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 80
  Front Left: 0 [0%] [-74.00dB] Playback [on]
  Front Right: 0 [0%] [-74.00dB] Playback [on]
Simple mixer control 'IEC958',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'IEC958 Default PCM',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'Digital',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 60 [50%] [0.00dB]
  Front Right: Capture 60 [50%] [0.00dB]
Simple mixer control 'Docking Mic',0
  Capabilities: volume pswitch penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 80
  Front Left: 68 [85%] [-6.00dB] Playback [on]
  Front Right: 68 [85%] [-6.00dB] Playback [on]
Simple mixer control 'Internal Mic',0
  Capabilities: volume pswitch penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 80
  Front Left: 0 [0%] [-74.00dB] Playback [on]
  Front Right: 0 [0%] [-74.00dB] Playback [on]


!!Alsactl output
!!-------------

--startcollapse--
state.NVidia {
	control.1 {
		iface MIXER
		name 'Internal Mic Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 80'
			dbmin -7400
			dbmax 600
			dbvalue.0 -7400
			dbvalue.1 -7400
		}
	}
	control.2 {
		iface MIXER
		name 'Internal Mic Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.3 {
		iface MIXER
		name 'Mic Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 80'
			dbmin -7400
			dbmax 600
			dbvalue.0 -7400
			dbvalue.1 -7400
		}
	}
	control.4 {
		iface MIXER
		name 'Mic Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.5 {
		iface MIXER
		name 'Docking Mic Volume'
		value.0 68
		value.1 68
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 80'
			dbmin -7400
			dbmax 600
			dbvalue.0 -600
			dbvalue.1 -600
		}
	}
	control.6 {
		iface MIXER
		name 'Docking Mic Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.7 {
		iface MIXER
		name 'Master Playback Volume'
		value.0 57
		value.1 57
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 74'
			dbmin -7400
			dbmax 0
			dbvalue.0 -1700
			dbvalue.1 -1700
		}
	}
	control.8 {
		iface MIXER
		name 'Master Playback Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.9 {
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
		comment {
			access read
			type IEC958
			count 1
		}
	}
	control.10 {
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
		comment {
			access read
			type IEC958
			count 1
		}
	}
	control.11 {
		iface MIXER
		name 'IEC958 Playback Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
		comment {
			access 'read write'
			type IEC958
			count 1
		}
	}
	control.12 {
		iface MIXER
		name 'IEC958 Playback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.13 {
		iface MIXER
		name 'IEC958 Default PCM Playback Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.14 {
		iface MIXER
		name 'PCM Playback Volume'
		value.0 252
		value.1 252
		comment {
			access 'read write user'
			type INTEGER
			count 2
			range '0 - 255'
			tlv '0000000100000008ffffec1400000014'
			dbmin -5100
			dbmax 0
			dbvalue.0 -60
			dbvalue.1 -60
		}
	}
	control.15 {
		iface MIXER
		name 'Digital Capture Volume'
		value.0 60
		value.1 60
		comment {
			access 'read write user'
			type INTEGER
			count 2
			range '0 - 120'
			tlv '0000000100000008fffff44800000032'
			dbmin -3000
			dbmax 3000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
fuse
af_packet
snd_pcm_oss
snd_mixer_oss
snd_seq
snd_seq_device
edd
nouveau
ttm
drm_kms_helper
drm
i2c_algo_bit
mxm_wmi
nfs
lockd
auth_rpcgss
nfs_acl
sunrpc
cpufreq_conservative
cpufreq_userspace
cpufreq_powersave
powernow_k8
mperf
ext4
jbd2
crc16
dm_mod
ide_cd_mod
cdrom
snd_hda_codec_conexant
ide_pci_generic
r8712u
snd_hda_intel
snd_hda_codec
snd_pcm
snd_timer
snd
amd74xx
joydev
ide_core
sg
k8temp
wmi
serio_raw
i2c_nforce2
soundcore
forcedeth
hwmon
snd_page_alloc
i2c_core
battery
ac
button
ext3
jbd
mbcache
sd_mod
ohci_hcd
ahci
libahci
libata
scsi_mod
ehci_hcd
usbcore
fan
processor
thermal


!!ALSA/HDA dmesg
!!------------------

[   12.529408] Hardware name: HP Pavilion dv2700 Notebook PC
[   12.529497] Modules linked in: snd_hda_intel(+) snd_hda_codec snd_pcm snd_timer snd amd74xx(+) joydev ide_core sg k8temp wmi serio_raw i2c_nforce2 soundcore forcedeth hwmon snd_page_alloc i2c_core battery ac button ext3 jbd mbcache sd_mod ohci_hcd ahci libahci libata scsi_mod ehci_hcd usbcore fan processor thermal
[   12.530118] Pid: 2209, comm: work_for_cpu Not tainted 3.0.0-Linus+ #85
--
[   12.630999] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[   12.635947] snd_hda_intel 0000:00:07.0: PCI INT A -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
[   12.639611] hda_intel: Disabling MSI
[   12.643370] snd_hda_intel 0000:00:07.0: setting latency timer to 64
[   12.818039] r8712u: module is from the staging directory, the quality is unknown, you have been warned.
--
[   39.701715] start_kdeinit (3690): /proc/3690/oom_adj is deprecated, please use /proc/3690/oom_score_adj instead.
[   39.701722] Modules linked in: af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nouveau ttm drm_kms_helper drm i2c_algo_bit mxm_wmi nfs lockd auth_rpcgss nfs_acl sunrpc cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 mperf ext4 jbd2 crc16 dm_mod ide_cd_mod cdrom snd_hda_codec_conexant ide_pci_generic r8712u(C) snd_hda_intel snd_hda_codec snd_pcm snd_timer snd amd74xx joydev ide_core sg k8temp wmi serio_raw i2c_nforce2 soundcore forcedeth hwmon snd_page_alloc i2c_core battery ac button ext3 jbd mbcache sd_mod ohci_hcd ahci libahci libata scsi_mod ehci_hcd usbcore fan processor thermal
[   39.701919] Pid: 3690, comm: start_kdeinit Tainted: G        WC  3.0.0-Linus+ #85



--------------020102090209030503080600--
