Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043Ab2HXTI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab2HXTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:08:23 -0400
Date: Fri, 24 Aug 2012 15:08:08 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: bruno@wolff.to, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120824190808.GC20043@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We've had a report[1] that the Logitech USB headset 0003:046D:0A0C isn't
working with 3.6-rc3.  It seems the last working kernel was based on
commit 10c63c9, and it first stopped working with a kernel based on
commit 23dcfa6.  There are only a few ALSA commits between those
revisions, so hopefully this is something that is fairly easy to
identify.  The only commit to USB audio in that set is:

commit e9ba389c5ffc4dd29dfe17e00e48877302111135
Author: Takashi Iwai <tiwai@suse.de>
Date:   Wed Aug 15 12:32:00 2012 +0200

    ALSA: usb-audio: Fix scheduling-while-atomic bug in PCM capture stream


I've CC'd the reporter and attached the alsa-info is below.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=851619

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.60
!!################################

!!Script ran on: Fri Aug 24 18:35:42 UTC 2012


!!Linux Distribution
!!------------------

Fedora release 18 (Rawhide) Fedora release 18 (Rawhide) NAME=Fedora ID=fedora PRETTY_NAME="Fedora 18 (Rawhide)" CPE_NAME="cpe:/o:fedoraproject:fedora:18" Fedora release 18 (Rawhide) Fedora release 18 (Rawhide)


!!DMI Information
!!---------------

Manufacturer:      Dell Inc.                
Product Name:      Precision WorkStation 690    
Product Version:   


!!Kernel Information
!!------------------

Kernel release:    3.6.0-0.rc3.git0.1.fc18.x86_64
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         x86_64
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.25
Library version:    1.0.25
Utilities version:  1.0.25


!!Loaded ALSA modules
!!-------------------

snd_hda_intel
snd_usb_audio


!!Sound Servers on this system
!!----------------------------

Pulseaudio:
      Installed - Yes (/usr/bin/pulseaudio)
      Running - Yes

aRts:
      Installed - Yes (/usr/bin/artsd)
      Running - No

Jack:
      Installed - Yes (/usr/bin/jackd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xfcffc000 irq 66
 1 [Headset        ]: USB-Audio - Logitech USB Headset
                      Logitech Logitech USB Headset at usb-0000:00:1d.7-6.4, full speed


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 631xESB/632xESB High Definition Audio Controller (rev 09)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:269a (rev 09)
	Subsystem: 1028:01c0


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
	align_buffer_size : -1
	bdl_pos_adj : 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	beep_mode : N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	patch : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	power_save : 0
	power_save_controller : Y
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	single_cmd : N
	snoop : Y

!!Module: snd_usb_audio
	async_unlink : Y
	device_setup : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	ignore_ctl_error : N
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	nrpacks : 8
	pid : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	vid : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: SigmaTel STAC9200
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x83847690
Subsystem Id: 0x102801c0
Revision Id: 0x102201
No Modem Function Group found
Default PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
GPIO: io=4, o=0, i=0, unsolicited=1, wake=1
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0xd0401: Stereo
  Device: name="STAC92xx Analog", type="Audio", device=0
  Converter: stream=8, channel=0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x03 [Audio Input] wcaps 0x1d0541: Stereo
  Device: name="STAC92xx Analog", type="Audio", device=0
  Converter: stream=4, channel=0
  SDI-Select: 0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x0a
  Processing caps: benign=0, ncoeff=0
Node 0x04 [Audio Input] wcaps 0x140311: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
  Connection: 1
     0x08
Node 0x05 [Audio Output] wcaps 0x40211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x1e0]: 44100 48000 88200 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
Node 0x06 [Vendor Defined Widget] wcaps 0xf30201: Stereo Digital
  Delay: 3 samples
Node 0x07 [Audio Selector] wcaps 0x300901: Stereo R/L
  Connection: 3
     0x02* 0x08 0x0a
Node 0x08 [Pin Complex] wcaps 0x430681: Stereo Digital
  Pincap 0x00010024: IN EAPD Detect
  EAPD 0x0:
  Pin Default 0x400001f0: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 3 samples
Node 0x09 [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x400001f1: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x1
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Connection: 2
     0x05* 0x0a
Node 0x0a [Audio Selector] wcaps 0x30090d: Stereo Amp-Out R/L
  Control: name="Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="Capture Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x0f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x07 0x07]
  Connection: 1
     0x0c
