Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab2CTLMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:12:32 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:35854 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528Ab2CTLMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:12:30 -0400
Message-ID: <4F68661A.208@blueyonder.co.uk>
Date: Tue, 20 Mar 2012 11:12:26 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Asus Sabetooth 990FX motherboard and GeForce 560Ti identification
 problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=R7TMJ8Ku0E4A:10 a=vYfY1_jpxdYA:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=d8TPtpSLWvakWmLUeD0A:9 a=uQPZKNJp8ecUgpAJmLkA:7 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not saying this is a kernel problem, just hoping someone will 
recognise the problem and offer a suggestion even if it is I've tried it 
and it's a piece of garbage.

I have the latest 0901 BIOS installed on the motherboard and both 
motherboard and video card are Asus.
It seems to be incorrectly sensed so only works with the vesa X driver. 
My kernel is 3.3.

# hwinfo |grep -i gfx
   Gfx adapter    : monochrome
   ef2c0  ff 4a 32 47 31 20 2d 20 47 46 58 20 56 49 44 00  ".J2G1 - GFX 
VID."
        str1: "J2G1 - GFX VID"
     Internal Designator: "J2G1 - GFX VID"
   Model: "ATI RD890 PCI to PCI bridge (external gfx0 port B)"
   Device: pci 0x5a14 "RD890 PCI to PCI bridge (external gfx0 port B)"

# lspci
00:00.0 Host bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(external gfx0 port B) (rev 02)
00:00.2 IOMMU: ATI Technologies Inc RD990 I/O Memory Management Unit (IOMMU)
00:02.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port B)
00:04.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port D)
00:05.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port E)
00:06.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port F)
00:09.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port H)
00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA 
Controller [AHCI mode] (rev 40)
00:12.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 
Controller
00:12.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI 
Controller
00:13.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 
Controller
00:13.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI 
Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 42)
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host 
controller (rev 40)
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
00:14.5 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI2 
Controller
00:15.0 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI 
bridge (PCIE port 0)
00:15.1 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI 
bridge (PCIE port 1)
00:16.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 
Controller
00:16.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI 
Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor 
Function 0
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor 
Function 1
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor 
Function 2
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor 
Function 3
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor 
Function 4
00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor 
Function 5
01:00.0 VGA compatible controller: nVidia Corporation GF110 [GeForce GTX 
560 Ti] (rev a1)
01:00.1 Audio device: nVidia Corporation GF110 High Definition Audio 
Controller (rev a1)
02:00.0 SATA controller: JMicron Technology Corp. JMB362 AHCI Controller 
(rev 10)
03:00.0 SATA controller: JMicron Technology Corp. JMB362 AHCI Controller 
(rev 10)
04:00.0 USB Controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB 
Host Controller
05:00.0 USB Controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB 
Host Controller
06:05.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 
Gigabit Ethernet (rev 10)
06:07.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire 
II(M)] IEEE 1394 OHCI Controller (rev c0)
08:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot,
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

