Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab1LFKZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:25:35 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:36919
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933052Ab1LFKZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:25:32 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zz4015Lzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVS2AH-01-B9F-02
X-M-MSG: 
Date: Tue, 6 Dec 2011 11:25:27 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Brown <davidb@codeaurora.org>
CC: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] iommu/msm: Fix compile error in mach-msm/devices-iommu.c
Message-ID: <20111206102527.GI25178@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just added a patch to my iommu/fixes branch to fix a compile error
with IOMMU enabled. If there is another fix for this already somewhere
please let me know the commit-id so that I can add it to my out-of-tree
branch. If there is no other fix yet I will push this upstream soon with
the next round of iommu-fixes.

Thanks,

	Joerg

>From 96f176a310e447966e45112fe4511b9d9fa0caf4 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 6 Dec 2011 11:17:34 +0100
Subject: [PATCH] iommu/msm: Fix compile error in mach-msm/devices-iommu.c

Fix compile error due to missing <linux/module.h> include.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/arm/mach-msm/devices-iommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/devices-iommu.c b/arch/arm/mach-msm/devices-iommu.c
index 24030d0..0fb7a17 100644
--- a/arch/arm/mach-msm/devices-iommu.c
+++ b/arch/arm/mach-msm/devices-iommu.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/bootmem.h>
+#include <linux/module.h>
 #include <mach/irqs.h>
 #include <mach/iommu.h>
 
-- 
1.7.5.4

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

