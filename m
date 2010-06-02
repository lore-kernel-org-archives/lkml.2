Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0FBLiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:38:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab0FBLiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:38:52 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 10/11] OMAP2: Devkit8000: Remove unused omap_board_config
Date: Wed,  2 Jun 2010 13:37:50 +0200
Message-Id: <1275478671-24563-11-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275478671-24563-1-git-send-email-weber@corscience.de>
References: <1275478671-24563-1-git-send-email-weber@corscience.de>
X-Provags-ID: V01U2FsdGVkX1/wwAPkfP5QS0R+Zk/RYT1F68jjEDXERxcOpDk
 CvsaH4KNJ+BOglDC9X4NSVjsUWOLaFWPlxzvRmAbkMLjdo5OhD
 seVN75xuA1C2PVBRFfEnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_board_config is no longer used and thats why empty.
This patch removes the empty omap_board_config.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index dbd16de..a485d39 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -126,8 +126,6 @@ static struct omap2_hsmmc_info mmc[] = {
 	},
 	{}	/* Terminator */
 };
-static struct omap_board_config_kernel devkit8000_config[] __initdata = {
-};
 
 static int devkit8000_panel_enable_lcd(struct omap_dss_device *dssdev)
 {
@@ -464,8 +462,6 @@ static struct platform_device keys_gpio = {
 
 static void __init devkit8000_init_irq(void)
 {
-	omap_board_config = devkit8000_config;
-	omap_board_config_size = ARRAY_SIZE(devkit8000_config);
 	omap2_init_common_hw(mt46h32m32lf6_sdrc_params,
 			     mt46h32m32lf6_sdrc_params);
 	omap_init_irq();
@@ -797,8 +793,6 @@ static void __init devkit8000_init(void)
 	devkit8000_i2c_init();
 	platform_add_devices(devkit8000_devices,
 			ARRAY_SIZE(devkit8000_devices));
-	omap_board_config = devkit8000_config;
-	omap_board_config_size = ARRAY_SIZE(devkit8000_config);
 
 	spi_register_board_info(devkit8000_spi_board_info,
 	ARRAY_SIZE(devkit8000_spi_board_info));
-- 
1.7.1

