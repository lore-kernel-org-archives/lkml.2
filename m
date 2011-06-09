Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1FILjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:39:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:41204 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1FILjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:39:19 -0400
Date: Thu, 9 Jun 2011 13:39:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Headphone output doesn't work with 3.0.0-rc* anymore
Message-ID: <20110609113913.GA4875@tiehlicka.suse.cz>
References: <20110607180522.GA4004@tiehlicka.suse.cz>
 <s5hy61cxqcz.wl%tiwai@suse.de>
 <20110608174855.GA4138@tiehlicka.suse.cz>
 <s5hr573y1rl.wl%tiwai@suse.de>
 <20110609085616.GA4207@tiehlicka.suse.cz>
 <20110609090607.GB4207@tiehlicka.suse.cz>
 <s5hei33xsxn.wl%tiwai@suse.de>
 <20110609092826.GC4207@tiehlicka.suse.cz>
 <s5haadrxrsm.wl%tiwai@suse.de>
 <20110609111401.GA3994@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20110609111401.GA3994@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 09-06-11 13:14:01, Michal Hocko wrote:
[...]
> I have just booted to the rc2 with the patch (https://lkml.org/lkml/2011/6/9/25)
> and it looks it didn't solve the problem. Playback works only from
> speakers when headphones are not plugged in - no sound if plugged in.
> See alsa-info.txt-fresh-boot. Same thing happens if I 
> modprobe -r snd-hda-intel and then load it again (without any parameters).
> 
> > If yes, does the problem appear with it?  I.e. is the silence problem
> > specific to model=auto or not?
> 
> If I try to modproble with model=auto I get headphones working but not
> output from speakers. Have a look at alsa-info.txt-modprobe_auto.

Bahh, I forgot to attach those files.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alsa-info.txt-fresh-boot"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.60
!!################################

!!Script ran on: Thu Jun  9 11:07:32 UTC 2011


!!Linux Distribution
!!------------------

Debian GNU/Linux wheezy/sid \n \l


!!DMI Information
!!---------------

Manufacturer:      FUJITSU SIEMENS
Product Name:      LIFEBOOK S7110
Product Version:    


!!Kernel Information
!!------------------

Kernel release:    3.0.0-rc2-snd-test-00001-g40269a8
Operating System:  GNU/Linux
Architecture:      i686
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.24
Library version:    1.0.23
Utilities version:  1.0.23


!!Loaded ALSA modules
!!-------------------

snd_hda_intel


!!Sound Servers on this system
!!----------------------------

aRts:
      Installed - Yes (/usr/bin/artsd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xf0640000 irq 41


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 02)
	Subsystem: 10cf:1397


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2
snd-usb-audio: index=-2
snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
	bdl_pos_adj : 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	power_save : 0
	power_save_controller : Y
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	single_cmd : N


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Realtek ALC262
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec0262
Subsystem Id: 0x10cf0000
Revision Id: 0x100002
No Modem Function Group found
Default PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x11: Stereo
  Device: name="ALC262 Analog", type="Audio", device=0
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x04 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
  Control: name="IEC958 Playback Con Mask", index=0, device=0
  Control: name="IEC958 Playback Pro Mask", index=0, device=0
  Control: name="IEC958 Playback Default", index=0, device=0
  Control: name="IEC958 Playback Switch", index=0, device=0
  Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
  Device: name="ALC262 Digital", type="SPDIF", device=1
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
Node 0x07 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=0, device=0
  Control: name="Capture Volume", index=0, device=0
  Device: name="ALC262 Analog", type="Audio", device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x24
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=1, device=0
  Control: name="Capture Volume", index=1, device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=2, device=0
  Control: name="Capture Volume", index=2, device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x22
Node 0x0a [Audio Input] wcaps 0x100391: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x1f
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="CD Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=4, ofs=0
  Control: name="CD Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=4, ofs=0
  Control: name="Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Internal Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Internal Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x87 0x87] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x1f 0x1f] [0x80 0x80]
  Connection: 6
     0x18 0x19 0x1a 0x1b 0x1c 0x1d
Node 0x0c [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x1c 0x1c]
  Connection: 2
     0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x1c 0x1c]
  Connection: 2
     0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010e: Mono Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00] [0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x00]
  Connection: 2
     0x02 0x0b
