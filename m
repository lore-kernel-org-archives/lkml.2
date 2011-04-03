Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1DCVBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 17:01:08 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:4394 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753537Ab1DCVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 17:00:45 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>
Subject: [PATCH 0/3] ARM: Xilinx: Adding SMP Support
Date: Sun, 3 Apr 2011 15:00:15 -0600
X-Mailer: git-send-email 1.5.4.7
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <2bd38752-765c-4d7c-9ba6-0e62fbfb45ec@VA3EHSMHS006.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series adds SMP to the Xilinx ARM platform.
The entire patch set must be used. I only broke it up into logical 
pieces to make the review easier (I hope).

This code has been tested against 2.6.39-rc1. The only checkpatch 
warnings are about usage of NR_CPUS which seems to how the other
platforms do it also.

I appreciate anyone's time who can review the patch set.

Thanks,
John

 arch/arm/Kconfig                               |    2 
 arch/arm/mach-xilinx/Makefile                  |    3 
 arch/arm/mach-xilinx/common.c                  |   16 ++
 arch/arm/mach-xilinx/common.h                  |    2 
 arch/arm/mach-xilinx/headsmp.S                 |   59 +++++++++
 arch/arm/mach-xilinx/include/mach/irqs.h       |    1 
 arch/arm/mach-xilinx/include/mach/smp.h        |   30 ++++
 arch/arm/mach-xilinx/include/mach/xilinx_soc.h |   20 +++
 arch/arm/mach-xilinx/localtimer.c              |   36 +++++
 arch/arm/mach-xilinx/platsmp.c                 |  160 ++++++++++++++++++++++++-
 arch/arm/mach-xilinx/timer.c                   |    5 
 11 files changed, 327 insertions(+), 7 deletions(-)


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


