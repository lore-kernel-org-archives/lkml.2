Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab0LCPcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:32:18 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:35326 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab0LCPcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:32:14 -0500
X-Greylist: delayed 1535 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Dec 2010 10:32:14 EST
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 19/20] mach-ux500: clean up checkpatch spits
Date: Fri, 3 Dec 2010 20:35:52 +0530
Message-ID: <1291388753-14662-20-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/clock.c |  118 +++++++++++++++++++++---------------------
 1 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/arch/arm/mach-ux500/clock.c b/arch/arm/mach-ux500/clock.c
index 6657b05..ca01368 100644
--- a/arch/arm/mach-ux500/clock.c
+++ b/arch/arm/mach-ux500/clock.c
@@ -334,92 +334,92 @@ static DEFINE_PRCMU_CLK(uiccclk,	0x4, 1, UICCCLK); /* v1 */
  */
 
 /* Peripheral Cluster #1 */
-static DEFINE_PRCC_CLK(1, i2c4, 	10, 9, &clk_i2cclk);
+static DEFINE_PRCC_CLK(1, i2c4,		10, 9, &clk_i2cclk);
 static DEFINE_PRCC_CLK(1, gpio0,	9, -1, NULL);
-static DEFINE_PRCC_CLK(1, slimbus0, 	8,  8, &clk_slimclk);
-static DEFINE_PRCC_CLK(1, spi3_ed, 	7,  7, NULL);
-static DEFINE_PRCC_CLK(1, spi3_v1, 	7, -1, NULL);
-static DEFINE_PRCC_CLK(1, i2c2, 	6,  6, &clk_i2cclk);
+static DEFINE_PRCC_CLK(1, slimbus0,	8,  8, &clk_slimclk);
+static DEFINE_PRCC_CLK(1, spi3_ed,	7,  7, NULL);
+static DEFINE_PRCC_CLK(1, spi3_v1,	7, -1, NULL);
+static DEFINE_PRCC_CLK(1, i2c2,		6,  6, &clk_i2cclk);
 static DEFINE_PRCC_CLK(1, sdi0,		5,  5, &clk_sdmmcclk);
-static DEFINE_PRCC_CLK(1, msp1_ed, 	4,  4, &clk_msp02clk);
-static DEFINE_PRCC_CLK(1, msp1_v1, 	4,  4, &clk_msp1clk);
-static DEFINE_PRCC_CLK(1, msp0, 	3,  3, &clk_msp02clk);
-static DEFINE_PRCC_CLK(1, i2c1, 	2,  2, &clk_i2cclk);
-static DEFINE_PRCC_CLK(1, uart1, 	1,  1, &clk_uartclk);
-static DEFINE_PRCC_CLK(1, uart0, 	0,  0, &clk_uartclk);
+static DEFINE_PRCC_CLK(1, msp1_ed,	4,  4, &clk_msp02clk);
+static DEFINE_PRCC_CLK(1, msp1_v1,	4,  4, &clk_msp1clk);
+static DEFINE_PRCC_CLK(1, msp0,		3,  3, &clk_msp02clk);
+static DEFINE_PRCC_CLK(1, i2c1,		2,  2, &clk_i2cclk);
+static DEFINE_PRCC_CLK(1, uart1,	1,  1, &clk_uartclk);
+static DEFINE_PRCC_CLK(1, uart0,	0,  0, &clk_uartclk);
 
 /* Peripheral Cluster #2 */
 
 static DEFINE_PRCC_CLK(2, gpio1_ed,	12, -1, NULL);
-static DEFINE_PRCC_CLK(2, ssitx_ed, 	11, -1, NULL);
-static DEFINE_PRCC_CLK(2, ssirx_ed, 	10, -1, NULL);
-static DEFINE_PRCC_CLK(2, spi0_ed, 	 9, -1, NULL);
-static DEFINE_PRCC_CLK(2, sdi3_ed, 	 8,  6, &clk_sdmmcclk);
-static DEFINE_PRCC_CLK(2, sdi1_ed, 	 7,  5, &clk_sdmmcclk);
-static DEFINE_PRCC_CLK(2, msp2_ed, 	 6,  4, &clk_msp02clk);
-static DEFINE_PRCC_CLK(2, sdi4_ed, 	 4,  2, &clk_sdmmcclk);
+static DEFINE_PRCC_CLK(2, ssitx_ed,	11, -1, NULL);
+static DEFINE_PRCC_CLK(2, ssirx_ed,	10, -1, NULL);
+static DEFINE_PRCC_CLK(2, spi0_ed,	 9, -1, NULL);
+static DEFINE_PRCC_CLK(2, sdi3_ed,	 8,  6, &clk_sdmmcclk);
+static DEFINE_PRCC_CLK(2, sdi1_ed,	 7,  5, &clk_sdmmcclk);
+static DEFINE_PRCC_CLK(2, msp2_ed,	 6,  4, &clk_msp02clk);
+static DEFINE_PRCC_CLK(2, sdi4_ed,	 4,  2, &clk_sdmmcclk);
 static DEFINE_PRCC_CLK(2, pwl_ed,	 3,  1, NULL);
