Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab0KDOG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:06:58 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:65327 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KDOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:06:55 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4CD2BDE7.2070307@elka.pw.edu.pl>
Date: Thu, 04 Nov 2010 15:06:31 +0100
From: Wojtek Zabolotny <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel 2.6.33.7 (the highest version with RT patch) does not work
 with b44 ethernet controller
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have updated my RT-kernel to version 2.6.33.7-rt29 (the newest RT 
version),
and I've found that I've lost Ethernet connectivity.
In the logs I could see messages like this:
Nov  2 09:30:28 wzlaphp kernel: b44: eth0: powering down PHY
Nov  2 09:30:28 wzlaphp kernel: b44: eth0: BUG!  Timeout waiting for bit 
00000002 of register 42c to clear.
Nov  2 09:30:32 wzlaphp kernel: b44: eth0: BUG!  Timeout waiting for bit 
80000000 of register 428 to clear.

I was not sure whether the probem is related to the 2.6.33.7 kernel 
itself or with the RT patch, so I've compiled also the unpatched version 
of 2.6.33.7

It is also not able to communicate with my Ethernet controller, but now 
the error messages are different:

b44 0000:02:0e.0: PCI INT A disabled
b44 0000:02:0e.0: BAR 0: set to [mem 0xf4108000-0xf4109fff] (PCI address 
[0xf4108000-0xf4109fff]
b44 0000:02:0e.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ssb: Core 0 found: Fast Ethernet (cc 0x806, rev 0x07, vendor 0x4243)
ssb: Core 1 found: V90 (cc 0x807, rev 0x03, vendor 0x4243)
ssb: Core 2 found: PCI (cc 0x804, rev 0x0A, vendor 0x4243)
ssb: Sonics Silicon Backplane found on PCI device 0000:02:0e.0
b44.c:v2.0
b44: Invalid MAC address found in EEPROM
b44 ssb1:0: Problem fetching invariants of chip, aborting.
b44: probe of ssb1:0 failed with error -22

Now I'm using the old 2.6.33.5-rt23 kernel, and everything works perfectly.

-- 
Wojciech M Zabolotny
wzab@ise.pw.edu.pl


