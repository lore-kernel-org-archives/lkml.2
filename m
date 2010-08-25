Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0HYW2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:28:34 -0400
Received: from graze.net ([71.162.143.10]:56437 "HELO graze.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751495Ab0HYW2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:28:31 -0400
X-Greylist: delayed 2021 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 18:28:31 EDT
Date: Wed, 25 Aug 2010 17:54:45 -0400
From: "Brian C. Huffman" <bhuffman@graze.net>
To: linux-kernel@vger.kernel.org
Message-ID: <4C759125.8030008@graze.net>
Subject: Intel DP43BF MB - No PCI Devices detected
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I have searched and found no previous posts on this topic.  Using the 
2.6.36-rc2-git3 (and many before that rev), the kernel doesn't see my 
PCI devices.  They can be seen with dmidecode but do not show up with 
lspci (and are not mentioned on boot up).

For example, here's one of the slots (shown as In Use):
Handle 0x0038, DMI type 9, 17 bytes
System Slot Information
     Designation: PCI Slot
     Type: 32-bit PCI
     Current Usage: In Use
     Length: Short
     ID: 5
     Characteristics:
         3.3 V is provided
         Opening is shared
         PME signal is supported
     Bus Address: 0000:00:1e.0


But here's the lspci:
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller 
(rev 03)
00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express Root 
Port (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio 
Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 1
00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Port 2
00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 3
00:1c.3 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 4
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 5
00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
Root Port 6
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface 
Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port 
SATA IDE Controller #1
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port 
SATA IDE Controller #2
01:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce 8400 
GS] (rev a1)
02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 
single-port PATA133 interface (rev b2)
06:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. Device 3403
07:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57788 
Gigabit Ethernet PCIe (rev 01)

What can I do to further troubleshoot this?

Thanks,
Brian
