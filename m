Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab0IZVNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 17:13:33 -0400
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:52441 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab0IZVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 17:13:32 -0400
Message-ID: <4C9FB773.9010903@uni-koeln.de>
Date: Sun, 26 Sep 2010 23:13:23 +0200
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.12) Gecko/20100914 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: system hangs in DRM during/after radeon init with linux-2.6.36-rc5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I wanted to verify if the problem I've reported two weeks ago (Oops in
linux-2.6.34.3 radeon at xserver start) is still present in newer
versions. I've build linux-2.6.36-rc5 (config from working
linux-2.6.34.2, make oldconfig ....) and the system got stuck during
boot. Last line on screen was a message from DRM about initializing
radeon. No bug, no Oops... Nothing. And nothing in the logs ... to early...

Hardware:
Asus P6T
Intel Core i7
12 GB RAM
HIS HD4670 IceQ Turbo PCIe

System is Debian stable/testing x86_64.

Output of lspci:

00:00.0 Host bridge: Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
(rev 12)
00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 1 (rev 12)
00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 3 (rev 12)
00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express
Root Port 7 (rev 12)
00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
Registers (rev 12)
00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
Pad Registers (rev 12)
00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and
RAS Registers (rev 12)
00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
(rev 12)
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
00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
Root Port 3
00:1c.3 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
Root Port 4
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
02:00.0 VGA compatible controller: ATI Technologies Inc RV730XT [Radeon
HD 4670]
02:00.1 Audio device: ATI Technologies Inc RV710/730
04:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6315 Series
Firewire Controller
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)

This problem didn't occur with 2.6.35.4 (although this version had the
problem with the Oops mentioned above). I haven't tested earlier
2.6.36-rc versions yet.


Regards,
Berthold Cogel
