Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1IRLmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 07:42:39 -0400
Received: from smtp.domeneshop.no ([194.63.248.54]:43200 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1IRLmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 07:42:38 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Sep 2011 07:42:38 EDT
From: =?us-ascii?Q?Marius_Bjornstad?= <pmb@fa2k.net>
To: <linux-kernel@vger.kernel.org>
Subject: Crash in et131x
Date: Sun, 18 Sep 2011 13:37:14 +0200
Message-ID: <001501cc75f7$511738b0$f345aa10$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acx190jLB3KtPzV9TQGhcj5ZytbGZQ==
Content-Language: en-gb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I'm using an ExpressCard ethernet adapter, using the et131x (staging)
driver. The system stops responding about 15 min after I connect the NIC. It
crashes even when I don't transfer any data, but it doesn't crash when it's
not connected to a switch. There is no debug information on the screen. 

I'm using 2.6.40.4-5.fc15.x86_64, which is a re-named 3.0 kernel (x86_64 bit
system). I also tried to build the et131x module from source using 3.1-rc6,
with the same result. The NIC is a no-name ExpressCard, here is the output
of lspci -v:

02:00.0 Ethernet controller: Agere Systems ET-131x PCI-E Ethernet Controller
(rev 02)
        Subsystem: Agere Systems ET-131x PCI-E Ethernet Controller
        Physical Slot: 1
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at 80200000 (64-bit, non-prefetchable) [size=2M]
        [virtual] Expansion ROM at 80400000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Express Endpoint, MSI 00
        Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [130] Virtual Channel
        Capabilities: [14c] Device Serial Number 9a-78-56-34-12-2d-02-00
        Kernel driver in use: et131x
        Kernel modules: et131x


Cheers,
Marius 

PS: If you know a gigabit ethernet expresscard that definitely works with
Linux and is available in Europe, I'd be happy to know.


