Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab2ADRHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:07:12 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:47656 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab2ADRHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:07:10 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Andrew Burgess'" <aab@cichlid.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-uvc-devel@lists.berlios.de>
References: <CAO9zADw7ofMLeE3yCQ+uCe=6EzZY=SWtqMDhsi_ggbPhWVfTKg@mail.gmail.com> (from jpiszcz@lucidpixels.com on Tue Jan  3 06:21:02 2012) <1325694071.16950.49@hogo>
In-Reply-To: <1325694071.16950.49@hogo>
Subject: RE: 3.1.5: uvcvideo: Failed to resubmit video URB (-27).
Date: Wed, 4 Jan 2012 12:07:07 -0500
Message-ID: <003301cccb03$4a8cbea0$dfa63be0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGqYLYAn5/D/gBGSH6ojlIpFGPwmJZBROhw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Andrew Burgess [mailto:aab@cichlid.com] 

it sounds like a bug recently tracked down on the usb devel list
(search for 'Failed to resubmit video URB')

it turned out to be a bug in the usb host controller; if you
do an lspci do you see anything made by NetMos or MosChip?

mine says:

0b:00.0 USB Controller: NetMos Technology MCS9990 PCIe to 4‐Port USB  
2.0 Host Controller

mine is a pcie card; perhaps you have one built in?

-

It’s a bit different for my model:

# lspci
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS880 Host Bridge
00:01.0 PCI bridge: Acer Incorporated [ALI] AMD RS780/RS880 PCI to PCI bridge (int gfx)
00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780/RS880 PCI to PCI bridge (PCIE port 0)
00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780/RS880 PCI to PCI bridge (PCIE port 1)
00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
00:12.0 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.2 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.2 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 42)
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc RS880M [Mobility Radeon HD 4200 Series]
01:05.1 Audio device: ATI Technologies Inc RS880 HDMI Audio [Radeon HD 4200 Series]
03:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57780 Gigabit Ethernet PCIe (rev 01)
06:00.0 Network controller: Atheros Communications Inc. AR9287 Wireless Network Adapter (PCI-Express) (rev 01)

Justin.

