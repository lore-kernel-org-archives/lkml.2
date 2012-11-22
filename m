Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2KVTMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:12:42 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33966 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2KVTMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:12:39 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Rename dbx500 cpufreq code to be more generic
Date: Thu, 22 Nov 2012 16:31:39 +0000
Message-Id: <1353601899-14648-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq driver doesn't only handle the db8500 anymore. There
are new variants which rely on it too, so we've renamed the
driver to be more generic.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index d2076ce..4c6ce01 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -222,7 +222,7 @@ struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
 	db8500_add_usb(parent, usb_db8500_rx_dma_cfg, usb_db8500_tx_dma_cfg);
 
 	platform_device_register_data(parent,
-		"cpufreq-u8500", -1, NULL, 0);
+		"cpufreq-ux500", -1, NULL, 0);
 
 	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
 		platform_devs[i]->dev.parent = parent;
@@ -244,7 +244,7 @@ static struct device * __init u8500_of_init_devices(void)
 	db8500_add_usb(parent, usb_db8500_rx_dma_cfg, usb_db8500_tx_dma_cfg);
 
 	platform_device_register_data(parent,
-		"cpufreq-u8500", -1, NULL, 0);
+		"cpufreq-ux500", -1, NULL, 0);
 
 	u8500_dma40_device.dev.parent = parent;
 
-- 
1.7.9.5

