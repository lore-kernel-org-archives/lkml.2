Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2GKP4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:56:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55860 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2GKP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:56:20 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] mach-omap2: Fix typo in debug message and comment
Date: Thu, 12 Jul 2012 00:56:57 +0900
Message-Id: <1342022217-28522-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.1.104.ge7b44f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correcting spelling typo in mach-omap2

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-omap2/board-apollon.c       | 2 +-
 arch/arm/mach-omap2/board-omap4panda.c    | 2 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c | 2 +-
 arch/arm/mach-omap2/sr_device.c           | 2 +-
 arch/arm/mach-omap2/twl-common.c          | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
index 502c31e..3a8b665 100644
--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -329,7 +329,7 @@ static void __init omap_apollon_init(void)
 	/* LCD PWR_EN */
 	omap_mux_init_signal("mcbsp2_dr.gpio_11", OMAP_PULL_ENA | OMAP_PULL_UP);
 
-	/* Use Interal loop-back in MMC/SDIO Module Input Clock selection */
+	/* Use Internal loop-back in MMC/SDIO Module Input Clock selection */
 	v = omap_ctrl_readl(OMAP2_CONTROL_DEVCONF0);
 	v |= (1 << 24);
 	omap_ctrl_writel(v, OMAP2_CONTROL_DEVCONF0);
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 982fb26..4d2fac5 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -106,7 +106,7 @@ static struct platform_device leds_gpio = {
 static struct omap_abe_twl6040_data panda_abe_audio_data = {
 	/* Audio out */
 	.has_hs		= ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
-	/* HandsFree through expasion connector */
+	/* HandsFree through expansion connector */
 	.has_hf		= ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
 	/* PandaBoard: FM TX, PandaBoardES: can be connected to audio out */
 	.has_aux	= ABE_TWL6040_LEFT | ABE_TWL6040_RIGHT,
diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 13670aa..7787eb8 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -313,7 +313,7 @@ int __cpuinit omap4_hotplug_cpu(unsigned int cpu, unsigned int power_state)
 	scu_pwrst_prepare(cpu, power_state);
 
 	/*
-	 * CPU never retuns back if targetted power state is OFF mode.
+	 * CPU never retuns back if targeted power state is OFF mode.
 	 * CPU ONLINE follows normal CPU ONLINE ptah via
 	 * omap_secondary_startup().
 	 */
diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index a503e1e..62af20f 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -106,7 +106,7 @@ static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
 
 	omap_voltage_get_volttable(sr_data->voltdm, &volt_data);
 	if (!volt_data) {
-		pr_warning("%s: No Voltage table registerd fo VDD%d."
+		pr_warning("%s: No Voltage table registered fo VDD%d."
 			"Something really wrong\n\n", __func__, i + 1);
 		goto exit;
 	}
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index 119d5a9..40d8abb 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -92,7 +92,7 @@ void __init omap4_pmic_init(const char *pmic_type,
 
 void __init omap_pmic_late_init(void)
 {
-	/* Init the OMAP TWL parameters (if PMIC has been registerd) */
+	/* Init the OMAP TWL parameters (if PMIC has been registered) */
 	if (pmic_i2c_board_info.irq)
 		omap3_twl_init();
 	if (omap4_i2c1_board_info[0].irq)
-- 
1.7.11.1.104.ge7b44f1