Node 0x0b [Audio Selector] wcaps 0x300105: Stereo Amp-Out
  Control: name="PCM Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="PCM Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: N/A
  Amp-Out vals:  [0x9f 0x9f]
  Connection: 1
     0x07
Node 0x0c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Mux Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 5
     0x10* 0x0f 0x0e 0x0d 0x12
Node 0x0d [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Front Headphone Jack", index=0, device=0
  Pincap 0x0000003f: IN OUT HP Detect Trigger ImpSense
  Pin Default 0x0221401f: [Jack] HP Out at Ext Front
    Conn = 1/8, Color = Green
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=01, enabled=1
  Connection: 1
     0x0b
Node 0x0e [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Line Out Jack", index=0, device=0
  Pincap 0x0000003f: IN OUT HP Detect Trigger ImpSense
  Pin Default 0x01014010: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=02, enabled=1
  Connection: 1
     0x0b
Node 0x0f [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Line Jack", index=0, device=0
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x01813020: [Jack] Line In at Ext Rear
    Conn = 1/8, Color = Blue
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x20: IN
  Unsolicited: tag=04, enabled=1
  Connection: 1
     0x0b
Node 0x10 [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Mic Jack", index=0, device=0
  Pincap 0x00001737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x02a19021: [Jack] Mic at Ext Front
    Conn = 1/8, Color = Pink
    DefAssociation = 0x2, Sequence = 0x1
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=03, enabled=1
  Connection: 1
     0x0b
Node 0x11 [Pin Complex] wcaps 0x400104: Mono Amp-Out
  Control: name="LFE Playback Volume", index=0, device=0
    ControlAmp: chs=1, dir=Out, idx=0, ofs=0
  Control: name="LFE Playback Switch", index=0, device=0
    ControlAmp: chs=1, dir=Out, idx=0, ofs=0
  Control: name="Speaker Phantom Jack", index=0, device=0
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00]
  Pincap 0x00000010: OUT
  Pin Default 0x90100140: [Fixed] Speaker at Int N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0x4, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Connection: 1
     0x13
Node 0x12 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x400001f2: [N/A] Line Out at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x2
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x13 [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x07
Node 0x14 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=1
  Amp-Out vals:  [0x00]
--endcollapse--


!!USB Mixer information
!!---------------------------
--startcollapse--

USB Mixer: usb_id=0x046d0a0c, ctrlif=0, ctlerr=0
Card: Logitech Logitech USB Headset at usb-0000:00:1d.7-6.4, full speed
  Unit: 1
    Control: name="Speaker Playback Volume", index=0
    Info: id=1, control=2, cmask=0x3, channels=2, type="S16"
    Volume: min=-10496, max=768, dBmin=-4100, dBmax=300
  Unit: 1
    Control: name="Speaker Playback Switch", index=0
    Info: id=1, control=1, cmask=0x0, channels=1, type="INV_BOOLEAN"
    Volume: min=0, max=1, dBmin=0, dBmax=0
  Unit: 2
    Control: name="Mic Capture Volume", index=0
    Info: id=2, control=2, cmask=0x0, channels=1, type="S16"
    Volume: min=4096, max=7424, dBmin=1600, dBmax=2900
  Unit: 2
    Control: name="Mic Capture Switch", index=0
    Info: id=2, control=1, cmask=0x0, channels=1, type="INV_BOOLEAN"
    Volume: min=0, max=1, dBmin=0, dBmax=0
  Unit: 6
    Control: name="Mic Playback Volume", index=0
    Info: id=6, control=2, cmask=0x0, channels=1, type="S16"
    Volume: min=-10496, max=-3072, dBmin=-4100, dBmax=-1200
  Unit: 6
    Control: name="Mic Playback Switch", index=0
    Info: id=6, control=1, cmask=0x0, channels=1, type="INV_BOOLEAN"
    Volume: min=0, max=1, dBmin=0, dBmax=0
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  8 Aug 24 12:18 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  4 Aug 24 12:18 /dev/snd/controlC1
crw-rw----+ 1 root audio 116,  7 Aug 24 12:18 /dev/snd/hwC0D0
crw-rw----+ 1 root audio 116,  6 Aug 24 12:19 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  5 Aug 24 12:19 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116,  3 Aug 24 12:19 /dev/snd/pcmC1D0c
crw-rw----+ 1 root audio 116,  2 Aug 24 12:30 /dev/snd/pcmC1D0p
crw-rw----+ 1 root audio 116,  1 Aug 24 12:18 /dev/snd/seq
crw-rw----+ 1 root audio 116, 33 Aug 24 12:18 /dev/snd/timer

/dev/snd/by-id:
total 0
drwxr-xr-x. 2 root root  60 Aug 24 12:18 .
drwxr-xr-x. 4 root root 260 Aug 24 12:18 ..
lrwxrwxrwx. 1 root root  12 Aug 24 12:18 usb-Logitech_Logitech_USB_Headset-00 -> ../controlC1

/dev/snd/by-path:
total 0
drwxr-xr-x. 2 root root  80 Aug 24 12:18 .
drwxr-xr-x. 4 root root 260 Aug 24 12:18 ..
lrwxrwxrwx. 1 root root  12 Aug 24 12:18 pci-0000:00:1b.0 -> ../controlC0
lrwxrwxrwx. 1 root root  12 Aug 24 12:18 pci-0000:00:1d.7-usb-0:6.4:1.0 -> ../controlC1


!!ALSA configuration files
!!------------------------

!!System wide config file (/etc/asound.conf)

#
# Place your global alsa-lib configuration here...
#


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: Headset [Logitech USB Headset], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: Headset [Logitech USB Headset], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xfcffc000 irq 66'
  Mixer name	: 'SigmaTel STAC9200'
  Components	: 'HDA:83847690,102801c0,00102201'
  Controls      : 15
  Simple ctrls  : 6
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 31
  Mono: Playback 31 [100%] [0.00dB] [off]
Simple mixer control 'PCM',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [0.00dB] [off]
  Front Right: Playback 31 [100%] [0.00dB] [off]
Simple mixer control 'LFE',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 31
  Mono: Playback 31 [100%] [0.00dB] [off]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 15
  Front Left: Capture 7 [47%] [10.50dB] [on]
  Front Right: Capture 7 [47%] [10.50dB] [on]
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Mic' 'Line'
  Item0: 'Mic'
Simple mixer control 'Mux',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 4
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]

!!-------Mixer controls for card 1 [Headset]

Card hw:1 'Headset'/'Logitech Logitech USB Headset at usb-0000:00:1d.7-6.4, full speed'
  Mixer name	: 'USB Mixer'
  Components	: 'USB046d:0a0c'
  Controls      : 6
  Simple ctrls  : 2
Simple mixer control 'Speaker',0
  Capabilities: pvolume pswitch pswitch-joined penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 44
  Mono:
  Front Left: Playback 35 [80%] [-6.00dB] [on]
  Front Right: Playback 35 [80%] [-6.00dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pvolume-joined cvolume cvolume-joined pswitch pswitch-joined cswitch cswitch-joined penum
  Playback channels: Mono
  Capture channels: Mono
  Limits: Playback 0 - 29 Capture 0 - 13
  Mono: Playback 0 [0%] [-41.00dB] [off] Capture 13 [100%] [29.00dB] [on]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		iface MIXER
		name 'PCM Playback Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.2 {
		iface MIXER
		name 'PCM Playback Switch'
		value.0 false
		value.1 false
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.3 {
		iface MIXER
		name 'Capture Volume'
		value.0 7
		value.1 7
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 15'
			dbmin 0
			dbmax 2250
			dbvalue.0 1050
			dbvalue.1 1050
		}
	}
	control.4 {
		iface MIXER
		name 'Capture Switch'
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
		name 'LFE Playback Volume'
		value 31
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 31'
			dbmin -4650
			dbmax 0
			dbvalue.0 0
		}
	}
	control.6 {
		iface MIXER
		name 'LFE Playback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.7 {
		iface MIXER
		name 'Mux Capture Volume'
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
	control.8 {
		iface MIXER
		name 'Input Source'
		value Mic
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Mic
			item.1 Line
		}
	}
	control.9 {
		iface MIXER
		name 'Master Playback Volume'
		value 31
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 31'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
		}
	}
	control.10 {
		iface MIXER
		name 'Master Playback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.11 {
		iface CARD
		name 'Line Out Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.12 {
		iface CARD
		name 'Front Headphone Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.13 {
		iface CARD
		name 'Speaker Phantom Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.14 {
		iface CARD
		name 'Mic Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.15 {
		iface CARD
		name 'Line Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
}
state.Headset {
	control.1 {
		iface MIXER
		name 'Mic Playback Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.2 {
		iface MIXER
		name 'Mic Playback Volume'
		value 0
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 29'
			dbmin -4100
			dbmax -1200
			dbvalue.0 -4100
		}
	}
	control.3 {
		iface MIXER
		name 'Speaker Playback Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.4 {
		iface MIXER
		name 'Speaker Playback Volume'
		value.0 35
		value.1 35
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 44'
			dbmin -4100
			dbmax 300
			dbvalue.0 -600
			dbvalue.1 -600
		}
	}
	control.5 {
		iface MIXER
		name 'Mic Capture Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.6 {
		iface MIXER
		name 'Mic Capture Volume'
		value 13
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 13'
			dbmin 1600
			dbmax 2900
			dbvalue.0 2900
		}
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
fuse
nf_conntrack_ipv4
nf_defrag_ipv4
xt_state
nf_conntrack
snd_hda_codec_idt
snd_usb_audio
snd_hda_intel
snd_usbmidi_lib
snd_hda_codec
snd_rawmidi
snd_hwdep
iTCO_wdt
iTCO_vendor_support
lpc_ich
i5000_edac
snd_seq
snd_seq_device
edac_core
snd_pcm
mfd_core
serio_raw
ppdev
snd_page_alloc
snd_timer
coretemp
snd
i5k_amb
soundcore
parport_pc
dcdbas
microcode
shpchp
parport
i2c_i801
vhost_net
tun
macvtap
macvlan
kvm_intel
kvm
uinput
binfmt_misc
xts
gf128mul
dm_crypt
raid1
radeon
i2c_algo_bit
drm_kms_helper
ttm
drm
tg3
mptsas
mptscsih
mptbase
i2c_core
scsi_transport_sas
sunrpc
be2iscsi
bnx2i
cnic
uio
cxgb4i
cxgb4
cxgb3
mdio
libcxgbi
libiscsi_tcp
qla4xxx
iscsi_boot_sysfs
libiscsi
scsi_transport_iscsi


