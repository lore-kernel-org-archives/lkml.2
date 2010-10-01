Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab0JACzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:55:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38625 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab0JACz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 22:55:28 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <Hiroshi.DOYU@nokia.com>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 1/4] iommu: remove CONFIG_MPU_BRIDGE_IOMMU
Date: Thu, 30 Sep 2010 22:08:52 -0500
Message-Id: <1285902536-7043-2-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285902536-7043-1-git-send-email-x0095840@ti.com>
References: <1285902536-7043-1-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove CONFIG_MPU_BRIDGE_IOMMU in order to create iommu_device
for iva2.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/mach-omap2/omap-iommu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index f5a1aad..bb8c01d 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -35,7 +35,6 @@ static struct iommu_device omap3_devices[] = {
 			.clk_name = "cam_ick",
 		},
 	},
-#if defined(CONFIG_MPU_BRIDGE_IOMMU)
 	{
 		.base = 0x5d000000,
 		.irq = 28,
@@ -45,7 +44,6 @@ static struct iommu_device omap3_devices[] = {
 			.clk_name = "iva2_ck",
 		},
 	},
-#endif
 };
 #define NR_OMAP3_IOMMU_DEVICES ARRAY_SIZE(omap3_devices)
 static struct platform_device *omap3_iommu_pdev[NR_OMAP3_IOMMU_DEVICES];
-- 
1.6.3.3

