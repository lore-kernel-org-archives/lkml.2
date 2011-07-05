Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1GEVwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 17:52:00 -0400
Received: from lucidpixels.com ([72.73.18.11]:35109 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1GEVv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 17:51:59 -0400
Date: Tue, 5 Jul 2011 17:51:58 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-usb@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: 2.6.39.2: usb kernel panic/oops: schedule+ehci_irq+0x266/0x830
Message-ID: <alpine.DEB.2.02.1107051742290.3983@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I plan to build a new machine in the future (one with console access) but 
in the meantime, after my PSU replacement, the host is still having 
issues, I've turned off bluetooth wireless (built into the DP55KG) and 
will see if it panics again, link the latest panic/oops/etc:

http://home.comcast.net/~jpiszcz/20110705/IMG_2875.JPG

schedule+0x266/0x830
common_interrupt+0xe/0x13
ehci_irq+0x20f/0x230

Is this a valid kernel bug?

I have another box (diff MOBO and all running 2.6.39.x no issues) but it 
does not have built-in bluetooth, I am also running a USB (non-winmodem) 
on this host as well, can anyone comment on this?

  16:      70587          0          0          0          0          0 
11675          0   IO-APIC-fasteoi   ehci_hcd:usb1

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 003: ID 2001:f103 D-Link Corp. DUB-H7 7-port USB 2.0 hub
Bus 001 Device 004: ID 0baf:0303 U.S. Robotics
Bus 001 Device 005: ID 0764:0501 Cyber Power System, Inc. CP1500 AVR UPS
Bus 001 Device 006: ID 413c:1002 Dell Computer Corp. Keyboard Hub
Bus 001 Device 007: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Bus 001 Device 008: ID 413c:2002 Dell Computer Corp. SK-8125 Keyboard
Bus 001 Device 009: ID 0461:4d15 Primax Electronics, Ltd Dell Optical Mouse

I also use munin to poll the UPS for various information, could this be a 
bug in the USB driver for this chipset/motherboard?

Can polling various USB devices, running a hylafax server, etc, cause a 
bug to pop up more easily in the USB subsystem vs. just using a keyboard 
for example, I assume so?

Comments?

Thanks.

Justin.
