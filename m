Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1DFRQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 13:16:03 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:53612
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619Ab1DFRQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 13:16:00 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz4015L1447Rzz1202hzzz2dh95h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>,
        <nicolas.pitre@linaro.org>
Subject: [PATCH V2 0/4] ARM: Xilinx: Adding SMP Support
Date: Wed, 6 Apr 2011 11:15:06 -0600
X-Mailer: git-send-email 1.5.4.7
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <1dc9d376-9b8c-432a-8cd6-0305b6934f82@VA3EHSMHS016.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


V2

I have updated the patches to be based on the new non-SMP patches
I put out yesterday which is primarily a change from mach-xilinx
to mach-zynq as the product name has now been released.

I broke the 1st patch in the series into 2 patches based on input 
from Michal Simek so that the # of patches in the series is now 4.

Some cleanup based on input from Russell and Catalin to the SMP
boot process. It is simpler and cleaner now (I hope).  Thanks for
their valuable input here.

V1

This patch series adds SMP to the Xilinx ARM platform.
The entire patch set must be used. I only broke it up into logical 
pieces to make the review easier (I hope).

This code has been tested against 2.6.39-rc1. The only checkpatch 
warnings are about usage of NR_CPUS which seems to how the other
platforms do it also.

I appreciate anyone's time who can review the patch set.

Thanks,
John

 arch/arm/Kconfig                           |    2 
 arch/arm/mach-zynq/Makefile                |    3 
 arch/arm/mach-zynq/common.c                |   16 +++
 arch/arm/mach-zynq/common.h                |    2 
 arch/arm/mach-zynq/include/mach/irqs.h     |    1 
 arch/arm/mach-zynq/include/mach/smp.h      |   30 ++++++
 arch/arm/mach-zynq/include/mach/zynq_soc.h |   19 ++++
 arch/arm/mach-zynq/localtimer.c            |   40 ++++++++
 arch/arm/mach-zynq/platsmp.c               |  129 ++++++++++++++++++++++++++++-
 9 files changed, 236 insertions(+), 6 deletions(-)


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