Node 0x0f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Master Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000003e: IN OUT HP Detect Trigger
  Pin Default 0x03211020: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=04, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000003e: IN OUT HP Detect Trigger
  Pin Default 0x90170110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c 0x0d*
Node 0x16 [Pin Complex] wcaps 0x40010c: Mono Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80]
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x03a11040: [Jack] Mic at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Internal Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x90a70150: [Fixed] Mic at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x5, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x23a11030: [Jack] Mic at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Master Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x2321101f: [Jack] HP Out at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=04, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x593301f0: [N/A] CD at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x9097013f: [Fixed] Aux at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x3, Sequence = 0xf
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
Node 0x1e [Pin Complex] wcaps 0x400380: Mono Digital
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x06
Node 0x1f [Pin Complex] wcaps 0x400280: Mono Digital
  Pincap 0x00000020: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
  Processing caps: benign=0, ncoeff=17
Node 0x21 [Volume Knob Widget] wcaps 0x600080: Mono
  Volume-Knob: delta=0, steps=32, direct=0, val=64
  Unsolicited: tag=00, enabled=0
  Connection: 0
Node 0x22 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Control: name="Input Source", index=2, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Control: name="Input Source", index=1, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Node 0x24 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Control: name="Input Source", index=0, device=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Codec: LSI ID 1040
Address: 1
MFG Function Id: 0x2 (unsol 1)
Vendor Id: 0x11c11040
Subsystem Id: 0x11c10001
Revision Id: 0x100200
Modem Function Group: 0x1
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  5 Jun  9 11:56 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  4 Jun  9 11:56 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  3 Jun  9 11:56 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116,  2 Jun  9 11:56 /dev/snd/pcmC0D1p
crw-rw----+ 1 root audio 116,  1 Jun  9 11:56 /dev/snd/seq
crw-rw----+ 1 root audio 116, 33 Jun  9 11:56 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jun  9 11:56 .
drwxr-xr-x 3 root root 180 Jun  9 11:56 ..
lrwxrwxrwx 1 root root  12 Jun  9 11:56 pci-0000:00:1b.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC262 Analog [ALC262 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: ALC262 Digital [ALC262 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC262 Analog [ALC262 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xf0640000 irq 41'
  Mixer name	: 'Realtek ALC262'
  Components	: 'HDA:10ec0262,10cf0000,00100002 HDA:11c11040,11c10001,00100200'
  Controls      : 26
  Simple ctrls  : 16
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch pswitch-joined penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 28 [90%] [-4.50dB] [on]
  Front Right: Playback 28 [90%] [-4.50dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 180 [71%] [-15.00dB]
  Front Right: Playback 180 [71%] [-15.00dB]
Simple mixer control 'CD',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [12.00dB] [on]
  Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 7 [23%] [-24.00dB] [off]
  Front Right: Playback 7 [23%] [-24.00dB] [off]
Simple mixer control 'Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 3 [100%] [30.00dB]
  Front Right: 3 [100%] [30.00dB]
Simple mixer control 'IEC958',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'IEC958 Default PCM',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Capture',2
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Digital',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 89 [74%] [14.50dB]
  Front Right: Capture 89 [74%] [14.50dB]
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Mic' 'Internal Mic' 'CD'
  Item0: 'Mic'
Simple mixer control 'Input Source',1
  Capabilities: cenum
  Items: 'Mic' 'Internal Mic' 'CD'
  Item0: 'Mic'
Simple mixer control 'Input Source',2
  Capabilities: cenum
  Items: 'Mic' 'Internal Mic' 'CD'
  Item0: 'Mic'
Simple mixer control 'Internal Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [on]
  Front Right: Playback 0 [0%] [-34.50dB] [on]
Simple mixer control 'Internal Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value.0 28
		value.1 28
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.3 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'CD Playback Volume'
		value.0 31
		value.1 31
	}
	control.4 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'CD Playback Switch'
		value.0 true
		value.1 true
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost Volume'
		value.0 3
		value.1 3
	}
	control.6 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Mic Playback Volume'
		value.0 7
		value.1 7
	}
	control.7 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.8 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Internal Mic Boost Volume'
		value.0 0
		value.1 0
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Internal Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Internal Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.11 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.12 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 true
		value.1 true
	}
	control.13 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 2
		value.0 true
		value.1 true
	}
	control.14 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		value.0 19
		value.1 19
	}
	control.15 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 19
		value.1 19
	}
	control.16 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 2
		value.0 19
		value.1 19
	}
	control.17 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Internal Mic'
		comment.item.2 CD
		iface MIXER
		name 'Input Source'
		value Mic
	}
	control.18 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Internal Mic'
		comment.item.2 CD
		iface MIXER
		name 'Input Source'
		index 1
		value Mic
	}
	control.19 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Internal Mic'
		comment.item.2 CD
		iface MIXER
		name 'Input Source'
		index 2
		value Mic
	}
	control.20 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.21 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.22 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.23 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		value false
	}
	control.24 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Default PCM Playback Switch'
		value true
	}
	control.25 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 180
		value.1 180
	}
	control.26 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 120'
		comment.tlv '0000000100000008fffff44800000032'
		comment.dbmin -3000
		comment.dbmax 3000
		iface MIXER
		name 'Digital Capture Volume'
		value.0 89
		value.1 89
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
i915
fbcon
font
bitblit
softcursor
drm_kms_helper
drm
fb
fbdev
i2c_algo_bit
cfbcopyarea
i2c_core
cfbimgblt
cfbfillrect
fuse
tun
coretemp
hwmon
snd_hda_codec_realtek
arc4
snd_hda_intel
snd_hda_codec
iwl3945
snd_pcm_oss
iwl_legacy
snd_mixer_oss
snd_pcm
mac80211
snd_seq_oss
cfg80211
fujitsu_laptop
video
snd_seq_midi_event
snd_seq
snd_timer
snd_seq_device
snd
backlight
snd_page_alloc


