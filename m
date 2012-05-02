Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2EBFM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:12:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab2EBFMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:12:23 -0400
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH 6/7] ARM: Exynos5: Add AUXDATA support for MSHC controllers
Date: Tue,  1 May 2012 22:07:45 -0700
Message-Id: <1335935266-25289-7-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entries if MSHC controllers in AUXDATA table for correct device name
initialization.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/mach-exynos5-dt.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 00e25fc..4a060f1 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -72,6 +72,14 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 				"s3c2440-i2c.0", NULL),
 	OF_DEV_AUXDATA("samsung,s3c2440-i2c", EXYNOS5_PA_IIC(1),
 				"s3c2440-i2c.1", NULL),
+	OF_DEV_AUXDATA("synopsis,dw-mshc-exynos5250", 0x12200000,
+				"dw_mmc.0", NULL),
+	OF_DEV_AUXDATA("synopsis,dw-mshc-exynos5250", 0x12210000,
+				"dw_mmc.1", NULL),
+	OF_DEV_AUXDATA("synopsis,dw-mshc-exynos5250", 0x12220000,
+				"dw_mmc.2", NULL),
+	OF_DEV_AUXDATA("synopsis,dw-mshc-exynos5250", 0x12230000,
+				"dw_mmc.3", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_PDMA0, "dma-pl330.0", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_PDMA1, "dma-pl330.1", NULL),
 	OF_DEV_AUXDATA("arm,pl330", EXYNOS5_PA_MDMA1, "dma-pl330.2", NULL),
-- 
1.7.5.4

