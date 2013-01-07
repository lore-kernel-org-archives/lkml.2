Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3AGPCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:02:53 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:53662 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3AGPCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:02:52 -0500
Message-ID: <50EAE1D5.7050408@suse.cz>
Date: Mon, 07 Jan 2013 15:55:17 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: next 20130107 hard lockup
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after a couple of minutes, my box locks up hard. It is a regression
against 20130102.

I have no clue what is going on yet. Once, it died while I was doing
nothing, once after I opened a file in vim. I will try to collect more
info... lspci for the time being at least:
00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
Controller (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
Integrated Graphics Controller (rev 02)
00:03.0 Communication controller: Intel Corporation 82G33/G31/P35/P31
Express MEI Controller (rev 02)
00:03.1 Communication controller: Intel Corporation 82G33/G31/P35/P31
Express MEI Controller (rev 02)
00:03.2 IDE interface: Intel Corporation 82G33/G31/P35/P31 Express PT
IDER Controller (rev 02)
00:03.3 Serial controller: Intel Corporation 82G33/G31/P35/P31 Express
Serial KT Controller (rev 02)
00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network
Connection (rev 02)
00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev 02)
00:1a.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #5 (rev 02)
00:1a.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #6 (rev 02)
00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 3 (rev 02)
00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 02)
00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 02)
00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #3 (rev 02)
00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation Device 2910 (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6
port SATA Controller [AHCI mode] (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller
(rev 02)
00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9
Family) Thermal Subsystem (rev 02)
03:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200A PCI
Express-to-PCI Bridge (rev 03)
04:00.0 FireWire (IEEE 1394): Texas Instruments XIO2200A IEEE-1394a-2000
Controller (PHY/Link) (rev 01)
05:00.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet
Controller (rev 02)

regards,
-- 
js
suse labs