!!ALSA/HDA dmesg
!!------------------

[   11.613463] iwl3945 0000:05:00.0: setting latency timer to 64
[   11.625150] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.625340] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.625556] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.625938] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[   11.625985] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.672055] iwl3945 0000:05:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
--
[   11.715157] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[   11.823347] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   13.380104] Adding 979928k swap on /dev/sda8.  Priority:-1 extents:1 across:979928k 



--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alsa-info.txt-modprobe_auto"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.60
!!################################

!!Script ran on: Thu Jun  9 11:13:05 UTC 2011


!!Linux Distribution
!!------------------

Debian GNU/Linux wheezy/sid \n \l


!!DMI Information
!!---------------

Manufacturer:      FUJITSU SIEMENS
Product Name:      LIFEBOOK S7110
Product Version:    


!!Kernel Information
!!------------------

Kernel release:    3.0.0-rc2-snd-test-00001-g40269a8
Operating System:  GNU/Linux
Architecture:      i686
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.24
Library version:    1.0.23
Utilities version:  1.0.23


!!Loaded ALSA modules
!!-------------------

snd_hda_intel


!!Sound Servers on this system
!!----------------------------

aRts:
      Installed - Yes (/usr/bin/artsd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xf0640000 irq 41


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 02)
	Subsystem: 10cf:1397


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2
snd-usb-audio: index=-2
snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-pcsp: index=-2


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
	bdl_pos_adj : 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : -1
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : auto,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	power_save : 60
	power_save_controller : Y
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	single_cmd : N


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Realtek ALC262
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec0262
Subsystem Id: 0x10cf0000
Revision Id: 0x100002
No Modem Function Group found
Default PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=4, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x11: Stereo
  Device: name="ALC262 Analog", type="Audio", device=0
  Converter: stream=5, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x04 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
