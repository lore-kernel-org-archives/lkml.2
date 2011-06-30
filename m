Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab1F3Avg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 20:51:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17697 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab1F3Av2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 20:51:28 -0400
X-AuditID: cbfee61b-b7bfdae000006d51-3f-4e0bc88ec270
Date: Thu, 30 Jun 2011 09:51:24 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/2] ARM: EXYNOS4: Add more register addresses of CMU and PMU.
To: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jaecheol Lee <jc.lee@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, myungjoo.ham@gmail.com
Message-id: <1309395085-22084-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 30 Jun 2011 00:51:40.0868 (UTC)
 FILETIME=[DFD2A840:01CC36BF]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/include/mach/regs-clock.h |   13 +++++++++++++
 arch/arm/mach-exynos4/include/mach/regs-pmu.h   |   16 ++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/include/mach/regs-clock.h b/arch/arm/mach-exynos4/include/mach/regs-clock.h
index 64bdd24..f723e62 100644
--- a/arch/arm/mach-exynos4/include/mach/regs-clock.h
+++ b/arch/arm/mach-exynos4/include/mach/regs-clock.h
@@ -17,13 +17,17 @@
 
 #define S5P_CLKREG(x)			(S5P_VA_CMU + (x))
 
+#define S5P_CLKSRC_LEFTBUS              S5P_CLKREG(0x04200)
 #define S5P_CLKDIV_LEFTBUS		S5P_CLKREG(0x04500)
 #define S5P_CLKDIV_STAT_LEFTBUS		S5P_CLKREG(0x04600)
 #define S5P_CLKGATE_IP_LEFTBUS		S5P_CLKREG(0x04800)
+#define S5P_CLKOUT_CMU_LEFTBUS		S5P_CLKREG(0x04A00)
 
+#define S5P_CLKSRC_RIGHTBUS             S5P_CLKREG(0x08200)
 #define S5P_CLKDIV_RIGHTBUS		S5P_CLKREG(0x08500)
 #define S5P_CLKDIV_STAT_RIGHTBUS	S5P_CLKREG(0x08600)
 #define S5P_CLKGATE_IP_RIGHTBUS		S5P_CLKREG(0x08800)
+#define S5P_CLKOUT_CMU_RIGHTBUS		S5P_CLKREG(0x08A00)
 
 #define S5P_EPLL_LOCK			S5P_CLKREG(0x0C010)
 #define S5P_VPLL_LOCK			S5P_CLKREG(0x0C020)
@@ -36,7 +40,9 @@
 #define S5P_CLKSRC_TOP0			S5P_CLKREG(0x0C210)
 #define S5P_CLKSRC_TOP1			S5P_CLKREG(0x0C214)
 #define S5P_CLKSRC_CAM			S5P_CLKREG(0x0C220)
+#define S5P_CLKSRC_TV			S5P_CLKREG(0x0C224)
 #define S5P_CLKSRC_MFC			S5P_CLKREG(0x0C228)
+#define S5P_CLKSRC_G3D			S5P_CLKREG(0x0C22C)
 #define S5P_CLKSRC_IMAGE		S5P_CLKREG(0x0C230)
 #define S5P_CLKSRC_LCD0			S5P_CLKREG(0x0C234)
 #define S5P_CLKSRC_LCD1			S5P_CLKREG(0x0C238)
@@ -64,6 +70,7 @@
 #define S5P_CLKDIV_PERIL3		S5P_CLKREG(0x0C55C)
 #define S5P_CLKDIV_PERIL4		S5P_CLKREG(0x0C560)
 #define S5P_CLKDIV_PERIL5		S5P_CLKREG(0x0C564)
+#define S5P_CLKDIV2_RATIO		S5P_CLKREG(0x0C580)
 
 #define S5P_CLKSRC_MASK_TOP		S5P_CLKREG(0x0C310)
 #define S5P_CLKSRC_MASK_CAM		S5P_CLKREG(0x0C320)
@@ -91,6 +98,8 @@
 #define S5P_CLKGATE_IP_PERIR		S5P_CLKREG(0x0C960)
 #define S5P_CLKGATE_BLOCK		S5P_CLKREG(0x0C970)
 
+#define S5P_CLKOUT_CMU_TOP		S5P_CLKREG(0x0CA00)
+
 #define S5P_CLKSRC_MASK_DMC		S5P_CLKREG(0x10300)
 #define S5P_CLKSRC_DMC			S5P_CLKREG(0x10200)
 #define S5P_CLKDIV_DMC0			S5P_CLKREG(0x10500)