!!Sysfs Files
!!-----------

/sys/class/sound/hwC0D0/init_pin_configs:
0x08 0x40f000f0
0x09 0x40f000f1
0x0d 0x0221101f
0x0e 0x01014010
0x0f 0x0181302e
0x10 0x02a11020
0x11 0x40f000f2
0x12 0x40f000f3

/sys/class/sound/hwC0D0/driver_pin_configs:
0x08 0x400001f0
0x09 0x400001f1
0x0d 0x0221401f
0x0e 0x01014010
0x0f 0x01813020
0x10 0x02a19021
0x11 0x90100140
0x12 0x400001f2

/sys/class/sound/hwC0D0/user_pin_configs:

/sys/class/sound/hwC0D0/init_verbs:


!!ALSA/HDA dmesg
!!------------------

[   38.190306] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[   38.229616] snd_hda_intel 0000:00:1b.0: irq 66 for MSI/MSI-X
[   38.270699] ALSA sound/usb/mixer.c:866 6:0: cannot get min/max values for control 2 (id 6)
[   38.274097] ALSA sound/usb/mixer.c:866 1:0: cannot get min/max values for control 2 (id 1)
[   38.276753] ALSA sound/usb/mixer.c:866 2:0: cannot get min/max values for control 2 (id 2)
[   38.279322] ALSA sound/pci/hda/hda_auto_parser.c:322 autoconfig: line_outs=1 (0xe/0x0/0x0/0x0/0x0) type:line
[   38.279326] ALSA sound/pci/hda/hda_auto_parser.c:326    speaker_outs=1 (0x11/0x0/0x0/0x0/0x0)
[   38.279329] ALSA sound/pci/hda/hda_auto_parser.c:330    hp_outs=1 (0xd/0x0/0x0/0x0/0x0)
[   38.279331] ALSA sound/pci/hda/hda_auto_parser.c:331    mono: mono_out=0x0
[   38.279333] ALSA sound/pci/hda/hda_auto_parser.c:335    inputs:
[   38.279336] ALSA sound/pci/hda/hda_auto_parser.c:339      Mic=0x10
[   38.279342] ALSA sound/pci/hda/hda_auto_parser.c:339      Line=0xf
[   38.285983] usbcore: registered new interface driver snd-usb-audio
[   38.290348] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   38.294975] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   38.297406] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   38.301369] input: HDA Intel Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   39.377352] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!


