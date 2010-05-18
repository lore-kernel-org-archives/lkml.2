Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0ERQXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:23:34 -0400
Received: from [82.152.35.87] ([82.152.35.87]:39610 "EHLO emil.homelinux.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab0ERQXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:23:32 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2010 12:23:32 EDT
Date: Tue, 18 May 2010 17:13:13 +0100
From: Emil <emil@la.mine.nu>
To: linux-kernel@vger.kernel.org
Subject: Linux telephony - IXJ
Message-ID: <20100518161313.GA5338@emil.homelinux.net>
Reply-To: emil@la.mine.nu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have half a dozen Quicknet cards in various countries which I use 
to keep in touch with friends and family. I also have a Quicknet
PhoneJack which is an ISA card allowing me to place remote calls via
the net. All these cards worked flawlessly for almost a decade paying
for themselves many times over.

The current kernel support for these cards is broken. They are not
produced anymore so probably nobody will care about this message. 
It is surprinsing though that while there is no other alternative
telephony driver in the kernel the only one present is broken.

As I stated before I have various versions of Quichnet cards. The
two listed bellow are PCI (1 port FXO) with the following chipsets
- 1999: AM79R7OJC + Oxford Semiconductor OX16PCI954 + Xilinx FPGA + 
        DSP CT8022A11AQC
- 2003: MC145483 + Tiger 320 + DSP CT8022A11AQC

Neither of them is working with the ixj kernel driver. The kernel driver
compiles, the card is detected but the phone hook status is never changes
and you cannot produce a dial tone (even if you try to force it).

The driver that _does_ work with all my cards is this one:
http://uglyduck.ath.cx/ixj-1.2.2.tar.gz
http://nic.ath.cx/ixj-1.2.2.tar.gz

Unfortunatelly this only compiles for kernel 2.4; you'll have to
enable telephony support but disable the kernel IXJ driver and 
then this older driver compiles and works like a charm. 

I have tried on the same hardware kernel 2.4 + ixj version 1.2.2 works
while kernel 2.6 + version 3.1.0 doesn't.

While I know how to program in C, porting the old version to the 2.6 kernel
is a to long learning curve for me so I guess this means back to linux 2.4 

-- 
								Regards,
								Emil