@@ -98,6 +107,8 @@
 #define S5P_CLKDIV_STAT_DMC0		S5P_CLKREG(0x10600)
 #define S5P_CLKGATE_IP_DMC		S5P_CLKREG(0x10900)
 
+#define S5P_CLKOUT_CMU_DMC		S5P_CLKREG(0x10A00)
+
 #define S5P_APLL_LOCK			S5P_CLKREG(0x14000)
 #define S5P_MPLL_LOCK			S5P_CLKREG(0x14004)
 #define S5P_APLL_CON0			S5P_CLKREG(0x14100)
@@ -116,6 +127,8 @@
 #define S5P_CLKGATE_SCLKCPU		S5P_CLKREG(0x14800)
 #define S5P_CLKGATE_IP_CPU		S5P_CLKREG(0x14900)
 
+#define S5P_CLKOUT_CMU_CPU		S5P_CLKREG(0x14A00)
+
 #define S5P_APLL_LOCKTIME		(0x1C20)	/* 300us */
 
 #define S5P_APLLCON0_ENABLE_SHIFT	(31)
diff --git a/arch/arm/mach-exynos4/include/mach/regs-pmu.h b/arch/arm/mach-exynos4/include/mach/regs-pmu.h
index a964337..8c4596f 100644
--- a/arch/arm/mach-exynos4/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos4/include/mach/regs-pmu.h
@@ -33,8 +33,16 @@
 #define S5P_EINT_WAKEUP_MASK			S5P_PMUREG(0x0604)
 #define S5P_WAKEUP_MASK				S5P_PMUREG(0x0608)
 
+#define S5P_HDMI_PHY_CONTROL			S5P_PMUREG(0x0700)
+#define S5P_USBOTG_PHY_CONTROL			S5P_PMUREG(0x0704)
 #define S5P_USBHOST_PHY_CONTROL			S5P_PMUREG(0x0708)
 #define S5P_USBHOST_PHY_ENABLE			(1 << 0)
+#define S5P_DAC_CONTROL				S5P_PMUREG(0x070C)
+#define S5P_MIPI_CONTROL0			S5P_PMUREG(0x0710)
+#define S5P_MIPI_CONTROL1			S5P_PMUREG(0x0714)
+#define S5P_ADC_CONTROL				S5P_PMUREG(0x0718)
+#define S5P_PCIE_CONTROL			S5P_PMUREG(0x071C)
+#define S5P_SATA_CONTROL			S5P_PMUREG(0x0720)
 
 #define S5P_MIPI_DPHY_CONTROL(n)		S5P_PMUREG(0x0710 + (n) * 4)
 #define S5P_MIPI_DPHY_ENABLE			(1 << 0)
@@ -51,6 +59,8 @@
 #define S5P_INFORM6				S5P_PMUREG(0x0818)
 #define S5P_INFORM7				S5P_PMUREG(0x081C)
 
+#define S5P_PMU_DEBUG				S5P_PMUREG(0x0A00)
+
 #define S5P_ARM_CORE0_LOWPWR			S5P_PMUREG(0x1000)
 #define S5P_DIS_IRQ_CORE0			S5P_PMUREG(0x1004)
 #define S5P_DIS_IRQ_CENTRAL0			S5P_PMUREG(0x1008)
@@ -130,6 +140,8 @@
 #define S5P_ARM_CORE1_OPTION			S5P_PMUREG(0x2088)
 
 #define S5P_ARM_COMMON_OPTION			S5P_PMUREG(0x2408)
+#define S5P_ARM_CPU_L2_0_CONFIGURATION		S5P_PMUREG(0x2600)
+#define S5P_ARM_CPU_L2_1_CONFIGURATION		S5P_PMUREG(0x2620)
 #define S5P_TOP_PWR_OPTION			S5P_PMUREG(0x2C48)
 #define S5P_CAM_OPTION				S5P_PMUREG(0x3C08)
 #define S5P_TV_OPTION				S5P_PMUREG(0x3C28)
@@ -149,6 +161,10 @@
 #define S5P_PAD_RET_EBIA_OPTION			S5P_PMUREG(0x3188)
 #define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
 
+#define S5P_XUSBXTI_CONFIGURATION		S5P_PMUREG(0x3400)
+#define S5P_XXTI_CONFIGURATION			S5P_PMUREG(0x3420)
+#define S5P_MAUDIO_CONFIGURATION		S5P_PMUREG(0x3CC0)
+
 #define S5P_PMU_CAM_CONF			S5P_PMUREG(0x3C00)
 #define S5P_PMU_TV_CONF				S5P_PMUREG(0x3C20)
 #define S5P_PMU_MFC_CONF			S5P_PMUREG(0x3C40)
-- 
1.7.4.1

