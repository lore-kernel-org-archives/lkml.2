Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab1EUAAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:00:40 -0400
Received: from smtp.getmail.no ([84.208.15.66]:59033 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab1EUAAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:00:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39: crash w/threadirqs option enabled
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan>
 <alpine.LFD.2.02.1105201445300.3078@ionos>
 <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201528500.3078@ionos>
 <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos>
 <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201819310.3078@ionos>
Date: Sat, 21 May 2011 02:00:31 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.vvs0y5y36426ze@localhost.localdomain>
In-reply-to: <alpine.LFD.2.02.1105201819310.3078@ionos>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39 first observations: The framerate jitter in games that seem to  
depend on kernel for low-jitter, like doom 3, is almost completely gone  
now. (Tested with latest nvidia driver something 75 something)
I decided to try threadirqs from grub, but that did not work. Looks like  
the same error as I get when I tried the rt kernels, which was this one:

http://www.paradoxuncreated.com/tmp/rterror.jpg

Peace Be With You,
Uwaysi.


http://www.paradoxuncreated.com/tmp/.config39

Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz

uwaysi@Millennium:~$ lspci -v
00:00.0 Host bridge: nVidia Corporation C55 Host Bridge (rev a2)
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: <access denied>

00:00.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:00.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:00.3 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: bus master, 66MHz, fast devsel, latency 0

00:00.4 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: bus master, 66MHz, fast devsel, latency 0

00:00.5 RAM memory: nVidia Corporation C55 Memory Controller (rev a2)
	Flags: bus master, 66MHz, fast devsel, latency 0

00:00.6 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:00.7 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:01.0 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:01.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:01.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:01.3 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:01.4 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:01.5 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:01.6 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:02.0 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:02.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: bus master, 66MHz, fast devsel, latency 0

00:02.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
	Flags: 66MHz, fast devsel

00:03.0 PCI bridge: nVidia Corporation C55 PCI Express bridge (rev a1)  
(prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=05, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fa000000-feafffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:06.0 PCI bridge: nVidia Corporation C55 PCI Express bridge (rev a1)  
(prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:07.0 PCI bridge: nVidia Corporation C55 PCI Express bridge (rev a1)  
(prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: <access denied>

00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0
	I/O ports at 4f00 [size=128]

00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: 66MHz, fast devsel, IRQ 11
	I/O ports at 5000 [size=64]
	I/O ports at 6000 [size=64]
	Capabilities: <access denied>
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2

00:0a.2 RAM memory: nVidia Corporation MCP51 Memory Controller 0 (rev a3)
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: 66MHz, fast devsel

00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)  
(prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
	Memory at f9fff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci_hcd

00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)  
(prog-if 20 [EHCI])
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
	Memory at f9ffec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1) (prog-if 8a  
[Master SecP PriP])
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	I/O ports at ffa0 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: pata_amd
	Kernel modules: pata_amd

00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev  
a1) (prog-if 85 [Master SecO PriO])
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
	I/O ports at c800 [size=8]
	I/O ports at c480 [size=4]
	I/O ports at c400 [size=8]
	I/O ports at c080 [size=4]
	I/O ports at c000 [size=16]
	Memory at f9ffd000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: sata_nv
	Kernel modules: sata_nv

00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev  
a1) (prog-if 85 [Master SecO PriO])
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	I/O ports at bc00 [size=8]
	I/O ports at b880 [size=4]
	I/O ports at b800 [size=8]
	I/O ports at b480 [size=4]
	I/O ports at b400 [size=16]
	Memory at f9ffc000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: sata_nv
	Kernel modules: sata_nv

00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2) (prog-if  
01 [Subtractive decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: feb00000-febfffff
	Capabilities: <access denied>

00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev  
a2)
	Subsystem: Micro-Star International Co., Ltd. Device 7380
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	Memory at f9ff8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
	Subsystem: Micro-Star International Co., Ltd. Device 380c
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
	Memory at f9ff7000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at b080 [size=8]
	Capabilities: <access denied>
	Kernel driver in use: forcedeth
	Kernel modules: forcedeth

01:00.0 PCI bridge: nVidia Corporation NF200 PCIe 2.0 switch for  
mainboards (rev a2) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=01, secondary=02, subordinate=05, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fa000000-feafffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

02:00.0 PCI bridge: nVidia Corporation NF200 PCIe 2.0 switch for  
mainboards (rev a2) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=02, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fa000000-feafffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

02:02.0 PCI bridge: nVidia Corporation NF200 PCIe 2.0 switch for  
mainboards (rev a2) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=02, secondary=04, subordinate=04, sec-latency=0
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

02:03.0 PCI bridge: nVidia Corporation NF200 PCIe 2.0 switch for  
mainboards (rev a2) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=02, secondary=05, subordinate=05, sec-latency=0
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

03:00.0 VGA compatible controller: nVidia Corporation GT200 [GeForce GTX  
280] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: eVga.com. Corp. Device 1280
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
	I/O ports at dc00 [size=128]
	[virtual] Expansion ROM at fea80000 [disabled] [size=512K]
	Capabilities: <access denied>
	Kernel driver in use: nvidia
	Kernel modules: nvidia, nvidiafb

08:09.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire  
II(M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Device 380d
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at febff800 (32-bit, non-prefetchable) [size=2K]
	I/O ports at ec00 [size=128]
	Capabilities: <access denied>
