Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2ILVQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:16:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52466 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab2ILVQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:16:04 -0400
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <paul@pwsan.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/2] ARM: AM33XX: hwmod: Add OMAP_INTC_START offset to all module int nos
Date: Thu, 13 Sep 2012 02:45:51 +0530
Message-ID: <1347484551-11775-3-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1347484551-11775-1-git-send-email-hvaibhav@ti.com>
References: <1347484551-11775-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent migration of omap architectures to SPARSE_IRQ framework,
it is important to add OMAP_INTC_START to all interrupt numbers
which will be eventually requested by drivers.

This is required in order to get AM33XX boot functionality.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c |  168 ++++++++++++++--------------
 1 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
index 7b7ed08..3c320f4 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
@@ -72,7 +72,7 @@ static struct omap_hwmod_class am33xx_emif_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_emif_irqs[] = {
-	{ .name = "ddrerr0", .irq = 101 },
+	{ .name = "ddrerr0", .irq = 101 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -102,8 +102,8 @@ static struct omap_hwmod_class am33xx_l3_hwmod_class = {
 
 /* l3_main (l3_fast) */
 static struct omap_hwmod_irq_info am33xx_l3_main_irqs[] = {
-	{ .name = "l3debug", .irq = 9 },
-	{ .name = "l3appint", .irq = 10 },
+	{ .name = "l3debug", .irq = 9 + OMAP_INTC_START },
+	{ .name = "l3appint", .irq = 10 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -220,10 +220,10 @@ static struct omap_hwmod_class am33xx_mpu_hwmod_class = {
 
 /* mpu */
 static struct omap_hwmod_irq_info am33xx_mpu_irqs[] = {
-	{ .name = "emuint", .irq = 0 },
-	{ .name = "commtx", .irq = 1 },
-	{ .name = "commrx", .irq = 2 },
-	{ .name = "bench", .irq = 3 },
+	{ .name = "emuint", .irq = 0 + OMAP_INTC_START },
+	{ .name = "commtx", .irq = 1 + OMAP_INTC_START },
+	{ .name = "commrx", .irq = 2 + OMAP_INTC_START },
+	{ .name = "bench", .irq = 3 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -255,7 +255,7 @@ static struct omap_hwmod_rst_info am33xx_wkup_m3_resets[] = {
 };
 
 static struct omap_hwmod_irq_info am33xx_wkup_m3_irqs[] = {
-	{ .name = "txev", .irq = 78 },
+	{ .name = "txev", .irq = 78 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -291,14 +291,14 @@ static struct omap_hwmod_rst_info am33xx_pruss_resets[] = {
 };
 
 static struct omap_hwmod_irq_info am33xx_pruss_irqs[] = {
-	{ .name = "evtout0", .irq = 20 },
-	{ .name = "evtout1", .irq = 21 },
-	{ .name = "evtout2", .irq = 22 },
-	{ .name = "evtout3", .irq = 23 },
-	{ .name = "evtout4", .irq = 24 },
-	{ .name = "evtout5", .irq = 25 },
-	{ .name = "evtout6", .irq = 26 },
-	{ .name = "evtout7", .irq = 27 },
+	{ .name = "evtout0", .irq = 20 + OMAP_INTC_START },
+	{ .name = "evtout1", .irq = 21 + OMAP_INTC_START },
+	{ .name = "evtout2", .irq = 22 + OMAP_INTC_START },
+	{ .name = "evtout3", .irq = 23 + OMAP_INTC_START },
+	{ .name = "evtout4", .irq = 24 + OMAP_INTC_START },
+	{ .name = "evtout5", .irq = 25 + OMAP_INTC_START },
+	{ .name = "evtout6", .irq = 26 + OMAP_INTC_START },
+	{ .name = "evtout7", .irq = 27 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -332,7 +332,7 @@ static struct omap_hwmod_rst_info am33xx_gfx_resets[] = {
 };
 
 static struct omap_hwmod_irq_info am33xx_gfx_irqs[] = {
-	{ .name = "gfxint", .irq = 37 },
+	{ .name = "gfxint", .irq = 37 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -387,7 +387,7 @@ static struct omap_hwmod_class am33xx_adc_tsc_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_adc_tsc_irqs[] = {
-	{ .irq = 16 },
+	{ .irq = 16 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -528,7 +528,7 @@ static struct omap_hwmod_class am33xx_aes_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_aes0_irqs[] = {
-	{ .irq = 102 },
+	{ .irq = 102 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -552,7 +552,7 @@ static struct omap_hwmod_class am33xx_sha0_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_sha0_irqs[] = {
-	{ .irq = 108 },
+	{ .irq = 108 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -579,7 +579,7 @@ static struct omap_hwmod_class am33xx_smartreflex_hwmod_class = {
 
 /* smartreflex0 */
 static struct omap_hwmod_irq_info am33xx_smartreflex0_irqs[] = {
-	{ .irq = 120 },
+	{ .irq = 120 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -599,7 +599,7 @@ static struct omap_hwmod am33xx_smartreflex0_hwmod = {
 
 /* smartreflex1 */
 static struct omap_hwmod_irq_info am33xx_smartreflex1_irqs[] = {
-	{ .irq = 121 },
+	{ .irq = 121 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -625,7 +625,7 @@ static struct omap_hwmod_class am33xx_control_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_control_irqs[] = {
-	{ .irq = 8 },
+	{ .irq = 8 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -665,10 +665,10 @@ static struct omap_hwmod_class am33xx_cpgmac0_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_cpgmac0_irqs[] = {
-	{ .name = "c0_rx_thresh_pend", .irq = 40 },
-	{ .name = "c0_rx_pend", .irq = 41 },
-	{ .name = "c0_tx_pend", .irq = 42 },
-	{ .name = "c0_misc_pend", .irq = 43 },
+	{ .name = "c0_rx_thresh_pend", .irq = 40 + OMAP_INTC_START },
+	{ .name = "c0_rx_pend", .irq = 41 + OMAP_INTC_START },
+	{ .name = "c0_tx_pend", .irq = 42 + OMAP_INTC_START },
+	{ .name = "c0_misc_pend", .irq = 43 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -695,8 +695,8 @@ static struct omap_hwmod_class am33xx_dcan_hwmod_class = {
 
 /* dcan0 */
 static struct omap_hwmod_irq_info am33xx_dcan0_irqs[] = {
-	{ .name = "d_can_ms", .irq = 52 },
-	{ .name = "d_can_mo", .irq = 53 },
+	{ .name = "d_can_ms", .irq = 52 + OMAP_INTC_START },
+	{ .name = "d_can_mo", .irq = 53 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -716,8 +716,8 @@ static struct omap_hwmod am33xx_dcan0_hwmod = {
 
 /* dcan1 */
 static struct omap_hwmod_irq_info am33xx_dcan1_irqs[] = {
-	{ .name = "d_can_ms", .irq = 55 },
-	{ .name = "d_can_mo", .irq = 56 },
+	{ .name = "d_can_ms", .irq = 55 + OMAP_INTC_START },
+	{ .name = "d_can_mo", .irq = 56 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 static struct omap_hwmod am33xx_dcan1_hwmod = {
@@ -752,7 +752,7 @@ static struct omap_hwmod_class am33xx_elm_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_elm_irqs[] = {
-	{ .irq = 4 },
+	{ .irq = 4 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -790,8 +790,8 @@ static struct omap_hwmod_class am33xx_epwmss_hwmod_class = {
 
 /* ehrpwm0 */
 static struct omap_hwmod_irq_info am33xx_ehrpwm0_irqs[] = {
-	{ .name = "int", .irq = 86 },
-	{ .name = "tzint", .irq = 58 },
+	{ .name = "int", .irq = 86 + OMAP_INTC_START },
+	{ .name = "tzint", .irq = 58 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -811,8 +811,8 @@ static struct omap_hwmod am33xx_ehrpwm0_hwmod = {
 
 /* ehrpwm1 */
 static struct omap_hwmod_irq_info am33xx_ehrpwm1_irqs[] = {
-	{ .name = "int", .irq = 87 },
-	{ .name = "tzint", .irq = 59 },
+	{ .name = "int", .irq = 87 + OMAP_INTC_START },
+	{ .name = "tzint", .irq = 59 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -832,8 +832,8 @@ static struct omap_hwmod am33xx_ehrpwm1_hwmod = {
 
 /* ehrpwm2 */
 static struct omap_hwmod_irq_info am33xx_ehrpwm2_irqs[] = {
-	{ .name = "int", .irq = 39 },
-	{ .name = "tzint", .irq = 60 },
+	{ .name = "int", .irq = 39 + OMAP_INTC_START },
+	{ .name = "tzint", .irq = 60 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -853,7 +853,7 @@ static struct omap_hwmod am33xx_ehrpwm2_hwmod = {
 
 /* ecap0 */
 static struct omap_hwmod_irq_info am33xx_ecap0_irqs[] = {
-	{ .irq = 31 },
+	{ .irq = 31 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -873,7 +873,7 @@ static struct omap_hwmod am33xx_ecap0_hwmod = {
 
 /* ecap1 */
 static struct omap_hwmod_irq_info am33xx_ecap1_irqs[] = {
-	{ .irq = 47 },
+	{ .irq = 47 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -893,7 +893,7 @@ static struct omap_hwmod am33xx_ecap1_hwmod = {
 
 /* ecap2 */
 static struct omap_hwmod_irq_info am33xx_ecap2_irqs[] = {
-	{ .irq = 61 },
+	{ .irq = 61 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -943,7 +943,7 @@ static struct omap_hwmod_opt_clk gpio0_opt_clks[] = {
 };
 
 static struct omap_hwmod_irq_info am33xx_gpio0_irqs[] = {
-	{ .irq = 96 },
+	{ .irq = 96 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -967,7 +967,7 @@ static struct omap_hwmod am33xx_gpio0_hwmod = {
 
 /* gpio1 */
 static struct omap_hwmod_irq_info am33xx_gpio1_irqs[] = {
-	{ .irq = 98 },
+	{ .irq = 98 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -995,7 +995,7 @@ static struct omap_hwmod am33xx_gpio1_hwmod = {
 
 /* gpio2 */
 static struct omap_hwmod_irq_info am33xx_gpio2_irqs[] = {
-	{ .irq = 32 },
+	{ .irq = 32 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1023,7 +1023,7 @@ static struct omap_hwmod am33xx_gpio2_hwmod = {
 
 /* gpio3 */
 static struct omap_hwmod_irq_info am33xx_gpio3_irqs[] = {
-	{ .irq = 62 },
+	{ .irq = 62 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1066,7 +1066,7 @@ static struct omap_hwmod_class am33xx_gpmc_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_gpmc_irqs[] = {
-	{ .irq = 100 },
+	{ .irq = 100 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1111,7 +1111,7 @@ static struct omap_i2c_dev_attr i2c_dev_attr = {
 
 /* i2c1 */
 static struct omap_hwmod_irq_info i2c1_mpu_irqs[] = {
-	{ .irq = 70 },
+	{ .irq = 70 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1140,7 +1140,7 @@ static struct omap_hwmod am33xx_i2c1_hwmod = {
 
 /* i2c1 */
 static struct omap_hwmod_irq_info i2c2_mpu_irqs[] = {
-	{ .irq = 71 },
+	{ .irq = 71 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1175,7 +1175,7 @@ static struct omap_hwmod_dma_info i2c3_edma_reqs[] = {
 };
 
 static struct omap_hwmod_irq_info i2c3_mpu_irqs[] = {
-	{ .irq = 30 },
+	{ .irq = 30 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1212,7 +1212,7 @@ static struct omap_hwmod_class am33xx_lcdc_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_lcdc_irqs[] = {
-	{ .irq = 36 },
+	{ .irq = 36 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1251,7 +1251,7 @@ static struct omap_hwmod_class am33xx_mailbox_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_mailbox_irqs[] = {
-	{ .irq = 77 },
+	{ .irq = 77 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1287,8 +1287,8 @@ static struct omap_hwmod_class am33xx_mcasp_hwmod_class = {
 
 /* mcasp0 */
 static struct omap_hwmod_irq_info am33xx_mcasp0_irqs[] = {
-	{ .name = "ax", .irq = 80, },
-	{ .name = "ar", .irq = 81, },
+	{ .name = "ax", .irq = 80 + OMAP_INTC_START },
+	{ .name = "ar", .irq = 81 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1315,8 +1315,8 @@ static struct omap_hwmod am33xx_mcasp0_hwmod = {
 
 /* mcasp1 */
 static struct omap_hwmod_irq_info am33xx_mcasp1_irqs[] = {
-	{ .name = "ax", .irq = 82, },
-	{ .name = "ar", .irq = 83, },
+	{ .name = "ax", .irq = 82 + OMAP_INTC_START },
+	{ .name = "ar", .irq = 83 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1360,7 +1360,7 @@ static struct omap_hwmod_class am33xx_mmc_hwmod_class = {
 
 /* mmc0 */
 static struct omap_hwmod_irq_info am33xx_mmc0_irqs[] = {
-	{ .irq = 64 },
+	{ .irq = 64 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1392,7 +1392,7 @@ static struct omap_hwmod am33xx_mmc0_hwmod = {
 
 /* mmc1 */
 static struct omap_hwmod_irq_info am33xx_mmc1_irqs[] = {
-	{ .irq = 28 },
+	{ .irq = 28 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1424,7 +1424,7 @@ static struct omap_hwmod am33xx_mmc1_hwmod = {
 
 /* mmc2 */
 static struct omap_hwmod_irq_info am33xx_mmc2_irqs[] = {
-	{ .irq = 29 },
+	{ .irq = 29 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1472,8 +1472,8 @@ static struct omap_hwmod_class am33xx_rtc_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_rtc_irqs[] = {
-	{ .name = "rtcint", .irq = 75 },
-	{ .name = "rtcalarmint", .irq = 76 },
+	{ .name = "rtcint", .irq = 75 + OMAP_INTC_START },
+	{ .name = "rtcalarmint", .irq = 76 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1511,7 +1511,7 @@ static struct omap_hwmod_class am33xx_spi_hwmod_class = {
 
 /* spi0 */
 static struct omap_hwmod_irq_info am33xx_spi0_irqs[] = {
-	{ .irq = 65 },
+	{ .irq = 65 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1544,7 +1544,7 @@ static struct omap_hwmod am33xx_spi0_hwmod = {
 
 /* spi1 */
 static struct omap_hwmod_irq_info am33xx_spi1_irqs[] = {
-	{ .irq = 125 },
+	{ .irq = 125 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1628,7 +1628,7 @@ static struct omap_hwmod_class am33xx_timer1ms_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_timer1_irqs[] = {
-	{ .irq = 67 },
+	{ .irq = 67 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1647,7 +1647,7 @@ static struct omap_hwmod am33xx_timer1_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_timer2_irqs[] = {
-	{ .irq = 68 },
+	{ .irq = 68 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1666,7 +1666,7 @@ static struct omap_hwmod am33xx_timer2_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_timer3_irqs[] = {
-	{ .irq = 69 },
+	{ .irq = 69 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1685,7 +1685,7 @@ static struct omap_hwmod am33xx_timer3_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_timer4_irqs[] = {
-	{ .irq = 92 },
+	{ .irq = 92 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1704,7 +1704,7 @@ static struct omap_hwmod am33xx_timer4_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_timer5_irqs[] = {
-	{ .irq = 93 },
+	{ .irq = 93 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1723,7 +1723,7 @@ static struct omap_hwmod am33xx_timer5_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_timer6_irqs[] = {
-	{ .irq = 94 },
+	{ .irq = 94 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1742,7 +1742,7 @@ static struct omap_hwmod am33xx_timer6_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_timer7_irqs[] = {
-	{ .irq = 95 },
+	{ .irq = 95 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1766,9 +1766,9 @@ static struct omap_hwmod_class am33xx_tpcc_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_tpcc_irqs[] = {
-	{ .name	= "edma0", .irq = 12 },
-	{ .name = "edma0_mperr", .irq = 13, },
-	{ .name	= "edma0_err", .irq = 14 },
+	{ .name	= "edma0", .irq = 12 + OMAP_INTC_START },
+	{ .name = "edma0_mperr", .irq = 13 + OMAP_INTC_START },
+	{ .name	= "edma0_err", .irq = 14 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1803,7 +1803,7 @@ static struct omap_hwmod_class am33xx_tptc_hwmod_class = {
 
 /* tptc0 */
 static struct omap_hwmod_irq_info am33xx_tptc0_irqs[] = {
-	{ .irq = 112 },
+	{ .irq = 112 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1823,7 +1823,7 @@ static struct omap_hwmod am33xx_tptc0_hwmod = {
 
 /* tptc1 */
 static struct omap_hwmod_irq_info am33xx_tptc1_irqs[] = {
-	{ .irq = 113 },
+	{ .irq = 113 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1844,7 +1844,7 @@ static struct omap_hwmod am33xx_tptc1_hwmod = {
 
 /* tptc2 */
 static struct omap_hwmod_irq_info am33xx_tptc2_irqs[] = {
-	{ .irq = 114 },
+	{ .irq = 114 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1888,7 +1888,7 @@ static struct omap_hwmod_dma_info uart1_edma_reqs[] = {
 };
 
 static struct omap_hwmod_irq_info am33xx_uart1_irqs[] = {
-	{ .irq = 72 },
+	{ .irq = 72 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1908,7 +1908,7 @@ static struct omap_hwmod am33xx_uart1_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_uart2_irqs[] = {
-	{ .irq = 73 },
+	{ .irq = 73 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1935,7 +1935,7 @@ static struct omap_hwmod_dma_info uart3_edma_reqs[] = {
 };
 
 static struct omap_hwmod_irq_info am33xx_uart3_irqs[] = {
-	{ .irq = 74 },
+	{ .irq = 74 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1955,7 +1955,7 @@ static struct omap_hwmod am33xx_uart3_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_uart4_irqs[] = {
-	{ .irq = 44 },
+	{ .irq = 44 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1975,7 +1975,7 @@ static struct omap_hwmod am33xx_uart4_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_uart5_irqs[] = {
-	{ .irq = 45 },
+	{ .irq = 45 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -1995,7 +1995,7 @@ static struct omap_hwmod am33xx_uart5_hwmod = {
 };
 
 static struct omap_hwmod_irq_info am33xx_uart6_irqs[] = {
-	{ .irq = 46 },
+	{ .irq = 46 + OMAP_INTC_START },
 	{ .irq = -1 }
 };
 
@@ -2055,9 +2055,9 @@ static struct omap_hwmod_class am33xx_usbotg_class = {
 };
 
 static struct omap_hwmod_irq_info am33xx_usbss_mpu_irqs[] = {
-	{ .name = "usbss-irq", .irq = 17, },
-	{ .name = "musb0-irq", .irq = 18, },
-	{ .name = "musb1-irq", .irq = 19, },
+	{ .name = "usbss-irq", .irq = 17 + OMAP_INTC_START , },
+	{ .name = "musb0-irq", .irq = 18 + OMAP_INTC_START , },
+	{ .name = "musb1-irq", .irq = 19 + OMAP_INTC_START , },
 	{ .irq = -1, },
 };
 
-- 
1.7.0.4

