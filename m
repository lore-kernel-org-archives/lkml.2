Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1KLRBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 12:01:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46567 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1KLRBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 12:01:10 -0500
Message-ID: <4EBEA50C.9070209@gmail.com>
Date: Sat, 12 Nov 2011 18:55:40 +0200
From: "Paul Barbu Gh." <paullik.paul@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: No sound after updating to 3.1.0-4
Content-Type: multipart/mixed;
 boundary="------------070905070805070904040008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070905070805070904040008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

After 9 Nov 2011 kernel update to 3.1.0-4 in ArchLinux I get no sound 
output(headphones and speakers), I checked alsamixer and pavucontrol and 
everything seems OK.

I attached some logs to help you track the problem down.

-- 

Common sense is not so common - Voltaire
http://tweak-it.tk/ - Personal portfolio and web-log - Barbu Paul - Gh.
Visit My GitHub profile to see my open-source projects - https://github.com/paullik

--------------070905070805070904040008
Content-Type: text/x-log;
 name="amixer.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="amixer.log"

numid=20,iface=MIXER,name='Master Playback Switch'
  ; type=BOOLEAN,access=rw------,values=1
  : values=on
numid=6,iface=MIXER,name='Headphone Playback Switch'
  ; type=BOOLEAN,access=rw------,values=2
  : values=on,on
numid=21,iface=MIXER,name='PCM Playback Volume'
  ; type=INTEGER,access=rw---RW-,values=2,min=0,max=255,step=0
  : values=249,249
  | dBscale-min=-51.00dB,step=0.20dB,mute=0
numid=2,iface=MIXER,name='Front Playback Switch'
  ; type=BOOLEAN,access=rw------,values=2
  : values=on,on
numid=3,iface=MIXER,name='Surround Playback Switch'
  ; type=BOOLEAN,access=rw------,values=2
  : values=on,on
numid=4,iface=MIXER,name='Center Playback Switch'
  ; type=BOOLEAN,access=rw------,values=1
  : values=on
numid=5,iface=MIXER,name='LFE Playback Switch'
  ; type=BOOLEAN,access=rw------,values=1
  : values=on
numid=8,iface=MIXER,name='CD Playback Switch'
  ; type=BOOLEAN,access=rw------,values=2
  : values=on,on
numid=7,iface=MIXER,name='CD Playback Volume'
  ; type=INTEGER,access=rw---R--,values=2,min=0,max=23,step=0
  : values=5,5
  | dBscale-min=-36.00dB,step=3.00dB,mute=0
numid=10,iface=MIXER,name='Capture Switch'
  ; type=BOOLEAN,access=rw------,values=2
  : values=on,on
numid=11,iface=MIXER,name='Capture Volume'
  ; type=INTEGER,access=rw---R--,values=2,min=0,max=13,step=0
  : values=7,7
  | dBscale-min=-6.00dB,step=3.00dB,mute=0
numid=17,iface=MIXER,name='IEC958 Default PCM Playback Switch'
  ; type=BOOLEAN,access=rw------,values=1
  : values=on
numid=13,iface=MIXER,name='IEC958 Playback Con Mask'
  ; type=IEC958,access=r-------,values=1
  : values=[AES0=0x0f AES1=0xff AES2=0x00 AES3=0x00]
numid=14,iface=MIXER,name='IEC958 Playback Pro Mask'
  ; type=IEC958,access=r-------,values=1
  : values=[AES0=0x0f AES1=0x00 AES2=0x00 AES3=0x00]
numid=15,iface=MIXER,name='IEC958 Playback Default'
  ; type=IEC958,access=rw------,values=1
  : values=[AES0=0x04 AES1=0x00 AES2=0x00 AES3=0x00]
numid=16,iface=MIXER,name='IEC958 Playback Switch'
  ; type=BOOLEAN,access=rw------,values=1
  : values=on
numid=9,iface=MIXER,name='Auto-Mute Mode'
  ; type=ENUMERATED,access=rw------,values=1,items=2
  ; Item #0 'Disabled'
  ; Item #1 'Enabled'
  : values=0
numid=19,iface=MIXER,name='Beep Playback Switch'
  ; type=BOOLEAN,access=rw------,values=2
  : values=off,off
numid=18,iface=MIXER,name='Beep Playback Volume'
  ; type=INTEGER,access=rw---R--,values=2,min=0,max=15,step=0
  : values=15,15
  | dBscale-min=-45.00dB,step=3.00dB,mute=0
numid=1,iface=MIXER,name='Channel Mode'
  ; type=ENUMERATED,access=rw------,values=1,items=3
  ; Item #0 '2ch'
  ; Item #1 '4ch'
  ; Item #2 '6ch'
  : values=0
numid=12,iface=MIXER,name='Input Source'
  ; type=ENUMERATED,access=rw------,values=1,items=4
  ; Item #0 'Rear Mic'
  ; Item #1 'Front Mic'
  ; Item #2 'Line'
  ; Item #3 'CD'
  : values=1

--------------070905070805070904040008
Content-Type: text/x-log;
 name="aplay.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="aplay.log"

