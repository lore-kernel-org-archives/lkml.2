Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab1JNLE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:04:57 -0400
Received: from furry1.cpalmer.me.uk ([91.84.39.42]:36801 "EHLO
	furry1.cpalmer.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab1JNLE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:04:56 -0400
X-Greylist: delayed 826 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 07:04:56 EDT
Message-ID: <4E98175A.8040905@pobox.com>
Date: Fri, 14 Oct 2011 12:04:58 +0100
From: Chris Palmer <chris.palmer@pobox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PROBLEM] ASUS Sandybridge motherboards + PCI not working (IRQ n:
 nobody cared)
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt handling for *PCI boards with ASUS Sandybridge motherboards*
seems to be broken.

It has been seen with network and non-network PCI boards. PCIx network
boards work OK. And all reports are for ASUS motherboards.

It always results in the infamous "IRQ n: nobody cared" message usually
within an hour. It is possible to restart things by rmmod/modprobe on
the appropriate PCI driver.

Andrew Morton kindly took a quick look and thinks it is most likely an
ACPI bug.

Configuration summary:
 - ASUS P8H67-V/R3 Motherboard (others have problems with similar M/Bs)
 - M/B BIOS 0804 (just updated to that - no change)
 - Core i5/2500K
 - Onboard ethernet (at11c driver - works)
 - Additional PCIx Intel ethernet board (e1000e driver - works)
 - Additional PCI Broadcom BCM5702X ethernet board (tg3 driver - fails)
	[ Also fails with other PCI boards such as RTL8139 ]
 - Kernel 3.0.6


Any help much appreciated...

Previous references:

https://lkml.org/lkml/2011/6/30/197
https://bugzilla.kernel.org/show_bug.cgi?id=38632
https://bugzilla.redhat.com/show_bug.cgi?id=713351
https://bugzilla.kernel.org/show_bug.cgi?id=35332
https://bugzilla.kernel.org/show_bug.cgi?id=34242
https://bugzilla.kernel.org/show_bug.cgi?id=32242
https://bugzilla.kernel.org/show_bug.cgi?id=39122

Chris