-static DEFINE_PRCC_CLK(2, spi1_ed, 	 2, -1, NULL);
-static DEFINE_PRCC_CLK(2, spi2_ed, 	 1, -1, NULL);
-static DEFINE_PRCC_CLK(2, i2c3_ed, 	 0,  0, &clk_i2cclk);
+static DEFINE_PRCC_CLK(2, spi1_ed,	 2, -1, NULL);
+static DEFINE_PRCC_CLK(2, spi2_ed,	 1, -1, NULL);
+static DEFINE_PRCC_CLK(2, i2c3_ed,	 0,  0, &clk_i2cclk);
 
 static DEFINE_PRCC_CLK(2, gpio1_v1,	11, -1, NULL);
-static DEFINE_PRCC_CLK(2, ssitx_v1, 	10,  7, NULL);
-static DEFINE_PRCC_CLK(2, ssirx_v1, 	 9,  6, NULL);
-static DEFINE_PRCC_CLK(2, spi0_v1, 	 8, -1, NULL);
-static DEFINE_PRCC_CLK(2, sdi3_v1, 	 7,  5, &clk_sdmmcclk);
-static DEFINE_PRCC_CLK(2, sdi1_v1, 	 6,  4, &clk_sdmmcclk);
-static DEFINE_PRCC_CLK(2, msp2_v1, 	 5,  3, &clk_msp02clk);
-static DEFINE_PRCC_CLK(2, sdi4_v1, 	 4,  2, &clk_sdmmcclk);
+static DEFINE_PRCC_CLK(2, ssitx_v1,	10,  7, NULL);
+static DEFINE_PRCC_CLK(2, ssirx_v1,	 9,  6, NULL);
+static DEFINE_PRCC_CLK(2, spi0_v1,	 8, -1, NULL);
+static DEFINE_PRCC_CLK(2, sdi3_v1,	 7,  5, &clk_sdmmcclk);
+static DEFINE_PRCC_CLK(2, sdi1_v1,	 6,  4, &clk_sdmmcclk);
+static DEFINE_PRCC_CLK(2, msp2_v1,	 5,  3, &clk_msp02clk);
+static DEFINE_PRCC_CLK(2, sdi4_v1,	 4,  2, &clk_sdmmcclk);
 static DEFINE_PRCC_CLK(2, pwl_v1,	 3,  1, NULL);
-static DEFINE_PRCC_CLK(2, spi1_v1, 	 2, -1, NULL);
-static DEFINE_PRCC_CLK(2, spi2_v1, 	 1, -1, NULL);
-static DEFINE_PRCC_CLK(2, i2c3_v1, 	 0,  0, &clk_i2cclk);
+static DEFINE_PRCC_CLK(2, spi1_v1,	 2, -1, NULL);
+static DEFINE_PRCC_CLK(2, spi2_v1,	 1, -1, NULL);
+static DEFINE_PRCC_CLK(2, i2c3_v1,	 0,  0, &clk_i2cclk);
 
 /* Peripheral Cluster #3 */
-static DEFINE_PRCC_CLK(3, gpio2, 	8, -1, NULL);
-static DEFINE_PRCC_CLK(3, sdi5, 	7,  7, &clk_sdmmcclk);
-static DEFINE_PRCC_CLK(3, uart2, 	6,  6, &clk_uartclk);
-static DEFINE_PRCC_CLK(3, ske, 		5,  5, &clk_32khz);
-static DEFINE_PRCC_CLK(3, sdi2, 	4,  4, &clk_sdmmcclk);
-static DEFINE_PRCC_CLK(3, i2c0, 	3,  3, &clk_i2cclk);
-static DEFINE_PRCC_CLK(3, ssp1_ed, 	2,  2, &clk_i2cclk);
-static DEFINE_PRCC_CLK(3, ssp0_ed, 	1,  1, &clk_i2cclk);
-static DEFINE_PRCC_CLK(3, ssp1_v1, 	2,  2, &clk_sspclk);
-static DEFINE_PRCC_CLK(3, ssp0_v1, 	1,  1, &clk_sspclk);
-static DEFINE_PRCC_CLK(3, fsmc, 	0, -1, NULL);
+static DEFINE_PRCC_CLK(3, gpio2,	8, -1, NULL);
+static DEFINE_PRCC_CLK(3, sdi5,		7,  7, &clk_sdmmcclk);
+static DEFINE_PRCC_CLK(3, uart2,	6,  6, &clk_uartclk);
+static DEFINE_PRCC_CLK(3, ske,		5,  5, &clk_32khz);
+static DEFINE_PRCC_CLK(3, sdi2,		4,  4, &clk_sdmmcclk);
+static DEFINE_PRCC_CLK(3, i2c0,		3,  3, &clk_i2cclk);
+static DEFINE_PRCC_CLK(3, ssp1_ed,	2,  2, &clk_i2cclk);
+static DEFINE_PRCC_CLK(3, ssp0_ed,	1,  1, &clk_i2cclk);
+static DEFINE_PRCC_CLK(3, ssp1_v1,	2,  2, &clk_sspclk);
+static DEFINE_PRCC_CLK(3, ssp0_v1,	1,  1, &clk_sspclk);
+static DEFINE_PRCC_CLK(3, fsmc,		0, -1, NULL);
 
 /* Peripheral Cluster #4 is in the always on domain */
 
 /* Peripheral Cluster #5 */
