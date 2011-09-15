Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770Ab1IOUPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:15:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:47975 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934683Ab1IOUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="49297071"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, linux@arm.linux.org.uk
Subject: [PATCH 01/27] Initconst section fixes for ARM
Date: Thu, 15 Sep 2011 13:09:28 -0700
Message-Id: <1316117394-21666-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: linux@arm.linux.org.uk
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/arm/mach-at91/clock.c                  |    2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c |    6 ++--
 arch/arm/mach-davinci/da830.c               |   48 +++++++++++++-------------
 arch/arm/mach-davinci/da850.c               |    6 ++--
 arch/arm/mach-msm/board-qsd8x50.c           |    4 +-
 arch/arm/mach-omap2/display.c               |    6 ++--
 arch/arm/mach-omap2/pm24xx.c                |    2 +-
 arch/arm/plat-omap/dmtimer.c                |    6 ++--
 8 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 61873f3..9796a92 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -570,7 +570,7 @@ fail:
 	return 0;
 }
 
-static struct clk *const standard_pmc_clocks[] __initdata = {
+static struct clk *const standard_pmc_clocks[] __initconst = {
 	/* four primary clocks */
 	&clk32k,
 	&main_clk,
diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index 7828920..84f4763 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -88,7 +88,7 @@ static struct davinci_mmc_config mmc_config = {
 	.version	= MMC_CTLR_VERSION_1,
 };
 
-static const short sdio1_pins[] __initdata = {
+static const short sdio1_pins[] __initconst = {
 	TNETV107X_SDIO1_CLK_1,		TNETV107X_SDIO1_CMD_1,
 	TNETV107X_SDIO1_DATA0_1,	TNETV107X_SDIO1_DATA1_1,
 	TNETV107X_SDIO1_DATA2_1,	TNETV107X_SDIO1_DATA3_1,
@@ -96,12 +96,12 @@ static const short sdio1_pins[] __initdata = {
 	-1
 };
 
-static const short uart1_pins[] __initdata = {
+static const short uart1_pins[] __initconst = {
 	TNETV107X_UART1_RD,		TNETV107X_UART1_TD,
 	-1
 };
 
-static const short ssp_pins[] __initdata = {
+static const short ssp_pins[] __initconst = {
 	TNETV107X_SSP0_0, TNETV107X_SSP0_1, TNETV107X_SSP0_2,
 	TNETV107X_SSP1_0, TNETV107X_SSP1_1, TNETV107X_SSP1_2,
 	TNETV107X_SSP1_3, -1
diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index 2ed2f82..5a891fa 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -837,7 +837,7 @@ static const struct mux_config da830_pins[] = {
 #endif
 };
 
-const short da830_emif25_pins[] __initdata = {
+const short da830_emif25_pins[] __initconst = {
 	DA830_EMA_D_0, DA830_EMA_D_1, DA830_EMA_D_2, DA830_EMA_D_3,
 	DA830_EMA_D_4, DA830_EMA_D_5, DA830_EMA_D_6, DA830_EMA_D_7,
 	DA830_EMA_D_8, DA830_EMA_D_9, DA830_EMA_D_10, DA830_EMA_D_11,
@@ -852,19 +852,19 @@ const short da830_emif25_pins[] __initdata = {
 	-1
 };
 
-const short da830_spi0_pins[] __initdata = {
+const short da830_spi0_pins[] __initconst = {
 	DA830_SPI0_SOMI_0, DA830_SPI0_SIMO_0, DA830_SPI0_CLK, DA830_NSPI0_ENA,
 	DA830_NSPI0_SCS_0,
 	-1
 };
 
-const short da830_spi1_pins[] __initdata = {
+const short da830_spi1_pins[] __initconst = {
 	DA830_SPI1_SOMI_0, DA830_SPI1_SIMO_0, DA830_SPI1_CLK, DA830_NSPI1_ENA,
 	DA830_NSPI1_SCS_0,
 	-1
 };
 
-const short da830_mmc_sd_pins[] __initdata = {
+const short da830_mmc_sd_pins[] __initconst = {
 	DA830_MMCSD_DAT_0, DA830_MMCSD_DAT_1, DA830_MMCSD_DAT_2,
 	DA830_MMCSD_DAT_3, DA830_MMCSD_DAT_4, DA830_MMCSD_DAT_5,
 	DA830_MMCSD_DAT_6, DA830_MMCSD_DAT_7, DA830_MMCSD_CLK,
@@ -872,32 +872,32 @@ const short da830_mmc_sd_pins[] __initdata = {
 	-1
 };
 
-const short da830_uart0_pins[] __initdata = {
+const short da830_uart0_pins[] __initconst = {
 	DA830_NUART0_CTS, DA830_NUART0_RTS, DA830_UART0_RXD, DA830_UART0_TXD,
 	-1
 };
 
-const short da830_uart1_pins[] __initdata = {
+const short da830_uart1_pins[] __initconst = {
 	DA830_UART1_RXD, DA830_UART1_TXD,
 	-1
 };
 
-const short da830_uart2_pins[] __initdata = {
+const short da830_uart2_pins[] __initconst = {
 	DA830_UART2_RXD, DA830_UART2_TXD,
 	-1
 };
 
-const short da830_usb20_pins[] __initdata = {
+const short da830_usb20_pins[] __initconst = {
 	DA830_USB0_DRVVBUS, DA830_USB_REFCLKIN,
 	-1
 };
 
-const short da830_usb11_pins[] __initdata = {
+const short da830_usb11_pins[] __initconst = {
 	DA830_USB_REFCLKIN,
 	-1
 };
 
-const short da830_uhpi_pins[] __initdata = {
+const short da830_uhpi_pins[] __initconst = {
 	DA830_UHPI_HD_0, DA830_UHPI_HD_1, DA830_UHPI_HD_2, DA830_UHPI_HD_3,
 	DA830_UHPI_HD_4, DA830_UHPI_HD_5, DA830_UHPI_HD_6, DA830_UHPI_HD_7,
 	DA830_UHPI_HD_8, DA830_UHPI_HD_9, DA830_UHPI_HD_10, DA830_UHPI_HD_11,
@@ -908,14 +908,14 @@ const short da830_uhpi_pins[] __initdata = {
 	-1
 };
 
-const short da830_cpgmac_pins[] __initdata = {
+const short da830_cpgmac_pins[] __initconst = {
 	DA830_RMII_TXD_0, DA830_RMII_TXD_1, DA830_RMII_TXEN, DA830_RMII_CRS_DV,
 	DA830_RMII_RXD_0, DA830_RMII_RXD_1, DA830_RMII_RXER, DA830_MDIO_CLK,
 	DA830_MDIO_D,
 	-1
 };
 
-const short da830_emif3c_pins[] __initdata = {
+const short da830_emif3c_pins[] __initconst = {
 	DA830_EMB_SDCKE, DA830_EMB_CLK_GLUE, DA830_EMB_CLK, DA830_NEMB_CS_0,
 	DA830_NEMB_CAS, DA830_NEMB_RAS, DA830_NEMB_WE, DA830_EMB_BA_1,
 	DA830_EMB_BA_0, DA830_EMB_A_0, DA830_EMB_A_1, DA830_EMB_A_2,
@@ -934,7 +934,7 @@ const short da830_emif3c_pins[] __initdata = {
 	-1
 };
 
-const short da830_mcasp0_pins[] __initdata = {
+const short da830_mcasp0_pins[] __initconst = {
 	DA830_AHCLKX0, DA830_ACLKX0, DA830_AFSX0,
 	DA830_AHCLKR0, DA830_ACLKR0, DA830_AFSR0, DA830_AMUTE0,
 	DA830_AXR0_0, DA830_AXR0_1, DA830_AXR0_2, DA830_AXR0_3,
@@ -944,7 +944,7 @@ const short da830_mcasp0_pins[] __initdata = {
 	-1
 };
 
-const short da830_mcasp1_pins[] __initdata = {
+const short da830_mcasp1_pins[] __initconst = {
 	DA830_AHCLKX1, DA830_ACLKX1, DA830_AFSX1,
 	DA830_AHCLKR1, DA830_ACLKR1, DA830_AFSR1, DA830_AMUTE1,
 	DA830_AXR1_0, DA830_AXR1_1, DA830_AXR1_2, DA830_AXR1_3,
@@ -953,24 +953,24 @@ const short da830_mcasp1_pins[] __initdata = {
 	-1
 };
 
-const short da830_mcasp2_pins[] __initdata = {
+const short da830_mcasp2_pins[] __initconst = {
 	DA830_AHCLKX2, DA830_ACLKX2, DA830_AFSX2,
 	DA830_AHCLKR2, DA830_ACLKR2, DA830_AFSR2, DA830_AMUTE2,
 	DA830_AXR2_0, DA830_AXR2_1, DA830_AXR2_2, DA830_AXR2_3,
 	-1
 };
 
-const short da830_i2c0_pins[] __initdata = {
+const short da830_i2c0_pins[] __initconst = {
 	DA830_I2C0_SDA, DA830_I2C0_SCL,
 	-1
 };
 
-const short da830_i2c1_pins[] __initdata = {
+const short da830_i2c1_pins[] __initconst = {
 	DA830_I2C1_SCL, DA830_I2C1_SDA,
 	-1
 };
 
-const short da830_lcdcntl_pins[] __initdata = {
+const short da830_lcdcntl_pins[] __initconst = {
 	DA830_LCD_D_0, DA830_LCD_D_1, DA830_LCD_D_2, DA830_LCD_D_3,
 	DA830_LCD_D_4, DA830_LCD_D_5, DA830_LCD_D_6, DA830_LCD_D_7,
 	DA830_LCD_D_8, DA830_LCD_D_9, DA830_LCD_D_10, DA830_LCD_D_11,
@@ -980,34 +980,34 @@ const short da830_lcdcntl_pins[] __initdata = {
 	-1
 };
 
-const short da830_pwm_pins[] __initdata = {
+const short da830_pwm_pins[] __initconst = {
 	DA830_ECAP0_APWM0, DA830_ECAP1_APWM1, DA830_EPWM0B, DA830_EPWM0A,
 	DA830_EPWMSYNCI, DA830_EPWMSYNC0, DA830_ECAP2_APWM2, DA830_EHRPWMGLUETZ,
 	DA830_EPWM2B, DA830_EPWM2A, DA830_EPWM1B, DA830_EPWM1A,
 	-1
 };
 
-const short da830_ecap0_pins[] __initdata = {
+const short da830_ecap0_pins[] __initconst = {
 	DA830_ECAP0_APWM0,
 	-1
 };
 
-const short da830_ecap1_pins[] __initdata = {
+const short da830_ecap1_pins[] __initconst = {
 	DA830_ECAP1_APWM1,
 	-1
 };
 
-const short da830_ecap2_pins[] __initdata = {
+const short da830_ecap2_pins[] __initconst = {
 	DA830_ECAP2_APWM2,
 	-1
 };
 
-const short da830_eqep0_pins[] __initdata = {
+const short da830_eqep0_pins[] __initconst = {
 	DA830_EQEP0I, DA830_EQEP0S, DA830_EQEP0A, DA830_EQEP0B,
 	-1
 };
 
-const short da830_eqep1_pins[] __initdata = {
+const short da830_eqep1_pins[] __initconst = {
 	DA830_EQEP1I, DA830_EQEP1S, DA830_EQEP1A, DA830_EQEP1B,
 	-1
 };
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 935dbed..8587daf 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -598,17 +598,17 @@ static const struct mux_config da850_pins[] = {
 #endif
 };
 
-const short da850_i2c0_pins[] __initdata = {
+const short da850_i2c0_pins[] __initconst = {
 	DA850_I2C0_SDA, DA850_I2C0_SCL,
 	-1
 };
 
-const short da850_i2c1_pins[] __initdata = {
+const short da850_i2c1_pins[] __initconst = {
 	DA850_I2C1_SCL, DA850_I2C1_SDA,
 	-1
 };
 
-const short da850_lcdcntl_pins[] __initdata = {
+const short da850_lcdcntl_pins[] __initconst = {
 	DA850_LCD_D_0, DA850_LCD_D_1, DA850_LCD_D_2, DA850_LCD_D_3,
 	DA850_LCD_D_4, DA850_LCD_D_5, DA850_LCD_D_6, DA850_LCD_D_7,
 	DA850_LCD_D_8, DA850_LCD_D_9, DA850_LCD_D_10, DA850_LCD_D_11,
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 6a96911..c8145d6 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -40,8 +40,8 @@
 
 extern struct sys_timer msm_timer;
 
-static const resource_size_t qsd8x50_surf_smc91x_base __initdata = 0x70000300;
-static const unsigned        qsd8x50_surf_smc91x_gpio __initdata = 156;
+static const resource_size_t qsd8x50_surf_smc91x_base __initconst = 0x70000300;
+static const unsigned        qsd8x50_surf_smc91x_gpio __initconst = 156;
 
 /* Leave smc91x resources empty here, as we'll fill them in
  * at run-time: they vary from board to board, and the true
diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index a5b7a23..57757c0 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -49,14 +49,14 @@ struct omap_dss_hwmod_data {
 	const int id;
 };
 
-static const struct omap_dss_hwmod_data omap2_dss_hwmod_data[] __initdata = {
+static const struct omap_dss_hwmod_data omap2_dss_hwmod_data[] __initconst = {
 	{ "dss_core", "omapdss_dss", -1 },
 	{ "dss_dispc", "omapdss_dispc", -1 },
 	{ "dss_rfbi", "omapdss_rfbi", -1 },
 	{ "dss_venc", "omapdss_venc", -1 },
 };
 
-static const struct omap_dss_hwmod_data omap3_dss_hwmod_data[] __initdata = {
+static const struct omap_dss_hwmod_data omap3_dss_hwmod_data[] __initconst = {
 	{ "dss_core", "omapdss_dss", -1 },
 	{ "dss_dispc", "omapdss_dispc", -1 },
 	{ "dss_rfbi", "omapdss_rfbi", -1 },
@@ -64,7 +64,7 @@ static const struct omap_dss_hwmod_data omap3_dss_hwmod_data[] __initdata = {
 	{ "dss_dsi1", "omapdss_dsi1", -1 },
 };
 
-static const struct omap_dss_hwmod_data omap4_dss_hwmod_data[] __initdata = {
+static const struct omap_dss_hwmod_data omap4_dss_hwmod_data[] __initconst = {
 	{ "dss_core", "omapdss_dss", -1 },
 	{ "dss_dispc", "omapdss_dispc", -1 },
 	{ "dss_rfbi", "omapdss_rfbi", -1 },
diff --git a/arch/arm/mach-omap2/pm24xx.c b/arch/arm/mach-omap2/pm24xx.c
index bf089e7..0de69b0 100644
--- a/arch/arm/mach-omap2/pm24xx.c
+++ b/arch/arm/mach-omap2/pm24xx.c
@@ -355,7 +355,7 @@ static const struct platform_suspend_ops omap_pm_ops = {
 	.valid		= suspend_valid_only_mem,
 };
 #else
-static const struct platform_suspend_ops __initdata omap_pm_ops;
+static const struct platform_suspend_ops __initconst omap_pm_ops;
 #endif /* CONFIG_SUSPEND */
 
 /* XXX This function should be shareable between OMAP2xxx and OMAP3 */
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 75a847d..30a38a2 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -78,7 +78,7 @@ static struct omap_dm_timer omap2_dm_timers[] = {
 	{ .phys_base = 0x4808a000, .irq = INT_24XX_GPTIMER12 },
 };
 
-static const char *omap2_dm_source_names[] __initdata = {
+static const char * const omap2_dm_source_names[] __initconst = {
 	"sys_ck",
 	"func_32k_ck",
 	"alt_ck",
@@ -111,7 +111,7 @@ static struct omap_dm_timer omap3_dm_timers[] = {
 	{ .phys_base = 0x48304000, .irq = INT_34XX_GPT12_IRQ },
 };
 
-static const char *omap3_dm_source_names[] __initdata = {
+static const char * const omap3_dm_source_names[] __initconst = {
 	"sys_ck",
 	"omap_32k_fck",
 	NULL
@@ -142,7 +142,7 @@ static struct omap_dm_timer omap4_dm_timers[] = {
 	{ .phys_base = 0x48088000, .irq = OMAP44XX_IRQ_GPT11 },
 	{ .phys_base = 0x4a320000, .irq = OMAP44XX_IRQ_GPT12 },
 };
-static const char *omap4_dm_source_names[] __initdata = {
+static const char * const omap4_dm_source_names[] __initconst = {
 	"sys_clkin_ck",
 	"sys_32k_ck",
 	NULL
-- 
1.7.4.4

