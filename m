Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1EOXhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:37:39 -0400
Received: from mail.df.lth.se ([194.47.250.12]:22984 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab1EOXhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:37:34 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 02/13] mach-ux500: update the DB5500 register file
Date: Mon, 16 May 2011 01:37:31 +0200
Message-Id: <1305502651-32486-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/include/mach/db5500-regs.h |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/include/mach/db5500-regs.h b/arch/arm/mach-ux500/include/mach/db5500-regs.h
index bd88c1e..6ad9832 100644
--- a/arch/arm/mach-ux500/include/mach/db5500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db5500-regs.h
@@ -17,6 +17,8 @@
 #define U5500_GIC_DIST_BASE	0xA0411000
 #define U5500_GIC_CPU_BASE	0xA0410100
 #define U5500_DMA_BASE		0x90030000
+#define U5500_STM_BASE		0x90020000
+#define U5500_STM_REG_BASE	(U5500_STM_BASE + 0xF000)
 #define U5500_MCDE_BASE		0xA0400000
 #define U5500_MODEM_BASE	0xB0000000
 #define U5500_L2CC_BASE		0xA0412000
@@ -29,7 +31,9 @@
 #define U5500_NAND0_BASE	0x60000000
 #define U5500_NAND1_BASE	0x70000000
 #define U5500_TWD_BASE		0xa0410600
+#define U5500_ICN_BASE		0xA0040000
 #define U5500_B2R2_BASE		0xa0200000
+#define U5500_BOOT_ROM_BASE	0x90000000
 
 #define U5500_FSMC_BASE		(U5500_PER1_BASE + 0x0000)
 #define U5500_SDI0_BASE		(U5500_PER1_BASE + 0x1000)
@@ -60,6 +64,7 @@
 #define U5500_MSP1_BASE		(U5500_PER4_BASE + 0x9000)
 #define U5500_GPIO2_BASE	(U5500_PER4_BASE + 0xA000)
 #define U5500_CDETECT_BASE	(U5500_PER4_BASE + 0xF000)
+#define U5500_PRCMU_TCDM_BASE	(U5500_PER4_BASE + 0x18000)
 
 #define U5500_SPI0_BASE		(U5500_PER5_BASE + 0x0000)
 #define U5500_SPI1_BASE		(U5500_PER5_BASE + 0x1000)
@@ -83,7 +88,7 @@
 #define U5500_HASH0_BASE	(U5500_PER6_BASE + 0x1000)
 #define U5500_HASH1_BASE	(U5500_PER6_BASE + 0x2000)
 #define U5500_PKA_BASE		(U5500_PER6_BASE + 0x4000)
-#define U5500_PKAM_BASE		(U5500_PER6_BASE + 0x5000)
+#define U5500_PKAM_BASE		(U5500_PER6_BASE + 0x5100)
 #define U5500_MTU0_BASE		(U5500_PER6_BASE + 0x6000)
 #define U5500_MTU1_BASE		(U5500_PER6_BASE + 0x7000)
 #define U5500_CR_BASE		(U5500_PER6_BASE + 0x8000)
@@ -114,8 +119,19 @@
 #define U5500_MBOX2_LOCAL_START	(U5500_MBOX_BASE + 0x20)
 #define U5500_MBOX2_LOCAL_END	(U5500_MBOX_BASE + 0x3F)
 
-#define U5500_ESRAM_BASE		0x40000000
+#define U5500_ACCCON_BASE_SEC	(0xBFFF0000)
+#define U5500_ACCCON_BASE		(0xBFFF1000)
+#define U5500_ACCCON_CPUVEC_RESET_ADDR_OFFSET (0x00000020)
+#define U5500_ACCCON_ACC_CPU_CTRL_OFFSET (0x000000BC)
+
+#define U5500_ESRAM_BASE	        0x40000000
 #define U5500_ESRAM_DMA_LCPA_OFFSET	0x10000
 #define U5500_DMA_LCPA_BASE    (U5500_ESRAM_BASE + U5500_ESRAM_DMA_LCPA_OFFSET)
 
+#define U5500_MCDE_SIZE		0x1000
+#define U5500_DSI_LINK_SIZE	0x1000
+#define U5500_DSI_LINK_COUNT	0x2
+#define U5500_DSI_LINK1_BASE	(U5500_MCDE_BASE + U5500_MCDE_SIZE)
+#define U5500_DSI_LINK2_BASE	(U5500_DSI_LINK1_BASE + U5500_DSI_LINK_SIZE)
+
 #endif
-- 
1.7.4.4