-static DEFINE_PRCC_CLK(5, gpio3, 	1, -1, NULL);
-static DEFINE_PRCC_CLK(5, usb_ed, 	0,  0, &clk_i2cclk);
-static DEFINE_PRCC_CLK(5, usb_v1, 	0,  0, NULL);
+static DEFINE_PRCC_CLK(5, gpio3,	1, -1, NULL);
+static DEFINE_PRCC_CLK(5, usb_ed,	0,  0, &clk_i2cclk);
+static DEFINE_PRCC_CLK(5, usb_v1,	0,  0, NULL);
 
 /* Peripheral Cluster #6 */
 
 /* MTU ID in data */
 static DEFINE_PRCC_CLK_CUSTOM(6, mtu1_v1, 8, -1, NULL, clk_mtu_get_rate, 1);
 static DEFINE_PRCC_CLK_CUSTOM(6, mtu0_v1, 7, -1, NULL, clk_mtu_get_rate, 0);
-static DEFINE_PRCC_CLK(6, cfgreg_v1, 	6,  6, NULL);
-static DEFINE_PRCC_CLK(6, dmc_ed, 	6,  6, NULL);
-static DEFINE_PRCC_CLK(6, hash1, 	5, -1, NULL);
-static DEFINE_PRCC_CLK(6, unipro_v1, 	4,  1, &clk_uniproclk);
-static DEFINE_PRCC_CLK(6, cryp1_ed, 	4, -1, NULL);
-static DEFINE_PRCC_CLK(6, pka, 		3, -1, NULL);
-static DEFINE_PRCC_CLK(6, hash0, 	2, -1, NULL);
-static DEFINE_PRCC_CLK(6, cryp0, 	1, -1, NULL);
-static DEFINE_PRCC_CLK(6, rng_ed, 	0,  0, &clk_i2cclk);
-static DEFINE_PRCC_CLK(6, rng_v1, 	0,  0, &clk_rngclk);
+static DEFINE_PRCC_CLK(6, cfgreg_v1,	6,  6, NULL);
+static DEFINE_PRCC_CLK(6, dmc_ed,	6,  6, NULL);
+static DEFINE_PRCC_CLK(6, hash1,	5, -1, NULL);
+static DEFINE_PRCC_CLK(6, unipro_v1,	4,  1, &clk_uniproclk);
+static DEFINE_PRCC_CLK(6, cryp1_ed,	4, -1, NULL);
+static DEFINE_PRCC_CLK(6, pka,		3, -1, NULL);
+static DEFINE_PRCC_CLK(6, hash0,	2, -1, NULL);
+static DEFINE_PRCC_CLK(6, cryp0,	1, -1, NULL);
+static DEFINE_PRCC_CLK(6, rng_ed,	0,  0, &clk_i2cclk);
+static DEFINE_PRCC_CLK(6, rng_v1,	0,  0, &clk_rngclk);
 
 /* Peripheral Cluster #7 */
 
-static DEFINE_PRCC_CLK(7, tzpc0_ed, 	4, -1, NULL);
+static DEFINE_PRCC_CLK(7, tzpc0_ed,	4, -1, NULL);
 /* MTU ID in data */
 static DEFINE_PRCC_CLK_CUSTOM(7, mtu1_ed, 3, -1, NULL, clk_mtu_get_rate, 1);
 static DEFINE_PRCC_CLK_CUSTOM(7, mtu0_ed, 2, -1, NULL, clk_mtu_get_rate, 0);
-static DEFINE_PRCC_CLK(7, wdg_ed, 	1, -1, NULL);
-static DEFINE_PRCC_CLK(7, cfgreg_ed, 	0, -1, NULL);
+static DEFINE_PRCC_CLK(7, wdg_ed,	1, -1, NULL);
+static DEFINE_PRCC_CLK(7, cfgreg_ed,	0, -1, NULL);
 
 static struct clk clk_dummy_apb_pclk;
 
@@ -522,7 +522,7 @@ static struct clk_lookup u8500_ed_clks[] = {
 
 static struct clk_lookup u8500_v1_clks[] = {
 	/* Peripheral Cluster #1 */
-	CLK(i2c4,	"nmk-i2c.4", 	NULL),
+	CLK(i2c4,	"nmk-i2c.4",	NULL),
 	CLK(spi3_v1,	"spi3",		NULL),
 	CLK(msp1_v1,	"msp1",		NULL),
 
-- 
1.7.2.dirty

