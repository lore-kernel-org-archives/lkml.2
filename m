Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0LFSEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:04:50 -0500
Received: from torres.zugschlus.de ([85.214.131.164]:42108 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0LFSEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:04:49 -0500
X-Greylist: delayed 2840 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 13:04:48 EST
Date: Mon, 6 Dec 2010 18:17:27 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: NetXen NX3031 failing test, reporting link down, not working
Message-ID: <20101206171727.GA30695@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have HP DL 120 G6 with two Quad-GE Cards based on NetXen NX3031 (rev
42) [4040:0100]. The boxes are running with a grml daily image with
kernel 2.6.36.1 for the time being, and the NetXens are giving me a
hard time.

This is the dmesg for two of the eight Interfaces (for brevity).

[    1.818833] QLogic/NetXen Network Driver v4.0.74
[    1.818881] netxen_nic 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.818894] netxen_nic 0000:01:00.0: setting latency timer to 64
[    1.819116] netxen_nic 0000:01:00.0: 2MB memory map
[    7.709080] netxen_nic 0000:01:00.0: loading firmware from flash
[   12.866864] netxen_nic 0000:01:00.0: using 64-bit dma mask
[   12.867197] netxen_nic: Quad Gig LP Board S/N TI08BK3987  Chip rev 0x42
[   12.867200] netxen_nic 0000:01:00.0: firmware v4.0.530 [legacy]
[   12.867249] netxen_nic 0000:01:00.0: irq 41 for MSI/MSI-X
[   12.867254] netxen_nic 0000:01:00.0: irq 42 for MSI/MSI-X
[   12.867265] netxen_nic 0000:01:00.0: using msi-x interrupts
[   12.867446] netxen_nic 0000:01:00.0: eth2: GbE port initialized
[   12.867468] netxen_nic 0000:01:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.867477] netxen_nic 0000:01:00.1: setting latency timer to 64
[   12.867688] netxen_nic 0000:01:00.1: 2MB memory map
[   12.867773] netxen_nic 0000:01:00.1: using 64-bit dma mask
[   12.868097] netxen_nic 0000:01:00.1: firmware v4.0.530 [legacy]
[   12.868120] netxen_nic 0000:01:00.1: irq 43 for MSI/MSI-X
[   12.868126] netxen_nic 0000:01:00.1: irq 44 for MSI/MSI-X
[   12.868136] netxen_nic 0000:01:00.1: using msi-x interrupts
[   12.868288] netxen_nic 0000:01:00.1: eth3: GbE port initialized

They work fine when I have two NetXens connected back-to-back (at
least I can ping the other side), but they do not work when one of the
NetXen Interfaces is connected to an HP ProCurve 2848.

The switch happily says the link is up, while ethtool says "Speed:
1000Mb/s, Duplex: Full, Link detected: no", and ethtool -t offline and
ethtool -t online both say "The test result is FAIL".

Do the netxens need Firmware to work and do not complain when the
firmware is not found? Any ideas how do debug this?

I am not sure whether this is appropriate for netdev@vger. If so,
please tell me and I'll re-send there. I'd appreciate any pointers to
any resources about the NetXen interfaces.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