Node 0x07 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=0, device=0
  Control: name="Capture Volume", index=0, device=0
  Device: name="ALC262 Analog", type="Audio", device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x24
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=1, device=0
  Control: name="Capture Volume", index=1, device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Control: name="Capture Switch", index=2, device=0
  Control: name="Capture Volume", index=2, device=0
  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x13 0x13]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0x6]: 16 20
    formats [0x1]: PCM
  Connection: 1
     0x22
Node 0x0a [Audio Input] wcaps 0x100391: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x1f
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Control: name="Internal Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Internal Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=1, ofs=0
  Control: name="Dock Mic Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=2, ofs=0
  Control: name="Dock Mic Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=2, ofs=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x87 0x87] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Connection: 6
     0x18 0x19 0x1a 0x1b 0x1c 0x1d
Node 0x0c [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Control: name="Master Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x1c 0x1c]
  Connection: 2
     0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 2
     0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010e: Mono Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00] [0x00]
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
  Amp-Out vals:  [0x00]
  Connection: 2
     0x02 0x0b
Node 0x0f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="PCM Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000003e: IN OUT HP Detect Trigger
  Pin Default 0x03211020: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=01, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Speaker Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000003e: IN OUT HP Detect Trigger
  Pin Default 0x90170110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x16 [Pin Complex] wcaps 0x40010c: Mono Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80]
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x03 0x03]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x03a11040: [Jack] Mic at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x21: IN VREF_50
  Unsolicited: tag=08, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Internal Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x90a70150: [Fixed] Mic at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x5, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Dock Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=In, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x23a11030: [Jack] Mic at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x3, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 2
     0x0c* 0x0d
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Control: name="Headphone Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000173e: IN OUT HP Detect Trigger
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x2321101f: [Jack] HP Out at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=04, enabled=1
  Connection: 2
     0x0c* 0x0d
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x593301f0: [N/A] CD at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x9097013f: [Fixed] Aux at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x3, Sequence = 0xf
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
Node 0x1e [Pin Complex] wcaps 0x400380: Mono Digital
  Pincap 0x00000010: OUT
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x06
Node 0x1f [Pin Complex] wcaps 0x400280: Mono Digital
  Pincap 0x00000020: IN
  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
  Processing caps: benign=0, ncoeff=17
Node 0x21 [Volume Knob Widget] wcaps 0x600080: Mono
  Volume-Knob: delta=0, steps=32, direct=0, val=64
  Unsolicited: tag=00, enabled=0
  Connection: 0