**** List of PLAYBACK Hardware Devices ****
card 0: VT82xx [HDA VIA VT82xx], device 0: ALC660 Analog [ALC660 Analog]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 0: VT82xx [HDA VIA VT82xx], device 1: ALC660 Digital [ALC660 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

--------------070905070805070904040008
Content-Type: text/x-log;
 name="id.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="id.log"

uid=1000(paullik) gid=100(users) groups=100(users),7(lp),10(wheel),33(http),45(mpd),50(games),91(video),92(audio),93(optical),95(storage),96(scanner),98(power),108(vboxusers),150(wireshark)

--------------070905070805070904040008
Content-Type: text/x-log;
 name="lsmod.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsmod.log"

Module                  Size  Used by
ipv6                  247457  55 
fuse                   58373  2 
usb_storage            35343  0 
lm63                    4867  0 
uas                     6440  0 
snd_hda_codec_realtek   210668  1 
snd_hda_intel          19293  6 
snd_hda_codec          69500  2 snd_hda_codec_realtek,snd_hda_intel
radeon                912612  2 
snd_hwdep               4942  1 snd_hda_codec
snd_pcm                60175  4 snd_hda_intel,snd_hda_codec
snd_timer              15438  1 snd_pcm
ttm                    45685  1 radeon
snd                    43817  16 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
drm_kms_helper         22237  1 radeon
drm                   149266  4 radeon,ttm,drm_kms_helper
soundcore               5018  1 snd
snd_page_alloc          5869  2 snd_hda_intel,snd_pcm
ppdev                   4814  0 
i2c_algo_bit            4455  1 radeon
i2c_viapro              4783  0 
parport_pc             26558  0 
parport                26067  2 ppdev,parport_pc
psmouse                56772  0 
shpchp                 22529  0 
i2c_core               16816  6 lm63,radeon,drm_kms_helper,drm,i2c_algo_bit,i2c_viapro
via_rhine              19099  0 
floppy                 48773  0 
mii                     3407  1 via_rhine
pci_hotplug            22072  1 shpchp
serio_raw               3390  0 
uhci_hcd               19609  0 
pcspkr                  1375  0 
evdev                   7278  4 
via_agp                 4942  1 
agpgart                22319  3 ttm,drm,via_agp
ehci_hcd               35882  0 
processor              21844  0 
usbcore               120220  5 usb_storage,uas,uhci_hcd,ehci_hcd
button                  3614  0 
asus_atk0110            9091  0 
ext4                  341228  2 
mbcache                 4281  1 ext4
jbd2                   59569  1 ext4
crc16                   1091  1 ext4
sd_mod                 26147  5 
sr_mod                 13244  0 
cdrom                  31405  1 sr_mod
pata_acpi               2388  0 
pata_via                7366  4 
sata_via                5880  0 
libata                146596  3 pata_acpi,pata_via,sata_via
scsi_mod              112345  5 usb_storage,uas,sd_mod,sr_mod,libata

--------------070905070805070904040008
Content-Type: text/x-log;
 name="lspci.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci.log"

00:00.0 Host bridge: VIA Technologies, Inc. P4M890 Host Bridge
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR+ INTx-
	Latency: 8
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Capabilities: <access denied>
	Kernel driver in use: agpgart-via
	Kernel modules: via-agp

00:00.1 Host bridge: VIA Technologies, Inc. P4M890 Host Bridge
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.2 Host bridge: VIA Technologies, Inc. P4M890 Host Bridge
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.3 Host bridge: VIA Technologies, Inc. P4M890 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.4 Host bridge: VIA Technologies, Inc. P4M890 Host Bridge
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.5 PIC: VIA Technologies, Inc. P4M890 I/O APIC Interrupt Controller (prog-if 20 [IO(X)-APIC])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.6 Host bridge: VIA Technologies, Inc. P4M890 Security Device
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.7 Host bridge: VIA Technologies, Inc. P4M890 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:01.0 PCI bridge: VIA Technologies, Inc. VT8237/VX700 PCI Bridge (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel modules: shpchp

00:02.0 PCI bridge: VIA Technologies, Inc. P4M890 PCI to PCI Bridge Controller (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:03.0 PCI bridge: VIA Technologies, Inc. P4M890 PCI to PCI Bridge Controller (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: 80000000-801fffff
	Prefetchable memory behind bridge: 0000000080200000-00000000803fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:0f.0 IDE interface: VIA Technologies, Inc. VT8237A SATA 2-Port Controller (rev 80) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin B routed to IRQ 21
	Region 0: I/O ports at dc00 [size=8]
	Region 1: I/O ports at d880 [size=4]
	Region 2: I/O ports at d800 [size=8]
	Region 3: I/O ports at d480 [size=4]
	Region 4: I/O ports at d400 [size=16]
	Region 5: I/O ports at d000 [size=256]
	Capabilities: <access denied>
	Kernel driver in use: sata_via
	Kernel modules: sata_via

00:0f.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at fc00 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: pata_via
	Kernel modules: pata_via

00:10.0 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at cc00 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:10.1 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 22
	Region 4: I/O ports at c880 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:10.2 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 21
	Region 4: I/O ports at c800 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:10.3 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev a0) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 23
	Region 4: I/O ports at c480 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:10.4 USB controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 21
	Region 0: Memory at fbdffc00 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
	Subsystem: ASUSTeK Computer Inc. Device 81b5
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>
	Kernel modules: i2c-viapro

00:11.7 Host bridge: VIA Technologies, Inc. VT8237/8251 Ultra VLINK Controller
	Subsystem: VIA Technologies, Inc. Device 337e
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR+ INTx-
	Latency: 128
	Capabilities: <access denied>

00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 7c)
	Subsystem: ASUSTeK Computer Inc. A7V600-X Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (750ns min, 2000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: I/O ports at c000 [size=256]
	Region 1: Memory at fbdff800 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: via-rhine
	Kernel modules: via-rhine

00:13.0 PCI bridge: VIA Technologies, Inc. VT8237A Host Bridge (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Memory behind bridge: fbf00000-fbffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel modules: shpchp

02:00.0 VGA compatible controller: ATI Technologies Inc Device 71c3 (rev 9e) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 01ac
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 66
	Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at fbef0000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at e800 [size=256]
	Expansion ROM at fbec0000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: radeon
	Kernel modules: radeon

02:00.1 Display controller: ATI Technologies Inc Device 71e3 (rev 9e)
	Subsystem: ASUSTeK Computer Inc. Device 01ad
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Region 0: Memory at fbee0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>

04:01.0 Audio device: VIA Technologies, Inc. VT8237A/VT8251 HDA Controller (rev 10)
	Subsystem: ASUSTeK Computer Inc. Device 81e7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 67
	Region 0: Memory at fbffc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel


--------------070905070805070904040008
Content-Type: text/x-log;
 name="pacmd.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="pacmd.log"

V2VsY29tZSB0byBQdWxzZUF1ZGlvISBVc2UgImhlbHAiIGZvciB1c2FnZSBpbmZvcm1hdGlv
bi4KPj4+IE1lbW9yeSBibG9ja3MgY3VycmVudGx5IGFsbG9jYXRlZDogNjE0LCBzaXplOiA5
NzAuOCBLaUIuCk1lbW9yeSBibG9ja3MgYWxsb2NhdGVkIGR1cmluZyB0aGUgd2hvbGUgbGlm
ZXRpbWU6IDIzNzMzMjEsIHNpemU6IDIuNyBHaUIuCk1lbW9yeSBibG9ja3MgaW1wb3J0ZWQg
ZnJvbSBvdGhlciBwcm9jZXNzZXM6IDEyOCwgc2l6ZTogMjQ4LjkgS2lCLgpNZW1vcnkgYmxv
Y2tzIGV4cG9ydGVkIHRvIG90aGVyIHByb2Nlc3NlczogMCwgc2l6ZTogMCBCLgpUb3RhbCBz
YW1wbGUgY2FjaGUgc2l6ZTogMCBCLgpEZWZhdWx0IHNhbXBsZSBzcGVjOiBzMTZsZSAyY2gg
NDQxMDBIegpEZWZhdWx0IGNoYW5uZWwgbWFwOiBmcm9udC1sZWZ0LGZyb250LXJpZ2h0CkRl
ZmF1bHQgc2luayBuYW1lOiBhbHNhX291dHB1dC5wY2ktMDAwMF8wNF8wMS4wLmFuYWxvZy1z
dGVyZW8KRGVmYXVsdCBzb3VyY2UgbmFtZTogYWxzYV9pbnB1dC5wY2ktMDAwMF8wNF8wMS4w
LmFuYWxvZy1zdGVyZW8KTWVtb3J5IGJsb2NrcyBvZiB0eXBlIFBPT0w6IDQ4NSBhbGxvY2F0
ZWQvMTYyNzgwOCBhY2N1bXVsYXRlZC4KTWVtb3J5IGJsb2NrcyBvZiB0eXBlIFBPT0xfRVhU
RVJOQUw6IDEgYWxsb2NhdGVkLzI5MDU1MyBhY2N1bXVsYXRlZC4KTWVtb3J5IGJsb2NrcyBv
ZiB0eXBlIEFQUEVOREVEOiAwIGFsbG9jYXRlZC81NzcgYWNjdW11bGF0ZWQuCk1lbW9yeSBi
bG9ja3Mgb2YgdHlwZSBVU0VSOiAwIGFsbG9jYXRlZC82IGFjY3VtdWxhdGVkLgpNZW1vcnkg
YmxvY2tzIG9mIHR5cGUgRklYRUQ6IDAgYWxsb2NhdGVkLzU4MDI5OCBhY2N1bXVsYXRlZC4K
TWVtb3J5IGJsb2NrcyBvZiB0eXBlIElNUE9SVEVEOiAxMjggYWxsb2NhdGVkLzE2NDYzOCBh
Y2N1bXVsYXRlZC4KMjIgbW9kdWxlKHMpIGxvYWRlZC4KICAgIGluZGV4OiAwCgluYW1lOiA8
bW9kdWxlLWRldmljZS1yZXN0b3JlPgoJYXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9hZCBv
bmNlOiB5ZXMKCXByb3BlcnRpZXM6CgkJbW9kdWxlLmF1dGhvciA9ICJMZW5uYXJ0IFBvZXR0
ZXJpbmciCgkJbW9kdWxlLmRlc2NyaXB0aW9uID0gIkF1dG9tYXRpY2FsbHkgcmVzdG9yZSB0
aGUgdm9sdW1lL211dGUgc3RhdGUgb2YgZGV2aWNlcyIKCQltb2R1bGUudmVyc2lvbiA9ICIx
LjEiCiAgICBpbmRleDogMQoJbmFtZTogPG1vZHVsZS1zdHJlYW0tcmVzdG9yZT4KCWFyZ3Vt
ZW50OiA8PgoJdXNlZDogLTEKCWxvYWQgb25jZTogeWVzCglwcm9wZXJ0aWVzOgoJCW1vZHVs
ZS5hdXRob3IgPSAiTGVubmFydCBQb2V0dGVyaW5nIgoJCW1vZHVsZS5kZXNjcmlwdGlvbiA9
ICJBdXRvbWF0aWNhbGx5IHJlc3RvcmUgdGhlIHZvbHVtZS9tdXRlL2RldmljZSBzdGF0ZSBv
ZiBzdHJlYW1zIgoJCW1vZHVsZS52ZXJzaW9uID0gIjEuMSIKICAgIGluZGV4OiAyCgluYW1l
OiA8bW9kdWxlLWNhcmQtcmVzdG9yZT4KCWFyZ3VtZW50OiA8PgoJdXNlZDogLTEKCWxvYWQg
b25jZTogeWVzCglwcm9wZXJ0aWVzOgoJCW1vZHVsZS5hdXRob3IgPSAiTGVubmFydCBQb2V0
dGVyaW5nIgoJCW1vZHVsZS5kZXNjcmlwdGlvbiA9ICJBdXRvbWF0aWNhbGx5IHJlc3RvcmUg
cHJvZmlsZSBvZiBjYXJkcyIKCQltb2R1bGUudmVyc2lvbiA9ICIxLjEiCiAgICBpbmRleDog
MwoJbmFtZTogPG1vZHVsZS1hdWdtZW50LXByb3BlcnRpZXM+Cglhcmd1bWVudDogPD4KCXVz
ZWQ6IC0xCglsb2FkIG9uY2U6IHllcwoJcHJvcGVydGllczoKCQltb2R1bGUuYXV0aG9yID0g
Ikxlbm5hcnQgUG9ldHRlcmluZyIKCQltb2R1bGUuZGVzY3JpcHRpb24gPSAiQXVnbWVudCB0
aGUgcHJvcGVydHkgc2V0cyBvZiBzdHJlYW1zIHdpdGggYWRkaXRpb25hbCBzdGF0aWMgaW5m
b3JtYXRpb24iCgkJbW9kdWxlLnZlcnNpb24gPSAiMS4xIgogICAgaW5kZXg6IDQKCW5hbWU6
IDxtb2R1bGUtYWxzYS1jYXJkPgoJYXJndW1lbnQ6IDxkZXZpY2VfaWQ9IjAiIG5hbWU9InBj
aS0wMDAwXzA0XzAxLjAiIGNhcmRfbmFtZT0iYWxzYV9jYXJkLnBjaS0wMDAwXzA0XzAxLjAi
IG5hbWVyZWdfZmFpbD1mYWxzZSB0c2NoZWQ9eWVzIGlnbm9yZV9kQj1ubyBkZWZlcnJlZF92
b2x1bWU9eWVzIGNhcmRfcHJvcGVydGllcz0ibW9kdWxlLXVkZXYtZGV0ZWN0LmRpc2NvdmVy
ZWQ9MSI+Cgl1c2VkOiA5Cglsb2FkIG9uY2U6IG5vCglwcm9wZXJ0aWVzOgoJCW1vZHVsZS5h
dXRob3IgPSAiTGVubmFydCBQb2V0dGVyaW5nIgoJCW1vZHVsZS5kZXNjcmlwdGlvbiA9ICJB
TFNBIENhcmQiCgkJbW9kdWxlLnZlcnNpb24gPSAiMS4xIgogICAgaW5kZXg6IDUKCW5hbWU6
IDxtb2R1bGUtdWRldi1kZXRlY3Q+Cglhcmd1bWVudDogPD4KCXVzZWQ6IC0xCglsb2FkIG9u
Y2U6IHllcwoJcHJvcGVydGllczoKCQltb2R1bGUuYXV0aG9yID0gIkxlbm5hcnQgUG9ldHRl
cmluZyIKCQltb2R1bGUuZGVzY3JpcHRpb24gPSAiRGV0ZWN0IGF2YWlsYWJsZSBhdWRpbyBo
YXJkd2FyZSBhbmQgbG9hZCBtYXRjaGluZyBkcml2ZXJzIgoJCW1vZHVsZS52ZXJzaW9uID0g
IjEuMSIKICAgIGluZGV4OiA2CgluYW1lOiA8bW9kdWxlLWJsdWV0b290aC1kaXNjb3Zlcj4K
CWFyZ3VtZW50OiA8PgoJdXNlZDogLTEKCWxvYWQgb25jZTogeWVzCglwcm9wZXJ0aWVzOgoJ
CW1vZHVsZS5hdXRob3IgPSAiSm9hbyBQYXVsbyBSZWNoaSBWaXRhIgoJCW1vZHVsZS5kZXNj
cmlwdGlvbiA9ICJEZXRlY3QgYXZhaWxhYmxlIGJsdWV0b290aCBhdWRpbyBkZXZpY2VzIGFu
ZCBsb2FkIGJsdWV0b290aCBhdWRpbyBkcml2ZXJzIgoJCW1vZHVsZS52ZXJzaW9uID0gIjEu
MSIKICAgIGluZGV4OiA3CgluYW1lOiA8bW9kdWxlLWVzb3VuZC1wcm90b2NvbC11bml4PgoJ
YXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9hZCBvbmNlOiBubwoJcHJvcGVydGllczoKCQlt
b2R1bGUuYXV0aG9yID0gIkxlbm5hcnQgUG9ldHRlcmluZyIKCQltb2R1bGUuZGVzY3JpcHRp
b24gPSAiRVNPVU5EIHByb3RvY29sIChVTklYIHNvY2tldHMpIgoJCW1vZHVsZS52ZXJzaW9u
ID0gIjEuMSIKICAgIGluZGV4OiA4CgluYW1lOiA8bW9kdWxlLW5hdGl2ZS1wcm90b2NvbC11
bml4PgoJYXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9hZCBvbmNlOiBubwoJcHJvcGVydGll
czoKCQltb2R1bGUuYXV0aG9yID0gIkxlbm5hcnQgUG9ldHRlcmluZyIKCQltb2R1bGUuZGVz
Y3JpcHRpb24gPSAiTmF0aXZlIHByb3RvY29sIChVTklYIHNvY2tldHMpIgoJCW1vZHVsZS52
ZXJzaW9uID0gIjEuMSIKICAgIGluZGV4OiA5CgluYW1lOiA8bW9kdWxlLWdjb25mPgoJYXJn
dW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9hZCBvbmNlOiB5ZXMKCXByb3BlcnRpZXM6CgkJbW9k
dWxlLmF1dGhvciA9ICJMZW5uYXJ0IFBvZXR0ZXJpbmciCgkJbW9kdWxlLmRlc2NyaXB0aW9u
ID0gIkdDb25mIEFkYXB0ZXIiCgkJbW9kdWxlLnZlcnNpb24gPSAiMS4xIgogICAgaW5kZXg6
IDEwCgluYW1lOiA8bW9kdWxlLWRlZmF1bHQtZGV2aWNlLXJlc3RvcmU+Cglhcmd1bWVudDog
PD4KCXVzZWQ6IC0xCglsb2FkIG9uY2U6IHllcwoJcHJvcGVydGllczoKCQltb2R1bGUuYXV0
aG9yID0gIkxlbm5hcnQgUG9ldHRlcmluZyIKCQltb2R1bGUuZGVzY3JpcHRpb24gPSAiQXV0
b21hdGljYWxseSByZXN0b3JlIHRoZSBkZWZhdWx0IHNpbmsgYW5kIHNvdXJjZSIKCQltb2R1
bGUudmVyc2lvbiA9ICIxLjEiCiAgICBpbmRleDogMTEKCW5hbWU6IDxtb2R1bGUtcmVzY3Vl
LXN0cmVhbXM+Cglhcmd1bWVudDogPD4KCXVzZWQ6IC0xCglsb2FkIG9uY2U6IHllcwoJcHJv
cGVydGllczoKCQltb2R1bGUuYXV0aG9yID0gIkxlbm5hcnQgUG9ldHRlcmluZyIKCQltb2R1
bGUuZGVzY3JpcHRpb24gPSAiV2hlbiBhIHNpbmsvc291cmNlIGlzIHJlbW92ZWQsIHRyeSB0
byBtb3ZlIHRoZWlyIHN0cmVhbXMgdG8gdGhlIGRlZmF1bHQgc2luay9zb3VyY2UiCgkJbW9k
dWxlLnZlcnNpb24gPSAiMS4xIgogICAgaW5kZXg6IDEyCgluYW1lOiA8bW9kdWxlLWFsd2F5
cy1zaW5rPgoJYXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9hZCBvbmNlOiB5ZXMKCXByb3Bl
cnRpZXM6CgkJbW9kdWxlLmF1dGhvciA9ICJDb2xpbiBHdXRocmllIgoJCW1vZHVsZS5kZXNj
cmlwdGlvbiA9ICJBbHdheXMga2VlcHMgYXQgbGVhc3Qgb25lIHNpbmsgbG9hZGVkIGV2ZW4g
aWYgaXQncyBhIG51bGwgb25lIgoJCW1vZHVsZS52ZXJzaW9uID0gIjEuMSIKICAgIGluZGV4
OiAxMwoJbmFtZTogPG1vZHVsZS1pbnRlbmRlZC1yb2xlcz4KCWFyZ3VtZW50OiA8PgoJdXNl
ZDogLTEKCWxvYWQgb25jZTogeWVzCglwcm9wZXJ0aWVzOgoJCW1vZHVsZS5hdXRob3IgPSAi
TGVubmFydCBQb2V0dGVyaW5nIgoJCW1vZHVsZS5kZXNjcmlwdGlvbiA9ICJBdXRvbWF0aWNh
bGx5IHNldCBkZXZpY2Ugb2Ygc3RyZWFtcyBiYXNlZCBvZiBpbnRlbmRlZCByb2xlcyBvZiBk
ZXZpY2VzIgoJCW1vZHVsZS52ZXJzaW9uID0gIjEuMSIKICAgIGluZGV4OiAxNAoJbmFtZTog
PG1vZHVsZS1zdXNwZW5kLW9uLWlkbGU+Cglhcmd1bWVudDogPD4KCXVzZWQ6IC0xCglsb2Fk
IG9uY2U6IHllcwoJcHJvcGVydGllczoKCQltb2R1bGUuYXV0aG9yID0gIkxlbm5hcnQgUG9l
dHRlcmluZyIKCQltb2R1bGUuZGVzY3JpcHRpb24gPSAiV2hlbiBhIHNpbmsvc291cmNlIGlz
IGlkbGUgZm9yIHRvbyBsb25nLCBzdXNwZW5kIGl0IgoJCW1vZHVsZS52ZXJzaW9uID0gIjEu
MSIKICAgIGluZGV4OiAxNQoJbmFtZTogPG1vZHVsZS1jb25zb2xlLWtpdD4KCWFyZ3VtZW50
OiA8PgoJdXNlZDogLTEKCWxvYWQgb25jZTogeWVzCglwcm9wZXJ0aWVzOgoJCW1vZHVsZS5h
dXRob3IgPSAiTGVubmFydCBQb2V0dGVyaW5nIgoJCW1vZHVsZS5kZXNjcmlwdGlvbiA9ICJD
cmVhdGUgYSBjbGllbnQgZm9yIGVhY2ggQ29uc29sZUtpdCBzZXNzaW9uIG9mIHRoaXMgdXNl
ciIKCQltb2R1bGUudmVyc2lvbiA9ICIxLjEiCiAgICBpbmRleDogMTYKCW5hbWU6IDxtb2R1
bGUtcG9zaXRpb24tZXZlbnQtc291bmRzPgoJYXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9h
ZCBvbmNlOiB5ZXMKCXByb3BlcnRpZXM6CgkJbW9kdWxlLmF1dGhvciA9ICJMZW5uYXJ0IFBv
ZXR0ZXJpbmciCgkJbW9kdWxlLmRlc2NyaXB0aW9uID0gIlBvc2l0aW9uIGV2ZW50IHNvdW5k
cyBiZXR3ZWVuIEwgYW5kIFIgZGVwZW5kaW5nIG9uIHRoZSBwb3NpdGlvbiBvbiBzY3JlZW4g
b2YgdGhlIHdpZGdldCB0cmlnZ2VyaW5nIHRoZW0uIgoJCW1vZHVsZS52ZXJzaW9uID0gIjEu
MSIKICAgIGluZGV4OiAxNwoJbmFtZTogPG1vZHVsZS1jb3JrLW11c2ljLW9uLXBob25lPgoJ
YXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9hZCBvbmNlOiB5ZXMKCXByb3BlcnRpZXM6CgkJ
bW9kdWxlLmF1dGhvciA9ICJMZW5uYXJ0IFBvZXR0ZXJpbmciCgkJbW9kdWxlLmRlc2NyaXB0
aW9uID0gIk11dGUgb3IgY29yayBtdXNpYyB3aGlsZSBhIHBob25lIHN0cmVhbSBleGlzdHMi
CgkJbW9kdWxlLnZlcnNpb24gPSAiMS4xIgogICAgaW5kZXg6IDE4CgluYW1lOiA8bW9kdWxl
LWZpbHRlci1oZXVyaXN0aWNzPgoJYXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9hZCBvbmNl
OiB5ZXMKCXByb3BlcnRpZXM6CgkJbW9kdWxlLmF1dGhvciA9ICJDb2xpbiBHdXRocmllIgoJ
CW1vZHVsZS5kZXNjcmlwdGlvbiA9ICJEZXRlY3Qgd2hlbiB2YXJpb3VzIGZpbHRlcnMgYXJl
IGRlc2lyYWJsZSIKCQltb2R1bGUudmVyc2lvbiA9ICIxLjEiCiAgICBpbmRleDogMTkKCW5h
bWU6IDxtb2R1bGUtZmlsdGVyLWFwcGx5PgoJYXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9h
ZCBvbmNlOiB5ZXMKCXByb3BlcnRpZXM6CgkJbW9kdWxlLmF1dGhvciA9ICJDb2xpbiBHdXRo
cmllIgoJCW1vZHVsZS5kZXNjcmlwdGlvbiA9ICJMb2FkIGZpbHRlciBzaW5rcyBhdXRvbWF0
aWNhbGx5IHdoZW4gbmVlZGVkIgoJCW1vZHVsZS52ZXJzaW9uID0gIjEuMSIKICAgIGluZGV4
OiAyMAoJbmFtZTogPG1vZHVsZS1kYnVzLXByb3RvY29sPgoJYXJndW1lbnQ6IDw+Cgl1c2Vk
OiAtMQoJbG9hZCBvbmNlOiB5ZXMKCXByb3BlcnRpZXM6CgkJbW9kdWxlLmF1dGhvciA9ICJU
YW51IEthc2tpbmVuIgoJCW1vZHVsZS5kZXNjcmlwdGlvbiA9ICJELUJ1cyBpbnRlcmZhY2Ui
CgkJbW9kdWxlLnZlcnNpb24gPSAiMS4xIgogICAgaW5kZXg6IDIxCgluYW1lOiA8bW9kdWxl
LWNsaS1wcm90b2NvbC11bml4PgoJYXJndW1lbnQ6IDw+Cgl1c2VkOiAtMQoJbG9hZCBvbmNl
OiBubwoJcHJvcGVydGllczoKCQltb2R1bGUuYXV0aG9yID0gIkxlbm5hcnQgUG9ldHRlcmlu
ZyIKCQltb2R1bGUuZGVzY3JpcHRpb24gPSAiQ29tbWFuZCBsaW5lIGludGVyZmFjZSBwcm90
b2NvbCAoVU5JWCBzb2NrZXRzKSIKCQltb2R1bGUudmVyc2lvbiA9ICIxLjEiCjEgc2luayhz
KSBhdmFpbGFibGUuCiAgKiBpbmRleDogMAoJbmFtZTogPGFsc2Ffb3V0cHV0LnBjaS0wMDAw
XzA0XzAxLjAuYW5hbG9nLXN0ZXJlbz4KCWRyaXZlcjogPG1vZHVsZS1hbHNhLWNhcmQuYz4K
CWZsYWdzOiBIQVJEV0FSRSBIV19NVVRFX0NUUkwgSFdfVk9MVU1FX0NUUkwgREVDSUJFTF9W
T0xVTUUgTEFURU5DWSBGTEFUX1ZPTFVNRSBEWU5BTUlDX0xBVEVOQ1kKCXN0YXRlOiBSVU5O
SU5HCglzdXNwZW5kIGNhdXNlOiAKCXByaW9yaXR5OiA5MDU5Cgl2b2x1bWU6IDA6ICA5NSUg
MTogIDk1JQoJICAgICAgICAwOiAtMS4yMCBkQiAxOiAtMS4yMCBkQgoJICAgICAgICBiYWxh
bmNlIDAuMDAKCWJhc2Ugdm9sdW1lOiAxMDAlCgkgICAgICAgICAgICAgMC4wMCBkQgoJdm9s
dW1lIHN0ZXBzOiA2NTUzNwoJbXV0ZWQ6IG5vCgljdXJyZW50IGxhdGVuY3k6IDE5LjE0IG1z
CgltYXggcmVxdWVzdDogMyBLaUIKCW1heCByZXdpbmQ6IDM3NSBLaUIKCW1vbml0b3Igc291
cmNlOiAwCglzYW1wbGUgc3BlYzogczE2bGUgMmNoIDQ4MDAwSHoKCWNoYW5uZWwgbWFwOiBm
cm9udC1sZWZ0LGZyb250LXJpZ2h0CgkgICAgICAgICAgICAgU3RlcmVvCgl1c2VkIGJ5OiAx
CglsaW5rZWQgYnk6IDUKCWNvbmZpZ3VyZWQgbGF0ZW5jeTogMjAuMDAgbXM7IHJhbmdlIGlz
IDAuNTAgLi4gMjAwMC4wMCBtcwoJY2FyZDogMCA8YWxzYV9jYXJkLnBjaS0wMDAwXzA0XzAx
LjA+Cgltb2R1bGU6IDQKCXByb3BlcnRpZXM6CgkJYWxzYS5yZXNvbHV0aW9uX2JpdHMgPSAi
MTYiCgkJZGV2aWNlLmFwaSA9ICJhbHNhIgoJCWRldmljZS5jbGFzcyA9ICJzb3VuZCIKCQlh
bHNhLmNsYXNzID0gImdlbmVyaWMiCgkJYWxzYS5zdWJjbGFzcyA9ICJnZW5lcmljLW1peCIK
CQlhbHNhLm5hbWUgPSAiQUxDNjYwIEFuYWxvZyIKCQlhbHNhLmlkID0gIkFMQzY2MCBBbmFs
b2ciCgkJYWxzYS5zdWJkZXZpY2UgPSAiMCIKCQlhbHNhLnN1YmRldmljZV9uYW1lID0gInN1
YmRldmljZSAjMCIKCQlhbHNhLmRldmljZSA9ICIwIgoJCWFsc2EuY2FyZCA9ICIwIgoJCWFs
c2EuY2FyZF9uYW1lID0gIkhEQSBWSUEgVlQ4Mnh4IgoJCWFsc2EubG9uZ19jYXJkX25hbWUg
PSAiSERBIFZJQSBWVDgyeHggYXQgMHhmYmZmYzAwMCBpcnEgNjciCgkJYWxzYS5kcml2ZXJf
bmFtZSA9ICJzbmRfaGRhX2ludGVsIgoJCWRldmljZS5idXNfcGF0aCA9ICJwY2ktMDAwMDow
NDowMS4wIgoJCXN5c2ZzLnBhdGggPSAiL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjEz
LjAvMDAwMDowNDowMS4wL3NvdW5kL2NhcmQwIgoJCWRldmljZS5idXMgPSAicGNpIgoJCWRl
dmljZS52ZW5kb3IuaWQgPSAiMTEwNiIKCQlkZXZpY2UudmVuZG9yLm5hbWUgPSAiVklBIFRl
Y2hub2xvZ2llcywgSW5jLiIKCQlkZXZpY2UucHJvZHVjdC5uYW1lID0gIlZUODIzN0EvVlQ4
MjUxIEhEQSBDb250cm9sbGVyIgoJCWRldmljZS5zdHJpbmcgPSAiZnJvbnQ6MCIKCQlkZXZp
Y2UuYnVmZmVyaW5nLmJ1ZmZlcl9zaXplID0gIjM4NDAwMCIKCQlkZXZpY2UuYnVmZmVyaW5n
LmZyYWdtZW50X3NpemUgPSAiMTkyMDAwIgoJCWRldmljZS5hY2Nlc3NfbW9kZSA9ICJtbWFw
K3RpbWVyIgoJCWRldmljZS5wcm9maWxlLm5hbWUgPSAiYW5hbG9nLXN0ZXJlbyIKCQlkZXZp
Y2UucHJvZmlsZS5kZXNjcmlwdGlvbiA9ICJBbmFsb2cgU3RlcmVvIgoJCWRldmljZS5kZXNj
cmlwdGlvbiA9ICJWVDgyMzdBL1ZUODI1MSBIREEgQ29udHJvbGxlciBBbmFsb2cgU3RlcmVv
IgoJCWFsc2EubWl4ZXJfbmFtZSA9ICJSZWFsdGVrIEFMQzY2MCIKCQlhbHNhLmNvbXBvbmVu
dHMgPSAiSERBOjEwZWMwODYxLDEwNDNjNjAzLDAwMTAwMzQwIgoJCW1vZHVsZS11ZGV2LWRl
dGVjdC5kaXNjb3ZlcmVkID0gIjEiCgkJZGV2aWNlLmljb25fbmFtZSA9ICJhdWRpby1jYXJk
LXBjaSIKMiBzb3VyY2UocykgYXZhaWxhYmxlLgogICAgaW5kZXg6IDAKCW5hbWU6IDxhbHNh
X291dHB1dC5wY2ktMDAwMF8wNF8wMS4wLmFuYWxvZy1zdGVyZW8ubW9uaXRvcj4KCWRyaXZl
cjogPG1vZHVsZS1hbHNhLWNhcmQuYz4KCWZsYWdzOiBERUNJQkVMX1ZPTFVNRSBMQVRFTkNZ
IERZTkFNSUNfTEFURU5DWQoJc3RhdGU6IFJVTk5JTkcKCXN1c3BlbmQgY2F1c2U6IAoJcHJp
b3JpdHk6IDEwNTAKCXZvbHVtZTogMDogMTAwJSAxOiAxMDAlCgkgICAgICAgIDA6IDAuMDAg
ZEIgMTogMC4wMCBkQgoJICAgICAgICBiYWxhbmNlIDAuMDAKCWJhc2Ugdm9sdW1lOiAxMDAl
CgkgICAgICAgICAgICAgMC4wMCBkQgoJdm9sdW1lIHN0ZXBzOiA2NTUzNwoJbXV0ZWQ6IG5v
CgljdXJyZW50IGxhdGVuY3k6IDAuMDAgbXMKCW1heCByZXdpbmQ6IDM3NSBLaUIKCXNhbXBs
ZSBzcGVjOiBzMTZsZSAyY2ggNDgwMDBIegoJY2hhbm5lbCBtYXA6IGZyb250LWxlZnQsZnJv
bnQtcmlnaHQKCSAgICAgICAgICAgICBTdGVyZW8KCXVzZWQgYnk6IDMKCWxpbmtlZCBieTog
MwoJY29uZmlndXJlZCBsYXRlbmN5OiAyMC4wMCBtczsgcmFuZ2UgaXMgMC41MCAuLiAyMDAw
LjAwIG1zCgltb25pdG9yX29mOiAwCgljYXJkOiAwIDxhbHNhX2NhcmQucGNpLTAwMDBfMDRf
MDEuMD4KCW1vZHVsZTogNAoJcHJvcGVydGllczoKCQlkZXZpY2UuZGVzY3JpcHRpb24gPSAi
TW9uaXRvciBvZiBWVDgyMzdBL1ZUODI1MSBIREEgQ29udHJvbGxlciBBbmFsb2cgU3RlcmVv
IgoJCWRldmljZS5jbGFzcyA9ICJtb25pdG9yIgoJCWFsc2EuY2FyZCA9ICIwIgoJCWFsc2Eu
Y2FyZF9uYW1lID0gIkhEQSBWSUEgVlQ4Mnh4IgoJCWFsc2EubG9uZ19jYXJkX25hbWUgPSAi
SERBIFZJQSBWVDgyeHggYXQgMHhmYmZmYzAwMCBpcnEgNjciCgkJYWxzYS5kcml2ZXJfbmFt
ZSA9ICJzbmRfaGRhX2ludGVsIgoJCWRldmljZS5idXNfcGF0aCA9ICJwY2ktMDAwMDowNDow
MS4wIgoJCXN5c2ZzLnBhdGggPSAiL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjEzLjAv
MDAwMDowNDowMS4wL3NvdW5kL2NhcmQwIgoJCWRldmljZS5idXMgPSAicGNpIgoJCWRldmlj
ZS52ZW5kb3IuaWQgPSAiMTEwNiIKCQlkZXZpY2UudmVuZG9yLm5hbWUgPSAiVklBIFRlY2hu
b2xvZ2llcywgSW5jLiIKCQlkZXZpY2UucHJvZHVjdC5uYW1lID0gIlZUODIzN0EvVlQ4MjUx
IEhEQSBDb250cm9sbGVyIgoJCWRldmljZS5zdHJpbmcgPSAiMCIKCQltb2R1bGUtdWRldi1k
ZXRlY3QuZGlzY292ZXJlZCA9ICIxIgoJCWRldmljZS5pY29uX25hbWUgPSAiYXVkaW8tY2Fy
ZC1wY2kiCiAgKiBpbmRleDogMQoJbmFtZTogPGFsc2FfaW5wdXQucGNpLTAwMDBfMDRfMDEu
MC5hbmFsb2ctc3RlcmVvPgoJZHJpdmVyOiA8bW9kdWxlLWFsc2EtY2FyZC5jPgoJZmxhZ3M6
IEhBUkRXQVJFIEhXX01VVEVfQ1RSTCBIV19WT0xVTUVfQ1RSTCBERUNJQkVMX1ZPTFVNRSBM
QVRFTkNZIERZTkFNSUNfTEFURU5DWQoJc3RhdGU6IFJVTk5JTkcKCXN1c3BlbmQgY2F1c2U6
IAoJcHJpb3JpdHk6IDkwNTkKCXZvbHVtZTogMDogIDUwJSAxOiAgNTAlCgkgICAgICAgIDA6
IC0xOC4wMCBkQiAxOiAtMTguMDAgZEIKCSAgICAgICAgYmFsYW5jZSAwLjAwCgliYXNlIHZv
bHVtZTogIDI4JQoJICAgICAgICAgICAgIC0zMy4wMCBkQgoJdm9sdW1lIHN0ZXBzOiA2NTUz
NwoJbXV0ZWQ6IG5vCgljdXJyZW50IGxhdGVuY3k6IDAuMTQgbXMKCW1heCByZXdpbmQ6IDAg
S2lCCglzYW1wbGUgc3BlYzogczE2bGUgMmNoIDQ4MDAwSHoKCWNoYW5uZWwgbWFwOiBmcm9u
dC1sZWZ0LGZyb250LXJpZ2h0CgkgICAgICAgICAgICAgU3RlcmVvCgl1c2VkIGJ5OiAxCgls
aW5rZWQgYnk6IDEKCWNvbmZpZ3VyZWQgbGF0ZW5jeTogMjAuMDAgbXM7IHJhbmdlIGlzIDAu
NTAgLi4gMjAwMC4wMCBtcwoJY2FyZDogMCA8YWxzYV9jYXJkLnBjaS0wMDAwXzA0XzAxLjA+
Cgltb2R1bGU6IDQKCXByb3BlcnRpZXM6CgkJYWxzYS5yZXNvbHV0aW9uX2JpdHMgPSAiMTYi
CgkJZGV2aWNlLmFwaSA9ICJhbHNhIgoJCWRldmljZS5jbGFzcyA9ICJzb3VuZCIKCQlhbHNh
LmNsYXNzID0gImdlbmVyaWMiCgkJYWxzYS5zdWJjbGFzcyA9ICJnZW5lcmljLW1peCIKCQlh
bHNhLm5hbWUgPSAiQUxDNjYwIEFuYWxvZyIKCQlhbHNhLmlkID0gIkFMQzY2MCBBbmFsb2ci
CgkJYWxzYS5zdWJkZXZpY2UgPSAiMCIKCQlhbHNhLnN1YmRldmljZV9uYW1lID0gInN1YmRl
dmljZSAjMCIKCQlhbHNhLmRldmljZSA9ICIwIgoJCWFsc2EuY2FyZCA9ICIwIgoJCWFsc2Eu
Y2FyZF9uYW1lID0gIkhEQSBWSUEgVlQ4Mnh4IgoJCWFsc2EubG9uZ19jYXJkX25hbWUgPSAi
SERBIFZJQSBWVDgyeHggYXQgMHhmYmZmYzAwMCBpcnEgNjciCgkJYWxzYS5kcml2ZXJfbmFt
ZSA9ICJzbmRfaGRhX2ludGVsIgoJCWRldmljZS5idXNfcGF0aCA9ICJwY2ktMDAwMDowNDow
MS4wIgoJCXN5c2ZzLnBhdGggPSAiL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjEzLjAv
MDAwMDowNDowMS4wL3NvdW5kL2NhcmQwIgoJCWRldmljZS5idXMgPSAicGNpIgoJCWRldmlj
ZS52ZW5kb3IuaWQgPSAiMTEwNiIKCQlkZXZpY2UudmVuZG9yLm5hbWUgPSAiVklBIFRlY2hu
b2xvZ2llcywgSW5jLiIKCQlkZXZpY2UucHJvZHVjdC5uYW1lID0gIlZUODIzN0EvVlQ4MjUx
IEhEQSBDb250cm9sbGVyIgoJCWRldmljZS5zdHJpbmcgPSAiZnJvbnQ6MCIKCQlkZXZpY2Uu
YnVmZmVyaW5nLmJ1ZmZlcl9zaXplID0gIjM4NDAwMCIKCQlkZXZpY2UuYnVmZmVyaW5nLmZy
YWdtZW50X3NpemUgPSAiMTkyMDAwIgoJCWRldmljZS5hY2Nlc3NfbW9kZSA9ICJtbWFwK3Rp
bWVyIgoJCWRldmljZS5wcm9maWxlLm5hbWUgPSAiYW5hbG9nLXN0ZXJlbyIKCQlkZXZpY2Uu
cHJvZmlsZS5kZXNjcmlwdGlvbiA9ICJBbmFsb2cgU3RlcmVvIgoJCWRldmljZS5kZXNjcmlw
dGlvbiA9ICJWVDgyMzdBL1ZUODI1MSBIREEgQ29udHJvbGxlciBBbmFsb2cgU3RlcmVvIgoJ
CWFsc2EubWl4ZXJfbmFtZSA9ICJSZWFsdGVrIEFMQzY2MCIKCQlhbHNhLmNvbXBvbmVudHMg
PSAiSERBOjEwZWMwODYxLDEwNDNjNjAzLDAwMTAwMzQwIgoJCW1vZHVsZS11ZGV2LWRldGVj
dC5kaXNjb3ZlcmVkID0gIjEiCgkJZGV2aWNlLmljb25fbmFtZSA9ICJhdWRpby1jYXJkLXBj
aSIKCXBvcnRzOgoJCWFuYWxvZy1pbnB1dC1taWNyb3Bob25lLWZyb250OiBGcm9udCBNaWNy
b3Bob25lIChwcmlvcml0eSA4NTAwKQoJCWFuYWxvZy1pbnB1dC1taWNyb3Bob25lLXJlYXI6
IFJlYXIgTWljcm9waG9uZSAocHJpb3JpdHkgODIwMCkKCQlhbmFsb2ctaW5wdXQtbGluZWlu
OiBBbmFsb2cgTGluZS1JbiAocHJpb3JpdHkgODEwMCkKCWFjdGl2ZSBwb3J0OiA8YW5hbG9n
LWlucHV0LW1pY3JvcGhvbmUtZnJvbnQ+CjggY2xpZW50KHMpIGxvZ2dlZCBpbi4KICAgIGlu
ZGV4OiAwCglkcml2ZXI6IDxtb2R1bGUtY29uc29sZS1raXQuYz4KCW93bmVyIG1vZHVsZTog
MTUKCXByb3BlcnRpZXM6CgkJYXBwbGljYXRpb24ubmFtZSA9ICJDb25zb2xlS2l0IFNlc3Np
b24gL29yZy9mcmVlZGVza3RvcC9Db25zb2xlS2l0L1Nlc3Npb24xIgoJCWNvbnNvbGUta2l0
LnNlc3Npb24gPSAiL29yZy9mcmVlZGVza3RvcC9Db25zb2xlS2l0L1Nlc3Npb24xIgogICAg
aW5kZXg6IDEKCWRyaXZlcjogPHByb3RvY29sLW5hdGl2ZS5jPgoJb3duZXIgbW9kdWxlOiA4
Cglwcm9wZXJ0aWVzOgoJCWFwcGxpY2F0aW9uLm5hbWUgPSAiTXVzaWMgUGxheWVyIERhZW1v
biIKCQluYXRpdmUtcHJvdG9jb2wucGVlciA9ICJVTklYIHNvY2tldCBjbGllbnQiCgkJbmF0
aXZlLXByb3RvY29sLnZlcnNpb24gPSAiMjMiCgkJbWVkaWEucm9sZSA9ICJtdXNpYyIKCQlh
cHBsaWNhdGlvbi5wcm9jZXNzLmlkID0gIjE1NDIiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy51
c2VyID0gInBhdWxsaWsiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5ob3N0ID0gImxvY2FsaG9z
dCIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLmJpbmFyeSA9ICJtcGQiCgkJYXBwbGljYXRpb24u
bGFuZ3VhZ2UgPSAiQyIKCQl3aW5kb3cueDExLmRpc3BsYXkgPSAiOjAuMCIKCQlhcHBsaWNh
dGlvbi5wcm9jZXNzLm1hY2hpbmVfaWQgPSAiMzQ5YWYyNjFjYmI4ZDhiNzA2NmQ4ZGFkMDAw
MDA1NTQiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5zZXNzaW9uX2lkID0gIjM0OWFmMjYxY2Ji
OGQ4YjcwNjZkOGRhZDAwMDAwNTU0LTEzMjA5NDI0NjMuNDc0MzM3LTE1MzA4ODgxOTAiCiAg
ICBpbmRleDogMgoJZHJpdmVyOiA8bW9kdWxlLWNvbnNvbGUta2l0LmM+Cglvd25lciBtb2R1
bGU6IDE1Cglwcm9wZXJ0aWVzOgoJCWFwcGxpY2F0aW9uLm5hbWUgPSAiQ29uc29sZUtpdCBT
ZXNzaW9uIC9vcmcvZnJlZWRlc2t0b3AvQ29uc29sZUtpdC9TZXNzaW9uMiIKCQljb25zb2xl
LWtpdC5zZXNzaW9uID0gIi9vcmcvZnJlZWRlc2t0b3AvQ29uc29sZUtpdC9TZXNzaW9uMiIK
ICAgIGluZGV4OiAzCglkcml2ZXI6IDxwcm90b2NvbC1uYXRpdmUuYz4KCW93bmVyIG1vZHVs
ZTogOAoJcHJvcGVydGllczoKCQlhcHBsaWNhdGlvbi5uYW1lID0gIlB1bHNlQXVkaW8gVm9s
dW1lIENvbnRyb2wiCgkJbmF0aXZlLXByb3RvY29sLnBlZXIgPSAiVU5JWCBzb2NrZXQgY2xp
ZW50IgoJCW5hdGl2ZS1wcm90b2NvbC52ZXJzaW9uID0gIjIzIgoJCWFwcGxpY2F0aW9uLmlk
ID0gIm9yZy5QdWxzZUF1ZGlvLnBhdnVjb250cm9sIgoJCWFwcGxpY2F0aW9uLmljb25fbmFt
ZSA9ICJhdWRpby1jYXJkIgoJCWFwcGxpY2F0aW9uLnZlcnNpb24gPSAiMS4wIgoJCWFwcGxp
Y2F0aW9uLnByb2Nlc3MuaWQgPSAiMTU1NSIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLnVzZXIg
PSAicGF1bGxpayIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLmhvc3QgPSAibG9jYWxob3N0IgoJ
CWFwcGxpY2F0aW9uLnByb2Nlc3MuYmluYXJ5ID0gInBhdnVjb250cm9sIgoJCWFwcGxpY2F0
aW9uLmxhbmd1YWdlID0gImVuX1VTLlVURi04IgoJCXdpbmRvdy54MTEuZGlzcGxheSA9ICI6
MC4wIgoJCWFwcGxpY2F0aW9uLnByb2Nlc3MubWFjaGluZV9pZCA9ICIzNDlhZjI2MWNiYjhk
OGI3MDY2ZDhkYWQwMDAwMDU1NCIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLnNlc3Npb25faWQg
PSAiMzQ5YWYyNjFjYmI4ZDhiNzA2NmQ4ZGFkMDAwMDA1NTQtMTMyMDk0MjQ2My40NzQzMzct
MTUzMDg4ODE5MCIKICAgIGluZGV4OiA2Cglkcml2ZXI6IDxwcm90b2NvbC1uYXRpdmUuYz4K
CW93bmVyIG1vZHVsZTogOAoJcHJvcGVydGllczoKCQlhcHBsaWNhdGlvbi5uYW1lID0gImxp
YnBob25vbiIKCQluYXRpdmUtcHJvdG9jb2wucGVlciA9ICJVTklYIHNvY2tldCBjbGllbnQi
CgkJbmF0aXZlLXByb3RvY29sLnZlcnNpb24gPSAiMjMiCgkJbWVkaWEucm9sZSA9ICJtdXNp
YyIKCQlwaG9ub24uc3RyZWFtaWQgPSAiezI3NDhkZDM1LWNmZDItNGVmZi1hOWY4LTVkYjk3
NDU2ZWVjNX0iCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5pZCA9ICIxNTUzIgoJCWFwcGxpY2F0
aW9uLnByb2Nlc3MudXNlciA9ICJwYXVsbGlrIgoJCWFwcGxpY2F0aW9uLnByb2Nlc3MuaG9z
dCA9ICJsb2NhbGhvc3QiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5iaW5hcnkgPSAieWFwYW4i
CgkJYXBwbGljYXRpb24ubGFuZ3VhZ2UgPSAiZW5fVVMuVVRGLTgiCgkJd2luZG93LngxMS5k
aXNwbGF5ID0gIjowLjAiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5tYWNoaW5lX2lkID0gIjM0
OWFmMjYxY2JiOGQ4YjcwNjZkOGRhZDAwMDAwNTU0IgoJCWFwcGxpY2F0aW9uLnByb2Nlc3Mu
c2Vzc2lvbl9pZCA9ICIzNDlhZjI2MWNiYjhkOGI3MDY2ZDhkYWQwMDAwMDU1NC0xMzIwOTQy
NDYzLjQ3NDMzNy0xNTMwODg4MTkwIgoJCWFwcGxpY2F0aW9uLmljb25fbmFtZSA9ICIvdXNy
L3NoYXJlL3lhcGFuL3lhcGFuLnN2ZyIKICAgIGluZGV4OiAxMQoJZHJpdmVyOiA8cHJvdG9j
b2wtbmF0aXZlLmM+Cglvd25lciBtb2R1bGU6IDgKCXByb3BlcnRpZXM6CgkJYXBwbGljYXRp
b24ubmFtZSA9ICJZYXBhbiIKCQluYXRpdmUtcHJvdG9jb2wucGVlciA9ICJVTklYIHNvY2tl
dCBjbGllbnQiCgkJbmF0aXZlLXByb3RvY29sLnZlcnNpb24gPSAiMjMiCgkJbWVkaWEucm9s
ZSA9ICJtdXNpYyIKCQlwaG9ub24uc3RyZWFtaWQgPSAiezI3NDhkZDM1LWNmZDItNGVmZi1h
OWY4LTVkYjk3NDU2ZWVjNX0iCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5pZCA9ICIxNTUzIgoJ
CWFwcGxpY2F0aW9uLnByb2Nlc3MudXNlciA9ICJwYXVsbGlrIgoJCWFwcGxpY2F0aW9uLnBy
b2Nlc3MuaG9zdCA9ICJsb2NhbGhvc3QiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5iaW5hcnkg
PSAieWFwYW4iCgkJYXBwbGljYXRpb24ubGFuZ3VhZ2UgPSAiZW5fVVMuVVRGLTgiCgkJd2lu
ZG93LngxMS5kaXNwbGF5ID0gIjowLjAiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5tYWNoaW5l
X2lkID0gIjM0OWFmMjYxY2JiOGQ4YjcwNjZkOGRhZDAwMDAwNTU0IgoJCWFwcGxpY2F0aW9u
LnByb2Nlc3Muc2Vzc2lvbl9pZCA9ICIzNDlhZjI2MWNiYjhkOGI3MDY2ZDhkYWQwMDAwMDU1
NC0xMzIwOTQyNDYzLjQ3NDMzNy0xNTMwODg4MTkwIgoJCWFwcGxpY2F0aW9uLmljb25fbmFt
ZSA9ICIvdXNyL3NoYXJlL3lhcGFuL3lhcGFuLnN2ZyIKICAgIGluZGV4OiAxMwoJZHJpdmVy
OiA8cHJvdG9jb2wtbmF0aXZlLmM+Cglvd25lciBtb2R1bGU6IDgKCXByb3BlcnRpZXM6CgkJ
YXBwbGljYXRpb24ubmFtZSA9ICJsaWJjYW5iZXJyYSIKCQluYXRpdmUtcHJvdG9jb2wucGVl
ciA9ICJVTklYIHNvY2tldCBjbGllbnQiCgkJbmF0aXZlLXByb3RvY29sLnZlcnNpb24gPSAi
MjMiCgkJYXBwbGljYXRpb24udmVyc2lvbiA9ICIwLjI4IgoJCWFwcGxpY2F0aW9uLmlkID0g
Im9yZy5mcmVlZGVza3RvcC5saWJjYW5iZXJyYSIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLmlk
ID0gIjE0ODYiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy51c2VyID0gInBhdWxsaWsiCgkJYXBw
bGljYXRpb24ucHJvY2Vzcy5ob3N0ID0gImxvY2FsaG9zdCIKCQlhcHBsaWNhdGlvbi5wcm9j
ZXNzLmJpbmFyeSA9ICJ0aHVuZGVyYmlyZC1iaW4iCgkJYXBwbGljYXRpb24ubGFuZ3VhZ2Ug
PSAiZW5fVVMuVVRGLTgiCgkJd2luZG93LngxMS5kaXNwbGF5ID0gIjowLjAiCgkJYXBwbGlj
YXRpb24ucHJvY2Vzcy5tYWNoaW5lX2lkID0gIjM0OWFmMjYxY2JiOGQ4YjcwNjZkOGRhZDAw
MDAwNTU0IgoJCWFwcGxpY2F0aW9uLnByb2Nlc3Muc2Vzc2lvbl9pZCA9ICIzNDlhZjI2MWNi
YjhkOGI3MDY2ZDhkYWQwMDAwMDU1NC0xMzIwOTQyNDYzLjQ3NDMzNy0xNTMwODg4MTkwIgog
ICAgaW5kZXg6IDE0Cglkcml2ZXI6IDxjbGkuYz4KCW93bmVyIG1vZHVsZTogMjEKCXByb3Bl
cnRpZXM6CgkJYXBwbGljYXRpb24ubmFtZSA9ICJVTklYIHNvY2tldCBjbGllbnQiCjEgY2Fy
ZChzKSBhdmFpbGFibGUuCiAgICBpbmRleDogMAoJbmFtZTogPGFsc2FfY2FyZC5wY2ktMDAw
MF8wNF8wMS4wPgoJZHJpdmVyOiA8bW9kdWxlLWFsc2EtY2FyZC5jPgoJb3duZXIgbW9kdWxl
OiA0Cglwcm9wZXJ0aWVzOgoJCWFsc2EuY2FyZCA9ICIwIgoJCWFsc2EuY2FyZF9uYW1lID0g
IkhEQSBWSUEgVlQ4Mnh4IgoJCWFsc2EubG9uZ19jYXJkX25hbWUgPSAiSERBIFZJQSBWVDgy
eHggYXQgMHhmYmZmYzAwMCBpcnEgNjciCgkJYWxzYS5kcml2ZXJfbmFtZSA9ICJzbmRfaGRh
X2ludGVsIgoJCWRldmljZS5idXNfcGF0aCA9ICJwY2ktMDAwMDowNDowMS4wIgoJCXN5c2Zz
LnBhdGggPSAiL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjEzLjAvMDAwMDowNDowMS4w
L3NvdW5kL2NhcmQwIgoJCWRldmljZS5idXMgPSAicGNpIgoJCWRldmljZS52ZW5kb3IuaWQg
PSAiMTEwNiIKCQlkZXZpY2UudmVuZG9yLm5hbWUgPSAiVklBIFRlY2hub2xvZ2llcywgSW5j
LiIKCQlkZXZpY2UucHJvZHVjdC5uYW1lID0gIlZUODIzN0EvVlQ4MjUxIEhEQSBDb250cm9s
bGVyIgoJCWRldmljZS5zdHJpbmcgPSAiMCIKCQlkZXZpY2UuZGVzY3JpcHRpb24gPSAiVlQ4
MjM3QS9WVDgyNTEgSERBIENvbnRyb2xsZXIiCgkJbW9kdWxlLXVkZXYtZGV0ZWN0LmRpc2Nv
dmVyZWQgPSAiMSIKCQlkZXZpY2UuaWNvbl9uYW1lID0gImF1ZGlvLWNhcmQtcGNpIgoJcHJv
ZmlsZXM6CgkJb3V0cHV0OmFuYWxvZy1zdGVyZW86IEFuYWxvZyBTdGVyZW8gT3V0cHV0IChw
cmlvcml0eSA2MDAwKQoJCW91dHB1dDphbmFsb2ctc3RlcmVvK2lucHV0OmFuYWxvZy1zdGVy
ZW86IEFuYWxvZyBTdGVyZW8gRHVwbGV4IChwcmlvcml0eSA2MDYwKQoJCW91dHB1dDphbmFs
b2ctc3Vycm91bmQtNDA6IEFuYWxvZyBTdXJyb3VuZCA0LjAgT3V0cHV0IChwcmlvcml0eSA3
MDApCgkJb3V0cHV0OmFuYWxvZy1zdXJyb3VuZC00MCtpbnB1dDphbmFsb2ctc3RlcmVvOiBB
bmFsb2cgU3Vycm91bmQgNC4wIE91dHB1dCArIEFuYWxvZyBTdGVyZW8gSW5wdXQgKHByaW9y
aXR5IDc2MCkKCQlvdXRwdXQ6YW5hbG9nLXN1cnJvdW5kLTQxOiBBbmFsb2cgU3Vycm91bmQg
NC4xIE91dHB1dCAocHJpb3JpdHkgODAwKQoJCW91dHB1dDphbmFsb2ctc3Vycm91bmQtNDEr
aW5wdXQ6YW5hbG9nLXN0ZXJlbzogQW5hbG9nIFN1cnJvdW5kIDQuMSBPdXRwdXQgKyBBbmFs
b2cgU3RlcmVvIElucHV0IChwcmlvcml0eSA4NjApCgkJb3V0cHV0OmFuYWxvZy1zdXJyb3Vu
ZC01MDogQW5hbG9nIFN1cnJvdW5kIDUuMCBPdXRwdXQgKHByaW9yaXR5IDcwMCkKCQlvdXRw
dXQ6YW5hbG9nLXN1cnJvdW5kLTUwK2lucHV0OmFuYWxvZy1zdGVyZW86IEFuYWxvZyBTdXJy
b3VuZCA1LjAgT3V0cHV0ICsgQW5hbG9nIFN0ZXJlbyBJbnB1dCAocHJpb3JpdHkgNzYwKQoJ
CW91dHB1dDphbmFsb2ctc3Vycm91bmQtNTE6IEFuYWxvZyBTdXJyb3VuZCA1LjEgT3V0cHV0
IChwcmlvcml0eSA4MDApCgkJb3V0cHV0OmFuYWxvZy1zdXJyb3VuZC01MStpbnB1dDphbmFs
b2ctc3RlcmVvOiBBbmFsb2cgU3Vycm91bmQgNS4xIE91dHB1dCArIEFuYWxvZyBTdGVyZW8g
SW5wdXQgKHByaW9yaXR5IDg2MCkKCQlvdXRwdXQ6aWVjOTU4LXN0ZXJlbzogRGlnaXRhbCBT
dGVyZW8gKElFQzk1OCkgT3V0cHV0IChwcmlvcml0eSA1NTAwKQoJCW91dHB1dDppZWM5NTgt
c3RlcmVvK2lucHV0OmFuYWxvZy1zdGVyZW86IERpZ2l0YWwgU3RlcmVvIChJRUM5NTgpIE91
dHB1dCArIEFuYWxvZyBTdGVyZW8gSW5wdXQgKHByaW9yaXR5IDU1NjApCgkJaW5wdXQ6YW5h
bG9nLXN0ZXJlbzogQW5hbG9nIFN0ZXJlbyBJbnB1dCAocHJpb3JpdHkgNjApCgkJb2ZmOiBP
ZmYgKHByaW9yaXR5IDApCglhY3RpdmUgcHJvZmlsZTogPG91dHB1dDphbmFsb2ctc3RlcmVv
K2lucHV0OmFuYWxvZy1zdGVyZW8+CglzaW5rczoKCQlhbHNhX291dHB1dC5wY2ktMDAwMF8w
NF8wMS4wLmFuYWxvZy1zdGVyZW8vIzA6IFZUODIzN0EvVlQ4MjUxIEhEQSBDb250cm9sbGVy
IEFuYWxvZyBTdGVyZW8KCXNvdXJjZXM6CgkJYWxzYV9vdXRwdXQucGNpLTAwMDBfMDRfMDEu
MC5hbmFsb2ctc3RlcmVvLm1vbml0b3IvIzA6IE1vbml0b3Igb2YgVlQ4MjM3QS9WVDgyNTEg
SERBIENvbnRyb2xsZXIgQW5hbG9nIFN0ZXJlbwoJCWFsc2FfaW5wdXQucGNpLTAwMDBfMDRf
MDEuMC5hbmFsb2ctc3RlcmVvLyMxOiBWVDgyMzdBL1ZUODI1MSBIREEgQ29udHJvbGxlciBB
bmFsb2cgU3RlcmVvCjIgc2luayBpbnB1dChzKSBhdmFpbGFibGUuCiAgICBpbmRleDogMAoJ
ZHJpdmVyOiA8cHJvdG9jb2wtbmF0aXZlLmM+CglmbGFnczogCglzdGF0ZTogUlVOTklORwoJ
c2luazogMCA8YWxzYV9vdXRwdXQucGNpLTAwMDBfMDRfMDEuMC5hbmFsb2ctc3RlcmVvPgoJ
dm9sdW1lOiAwOiAgOTUlIDE6ICA5NSUKCSAgICAgICAgMDogLTEuMjAgZEIgMTogLTEuMjAg
ZEIKCSAgICAgICAgYmFsYW5jZSAwLjAwCgltdXRlZDogbm8KCWN1cnJlbnQgbGF0ZW5jeTog
MjM5Ljk3IG1zCglyZXF1ZXN0ZWQgbGF0ZW5jeTogMjEwLjAwIG1zCglzYW1wbGUgc3BlYzog
czE2bGUgMmNoIDQ0MTAwSHoKCWNoYW5uZWwgbWFwOiBmcm9udC1sZWZ0LGZyb250LXJpZ2h0
CgkgICAgICAgICAgICAgU3RlcmVvCglyZXNhbXBsZSBtZXRob2Q6IHNwZWV4LWZsb2F0LTAK
CW1vZHVsZTogOAoJY2xpZW50OiAxIDxNdXNpYyBQbGF5ZXIgRGFlbW9uPgoJcHJvcGVydGll
czoKCQltZWRpYS5uYW1lID0gIlNvdW5kIENhcmQiCgkJYXBwbGljYXRpb24ubmFtZSA9ICJN
dXNpYyBQbGF5ZXIgRGFlbW9uIgoJCW5hdGl2ZS1wcm90b2NvbC5wZWVyID0gIlVOSVggc29j
a2V0IGNsaWVudCIKCQluYXRpdmUtcHJvdG9jb2wudmVyc2lvbiA9ICIyMyIKCQltZWRpYS5y
b2xlID0gIm11c2ljIgoJCWFwcGxpY2F0aW9uLnByb2Nlc3MuaWQgPSAiMTU0MiIKCQlhcHBs
aWNhdGlvbi5wcm9jZXNzLnVzZXIgPSAicGF1bGxpayIKCQlhcHBsaWNhdGlvbi5wcm9jZXNz
Lmhvc3QgPSAibG9jYWxob3N0IgoJCWFwcGxpY2F0aW9uLnByb2Nlc3MuYmluYXJ5ID0gIm1w
ZCIKCQlhcHBsaWNhdGlvbi5sYW5ndWFnZSA9ICJDIgoJCXdpbmRvdy54MTEuZGlzcGxheSA9
ICI6MC4wIgoJCWFwcGxpY2F0aW9uLnByb2Nlc3MubWFjaGluZV9pZCA9ICIzNDlhZjI2MWNi
YjhkOGI3MDY2ZDhkYWQwMDAwMDU1NCIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLnNlc3Npb25f
aWQgPSAiMzQ5YWYyNjFjYmI4ZDhiNzA2NmQ4ZGFkMDAwMDA1NTQtMTMyMDk0MjQ2My40NzQz
MzctMTUzMDg4ODE5MCIKCQltb2R1bGUtc3RyZWFtLXJlc3RvcmUuaWQgPSAic2luay1pbnB1
dC1ieS1tZWRpYS1yb2xlOm11c2ljIgogICAgaW5kZXg6IDQKCWRyaXZlcjogPHByb3RvY29s
LW5hdGl2ZS5jPgoJZmxhZ3M6IFNUQVJUX0NPUktFRCAKCXN0YXRlOiBDT1JLRUQKCXNpbms6
IDAgPGFsc2Ffb3V0cHV0LnBjaS0wMDAwXzA0XzAxLjAuYW5hbG9nLXN0ZXJlbz4KCXZvbHVt
ZTogMDogIDk1JQoJICAgICAgICAwOiAtMS4yMCBkQgoJICAgICAgICBiYWxhbmNlIDAuMDAK
CW11dGVkOiBubwoJY3VycmVudCBsYXRlbmN5OiAwLjAwIG1zCglyZXF1ZXN0ZWQgbGF0ZW5j
eTogODkuODAgbXMKCXNhbXBsZSBzcGVjOiBmbG9hdDMybGUgMWNoIDIyMDUwSHoKCWNoYW5u
ZWwgbWFwOiBtb25vCgkgICAgICAgICAgICAgTW9ubwoJcmVzYW1wbGUgbWV0aG9kOiBzcGVl
eC1mbG9hdC0wCgltb2R1bGU6IDgKCWNsaWVudDogMTEgPFlhcGFuPgoJcHJvcGVydGllczoK
CQltZWRpYS5uYW1lID0gIlBsYXliYWNrIFN0cmVhbSIKCQlhcHBsaWNhdGlvbi5uYW1lID0g
IllhcGFuIgoJCW5hdGl2ZS1wcm90b2NvbC5wZWVyID0gIlVOSVggc29ja2V0IGNsaWVudCIK
CQluYXRpdmUtcHJvdG9jb2wudmVyc2lvbiA9ICIyMyIKCQltZWRpYS5yb2xlID0gIm11c2lj
IgoJCXBob25vbi5zdHJlYW1pZCA9ICJ7Mjc0OGRkMzUtY2ZkMi00ZWZmLWE5ZjgtNWRiOTc0
NTZlZWM1fSIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLmlkID0gIjE1NTMiCgkJYXBwbGljYXRp
b24ucHJvY2Vzcy51c2VyID0gInBhdWxsaWsiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5ob3N0
ID0gImxvY2FsaG9zdCIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLmJpbmFyeSA9ICJ5YXBhbiIK
CQlhcHBsaWNhdGlvbi5sYW5ndWFnZSA9ICJlbl9VUy5VVEYtOCIKCQl3aW5kb3cueDExLmRp
c3BsYXkgPSAiOjAuMCIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLm1hY2hpbmVfaWQgPSAiMzQ5
YWYyNjFjYmI4ZDhiNzA2NmQ4ZGFkMDAwMDA1NTQiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5z
ZXNzaW9uX2lkID0gIjM0OWFmMjYxY2JiOGQ4YjcwNjZkOGRhZDAwMDAwNTU0LTEzMjA5NDI0
NjMuNDc0MzM3LTE1MzA4ODgxOTAiCgkJYXBwbGljYXRpb24uaWNvbl9uYW1lID0gIi91c3Iv
c2hhcmUveWFwYW4veWFwYW4uc3ZnIgoJCW1vZHVsZS1zdHJlYW0tcmVzdG9yZS5pZCA9ICJz
aW5rLWlucHV0LWJ5LW1lZGlhLXJvbGU6bXVzaWMiCjQgc291cmNlIG91dHB1dHMocykgYXZh
aWxhYmxlLgogICAgaW5kZXg6IDAKCWRyaXZlcjogPHByb3RvY29sLW5hdGl2ZS5jPgoJZmxh
Z3M6IERPTlRfTU9WRSAKCXN0YXRlOiBSVU5OSU5HCglzb3VyY2U6IDAgPGFsc2Ffb3V0cHV0
LnBjaS0wMDAwXzA0XzAxLjAuYW5hbG9nLXN0ZXJlby5tb25pdG9yPgoJY3VycmVudCBsYXRl
bmN5OiA5LjY0IG1zCglyZXF1ZXN0ZWQgbGF0ZW5jeTogMjAuMDAgbXMKCXNhbXBsZSBzcGVj
OiBmbG9hdDMybGUgMWNoIDI1SHoKCWNoYW5uZWwgbWFwOiBtb25vCgkgICAgICAgICAgICAg
TW9ubwoJcmVzYW1wbGUgbWV0aG9kOiBwZWFrcwoJb3duZXIgbW9kdWxlOiA4CgljbGllbnQ6
IDMgPFB1bHNlQXVkaW8gVm9sdW1lIENvbnRyb2w+Cglwcm9wZXJ0aWVzOgoJCW1lZGlhLm5h
bWUgPSAiUGVhayBkZXRlY3QiCgkJYXBwbGljYXRpb24ubmFtZSA9ICJQdWxzZUF1ZGlvIFZv
bHVtZSBDb250cm9sIgoJCW5hdGl2ZS1wcm90b2NvbC5wZWVyID0gIlVOSVggc29ja2V0IGNs
aWVudCIKCQluYXRpdmUtcHJvdG9jb2wudmVyc2lvbiA9ICIyMyIKCQlhcHBsaWNhdGlvbi5p
ZCA9ICJvcmcuUHVsc2VBdWRpby5wYXZ1Y29udHJvbCIKCQlhcHBsaWNhdGlvbi5pY29uX25h
bWUgPSAiYXVkaW8tY2FyZCIKCQlhcHBsaWNhdGlvbi52ZXJzaW9uID0gIjEuMCIKCQlhcHBs
aWNhdGlvbi5wcm9jZXNzLmlkID0gIjE1NTUiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy51c2Vy
ID0gInBhdWxsaWsiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5ob3N0ID0gImxvY2FsaG9zdCIK
CQlhcHBsaWNhdGlvbi5wcm9jZXNzLmJpbmFyeSA9ICJwYXZ1Y29udHJvbCIKCQlhcHBsaWNh
dGlvbi5sYW5ndWFnZSA9ICJlbl9VUy5VVEYtOCIKCQl3aW5kb3cueDExLmRpc3BsYXkgPSAi
OjAuMCIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLm1hY2hpbmVfaWQgPSAiMzQ5YWYyNjFjYmI4
ZDhiNzA2NmQ4ZGFkMDAwMDA1NTQiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5zZXNzaW9uX2lk
ID0gIjM0OWFmMjYxY2JiOGQ4YjcwNjZkOGRhZDAwMDAwNTU0LTEzMjA5NDI0NjMuNDc0MzM3
LTE1MzA4ODgxOTAiCgkJbW9kdWxlLXN0cmVhbS1yZXN0b3JlLmlkID0gInNvdXJjZS1vdXRw
dXQtYnktYXBwbGljYXRpb24taWQ6b3JnLlB1bHNlQXVkaW8ucGF2dWNvbnRyb2wiCiAgICBp
bmRleDogMQoJZHJpdmVyOiA8cHJvdG9jb2wtbmF0aXZlLmM+CglmbGFnczogRE9OVF9NT1ZF
IAoJc3RhdGU6IFJVTk5JTkcKCXNvdXJjZTogMSA8YWxzYV9pbnB1dC5wY2ktMDAwMF8wNF8w
MS4wLmFuYWxvZy1zdGVyZW8+CgljdXJyZW50IGxhdGVuY3k6IDAuMDAgbXMKCXJlcXVlc3Rl
ZCBsYXRlbmN5OiAyMC4wMCBtcwoJc2FtcGxlIHNwZWM6IGZsb2F0MzJsZSAxY2ggMjVIegoJ
Y2hhbm5lbCBtYXA6IG1vbm8KCSAgICAgICAgICAgICBNb25vCglyZXNhbXBsZSBtZXRob2Q6
IHBlYWtzCglvd25lciBtb2R1bGU6IDgKCWNsaWVudDogMyA8UHVsc2VBdWRpbyBWb2x1bWUg
Q29udHJvbD4KCXByb3BlcnRpZXM6CgkJbWVkaWEubmFtZSA9ICJQZWFrIGRldGVjdCIKCQlh
cHBsaWNhdGlvbi5uYW1lID0gIlB1bHNlQXVkaW8gVm9sdW1lIENvbnRyb2wiCgkJbmF0aXZl
LXByb3RvY29sLnBlZXIgPSAiVU5JWCBzb2NrZXQgY2xpZW50IgoJCW5hdGl2ZS1wcm90b2Nv
bC52ZXJzaW9uID0gIjIzIgoJCWFwcGxpY2F0aW9uLmlkID0gIm9yZy5QdWxzZUF1ZGlvLnBh
dnVjb250cm9sIgoJCWFwcGxpY2F0aW9uLmljb25fbmFtZSA9ICJhdWRpby1jYXJkIgoJCWFw
cGxpY2F0aW9uLnZlcnNpb24gPSAiMS4wIgoJCWFwcGxpY2F0aW9uLnByb2Nlc3MuaWQgPSAi
MTU1NSIKCQlhcHBsaWNhdGlvbi5wcm9jZXNzLnVzZXIgPSAicGF1bGxpayIKCQlhcHBsaWNh
dGlvbi5wcm9jZXNzLmhvc3QgPSAibG9jYWxob3N0IgoJCWFwcGxpY2F0aW9uLnByb2Nlc3Mu
YmluYXJ5ID0gInBhdnVjb250cm9sIgoJCWFwcGxpY2F0aW9uLmxhbmd1YWdlID0gImVuX1VT
LlVURi04IgoJCXdpbmRvdy54MTEuZGlzcGxheSA9ICI6MC4wIgoJCWFwcGxpY2F0aW9uLnBy
b2Nlc3MubWFjaGluZV9pZCA9ICIzNDlhZjI2MWNiYjhkOGI3MDY2ZDhkYWQwMDAwMDU1NCIK
CQlhcHBsaWNhdGlvbi5wcm9jZXNzLnNlc3Npb25faWQgPSAiMzQ5YWYyNjFjYmI4ZDhiNzA2
NmQ4ZGFkMDAwMDA1NTQtMTMyMDk0MjQ2My40NzQzMzctMTUzMDg4ODE5MCIKCQltb2R1bGUt
c3RyZWFtLXJlc3RvcmUuaWQgPSAic291cmNlLW91dHB1dC1ieS1hcHBsaWNhdGlvbi1pZDpv
cmcuUHVsc2VBdWRpby5wYXZ1Y29udHJvbCIKICAgIGluZGV4OiAyCglkcml2ZXI6IDxwcm90
b2NvbC1uYXRpdmUuYz4KCWZsYWdzOiBET05UX01PVkUgCglzdGF0ZTogUlVOTklORwoJc291
cmNlOiAwIDxhbHNhX291dHB1dC5wY2ktMDAwMF8wNF8wMS4wLmFuYWxvZy1zdGVyZW8ubW9u
aXRvcj4KCWN1cnJlbnQgbGF0ZW5jeTogOS42NyBtcwoJcmVxdWVzdGVkIGxhdGVuY3k6IDIw
LjAwIG1zCglzYW1wbGUgc3BlYzogZmxvYXQzMmxlIDFjaCAyNUh6CgljaGFubmVsIG1hcDog
bW9ubwoJICAgICAgICAgICAgIE1vbm8KCXJlc2FtcGxlIG1ldGhvZDogcGVha3MKCW93bmVy
IG1vZHVsZTogOAoJY2xpZW50OiAzIDxQdWxzZUF1ZGlvIFZvbHVtZSBDb250cm9sPgoJZGly
ZWN0IG9uIGlucHV0OiAwCglwcm9wZXJ0aWVzOgoJCW1lZGlhLm5hbWUgPSAiUGVhayBkZXRl
Y3QiCgkJYXBwbGljYXRpb24ubmFtZSA9ICJQdWxzZUF1ZGlvIFZvbHVtZSBDb250cm9sIgoJ
CW5hdGl2ZS1wcm90b2NvbC5wZWVyID0gIlVOSVggc29ja2V0IGNsaWVudCIKCQluYXRpdmUt
cHJvdG9jb2wudmVyc2lvbiA9ICIyMyIKCQlhcHBsaWNhdGlvbi5pZCA9ICJvcmcuUHVsc2VB
dWRpby5wYXZ1Y29udHJvbCIKCQlhcHBsaWNhdGlvbi5pY29uX25hbWUgPSAiYXVkaW8tY2Fy
ZCIKCQlhcHBsaWNhdGlvbi52ZXJzaW9uID0gIjEuMCIKCQlhcHBsaWNhdGlvbi5wcm9jZXNz
LmlkID0gIjE1NTUiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy51c2VyID0gInBhdWxsaWsiCgkJ
YXBwbGljYXRpb24ucHJvY2Vzcy5ob3N0ID0gImxvY2FsaG9zdCIKCQlhcHBsaWNhdGlvbi5w
cm9jZXNzLmJpbmFyeSA9ICJwYXZ1Y29udHJvbCIKCQlhcHBsaWNhdGlvbi5sYW5ndWFnZSA9
ICJlbl9VUy5VVEYtOCIKCQl3aW5kb3cueDExLmRpc3BsYXkgPSAiOjAuMCIKCQlhcHBsaWNh
dGlvbi5wcm9jZXNzLm1hY2hpbmVfaWQgPSAiMzQ5YWYyNjFjYmI4ZDhiNzA2NmQ4ZGFkMDAw
MDA1NTQiCgkJYXBwbGljYXRpb24ucHJvY2Vzcy5zZXNzaW9uX2lkID0gIjM0OWFmMjYxY2Ji
OGQ4YjcwNjZkOGRhZDAwMDAwNTU0LTEzMjA5NDI0NjMuNDc0MzM3LTE1MzA4ODgxOTAiCgkJ
bW9kdWxlLXN0cmVhbS1yZXN0b3JlLmlkID0gInNvdXJjZS1vdXRwdXQtYnktYXBwbGljYXRp
b24taWQ6b3JnLlB1bHNlQXVkaW8ucGF2dWNvbnRyb2wiCiAgICBpbmRleDogNQoJZHJpdmVy
OiA8cHJvdG9jb2wtbmF0aXZlLmM+CglmbGFnczogRE9OVF9NT1ZFIAoJc3RhdGU6IFJVTk5J
TkcKCXNvdXJjZTogMCA8YWxzYV9vdXRwdXQucGNpLTAwMDBfMDRfMDEuMC5hbmFsb2ctc3Rl
cmVvLm1vbml0b3I+CgljdXJyZW50IGxhdGVuY3k6IDkuNjQgbXMKCXJlcXVlc3RlZCBsYXRl
bmN5OiAyMC4wMCBtcwoJc2FtcGxlIHNwZWM6IGZsb2F0MzJsZSAxY2ggMjVIegoJY2hhbm5l
bCBtYXA6IG1vbm8KCSAgICAgICAgICAgICBNb25vCglyZXNhbXBsZSBtZXRob2Q6IHBlYWtz
Cglvd25lciBtb2R1bGU6IDgKCWNsaWVudDogMyA8UHVsc2VBdWRpbyBWb2x1bWUgQ29udHJv
bD4KCWRpcmVjdCBvbiBpbnB1dDogNAoJcHJvcGVydGllczoKCQltZWRpYS5uYW1lID0gIlBl
YWsgZGV0ZWN0IgoJCWFwcGxpY2F0aW9uLm5hbWUgPSAiUHVsc2VBdWRpbyBWb2x1bWUgQ29u
dHJvbCIKCQluYXRpdmUtcHJvdG9jb2wucGVlciA9ICJVTklYIHNvY2tldCBjbGllbnQiCgkJ
bmF0aXZlLXByb3RvY29sLnZlcnNpb24gPSAiMjMiCgkJYXBwbGljYXRpb24uaWQgPSAib3Jn
LlB1bHNlQXVkaW8ucGF2dWNvbnRyb2wiCgkJYXBwbGljYXRpb24uaWNvbl9uYW1lID0gImF1
ZGlvLWNhcmQiCgkJYXBwbGljYXRpb24udmVyc2lvbiA9ICIxLjAiCgkJYXBwbGljYXRpb24u
cHJvY2Vzcy5pZCA9ICIxNTU1IgoJCWFwcGxpY2F0aW9uLnByb2Nlc3MudXNlciA9ICJwYXVs
bGlrIgoJCWFwcGxpY2F0aW9uLnByb2Nlc3MuaG9zdCA9ICJsb2NhbGhvc3QiCgkJYXBwbGlj
YXRpb24ucHJvY2Vzcy5iaW5hcnkgPSAicGF2dWNvbnRyb2wiCgkJYXBwbGljYXRpb24ubGFu
Z3VhZ2UgPSAiZW5fVVMuVVRGLTgiCgkJd2luZG93LngxMS5kaXNwbGF5ID0gIjowLjAiCgkJ
YXBwbGljYXRpb24ucHJvY2Vzcy5tYWNoaW5lX2lkID0gIjM0OWFmMjYxY2JiOGQ4YjcwNjZk
OGRhZDAwMDAwNTU0IgoJCWFwcGxpY2F0aW9uLnByb2Nlc3Muc2Vzc2lvbl9pZCA9ICIzNDlh
ZjI2MWNiYjhkOGI3MDY2ZDhkYWQwMDAwMDU1NC0xMzIwOTQyNDYzLjQ3NDMzNy0xNTMwODg4
MTkwIgoJCW1vZHVsZS1zdHJlYW0tcmVzdG9yZS5pZCA9ICJzb3VyY2Utb3V0cHV0LWJ5LWFw
cGxpY2F0aW9uLWlkOm9yZy5QdWxzZUF1ZGlvLnBhdnVjb250cm9sIgowIGNhY2hlIGVudHJp
ZShzKSBhdmFpbGFibGUuCj4+PiA=
--------------070905070805070904040008
Content-Type: text/x-log;
 name="snd.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="snd.log"

total 0
drwxr-xr-x  2 root root       60 Nov 10 18:27 by-path
crw-rw---T+ 1 root audio 116,  6 Nov 10 18:27 controlC0
crw-rw---T+ 1 root audio 116,  5 Nov 10 18:27 hwC0D0
crw-rw---T+ 1 root audio 116,  4 Nov 10 18:28 pcmC0D0c
crw-rw---T+ 1 root audio 116,  3 Nov 10 18:28 pcmC0D0p
crw-rw---T+ 1 root audio 116,  2 Nov 10 18:27 pcmC0D1p
crw-rw---T  1 root audio 116,  1 Nov 10 18:27 seq
crw-rw---T+ 1 root audio 116, 33 Nov 10 18:27 timer

--------------070905070805070904040008--