Node 0x22 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Node 0x24 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 9
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x0b
Codec: LSI ID 1040
Address: 1
MFG Function Id: 0x2 (unsol 1)
Vendor Id: 0x11c11040
Subsystem Id: 0x11c10001
Revision Id: 0x100200
Modem Function Group: 0x1
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  4 Jun  9 13:12 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  3 Jun  9 13:12 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  2 Jun  9 13:12 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116,  1 Jun  9 11:56 /dev/snd/seq
crw-rw----+ 1 root audio 116, 33 Jun  9 11:56 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jun  9 13:12 .
drwxr-xr-x 3 root root 160 Jun  9 13:12 ..
lrwxrwxrwx 1 root root  12 Jun  9 13:12 pci-0000:00:1b.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC262 Analog [ALC262 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC262 Analog [ALC262 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xf0640000 irq 41'
  Mixer name	: 'Realtek ALC262'
  Components	: 'HDA:10ec0262,10cf0000,00100002 HDA:11c11040,11c10001,00100200'
  Controls      : 23
  Simple ctrls  : 15
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch pswitch-joined penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 28 [90%] [-4.50dB] [on]
  Front Right: Playback 28 [90%] [-4.50dB] [on]
Simple mixer control 'Headphone',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'Speaker',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 180 [71%] [-15.00dB] [on]
  Front Right: Playback 180 [71%] [-15.00dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 7 [23%] [-24.00dB] [off]
  Front Right: Playback 7 [23%] [-24.00dB] [off]
Simple mixer control 'Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 3 [100%] [30.00dB]
  Front Right: 3 [100%] [30.00dB]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Capture',2
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 31
  Front Left: Capture 19 [61%] [16.50dB] [on]
  Front Right: Capture 19 [61%] [16.50dB] [on]
Simple mixer control 'Auto-Mute Mode',0
  Capabilities: enum
  Items: 'Disabled' 'Speaker Only' 'Line-Out+Speaker'
  Item0: 'Line-Out+Speaker'
Simple mixer control 'Digital',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 89 [74%] [14.50dB]
  Front Right: Capture 89 [74%] [14.50dB]
Simple mixer control 'Dock Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off]
Simple mixer control 'Dock Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]
Simple mixer control 'Internal Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-34.50dB] [on]
  Front Right: Playback 0 [0%] [-34.50dB] [on]
Simple mixer control 'Internal Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'PCM Playback Switch'
		value.0 true
		value.1 true
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Speaker Playback Switch'
		value.0 true
		value.1 true
	}
	control.3 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Headphone Playback Switch'
		value.0 true
		value.1 true
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value.0 28
		value.1 28
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Mic Playback Volume'
		value.0 7
		value.1 7
	}
	control.6 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.7 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Internal Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.8 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Internal Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.9 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Dock Mic Playback Volume'
		value.0 0
		value.1 0
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Dock Mic Playback Switch'
		value.0 false
		value.1 false
	}
	control.11 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost Volume'
		value.0 3
		value.1 3
	}
	control.12 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Internal Mic Boost Volume'
		value.0 0
		value.1 0
	}
	control.13 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Dock Mic Boost Volume'
		value.0 0
		value.1 0
	}
	control.14 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Disabled
		comment.item.1 'Speaker Only'
		comment.item.2 Line-Out+Speaker
		iface MIXER
		name 'Auto-Mute Mode'
		value Line-Out+Speaker
	}
	control.15 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 true
		value.1 true
	}
	control.17 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 2
		value.0 true
		value.1 true
	}
	control.18 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		value.0 19
		value.1 19
	}
	control.19 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 19
		value.1 19
	}
	control.20 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -1200
		comment.dbmax 3450
		iface MIXER
		name 'Capture Volume'
		index 2
		value.0 19
		value.1 19
	}
	control.21 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.22 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 180
		value.1 180
	}
	control.23 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 120'
		comment.tlv '0000000100000008fffff44800000032'
		comment.dbmin -3000
		comment.dbmax 3000
		iface MIXER
		name 'Digital Capture Volume'
		value.0 89
		value.1 89
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
snd_hda_intel
i915
fbcon
font
bitblit
softcursor
drm_kms_helper
drm
fb
fbdev
i2c_algo_bit
cfbcopyarea
i2c_core
cfbimgblt
cfbfillrect
fuse
tun
coretemp
hwmon
snd_hda_codec_realtek
arc4
snd_hda_codec
iwl3945
snd_pcm_oss
iwl_legacy
snd_mixer_oss
snd_pcm
mac80211
snd_seq_oss
cfg80211
fujitsu_laptop
video
snd_seq_midi_event
snd_seq
snd_timer
snd_seq_device
snd
backlight
snd_page_alloc


!!ALSA/HDA dmesg
!!------------------

[   11.613463] iwl3945 0000:05:00.0: setting latency timer to 64
[   11.625150] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.625340] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   11.625556] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.625938] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[   11.625985] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.672055] iwl3945 0000:05:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
--
[   11.715157] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[   11.823347] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   13.380104] Adding 979928k swap on /dev/sda8.  Priority:-1 extents:1 across:979928k 
--
[ 4225.168080] CE: hpet increased min_delta_ns to 20113 nsec
[ 4446.424346] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 4449.311984] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 4449.312628] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 4449.312642] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 4449.312718] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[ 4449.312749] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 4449.364208] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[ 4573.072255] HDA Intel 0000:00:1b.0: PCI INT A disabled
[ 4580.093324] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 4580.093339] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[ 4580.093356] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 4580.093450] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[ 4580.093490] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 4580.144165] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[ 4580.144262] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[ 4580.151781] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15



--azLHFNyN32YCQGCU--
