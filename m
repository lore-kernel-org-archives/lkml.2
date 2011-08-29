Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1H2Esw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 00:48:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33194 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1H2Esq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 00:48:46 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, grant.likely@secretlab.ca, lethal@linux-sh.org,
        rpurdie@rpsys.net, Magnus Damm <magnus.damm@gmail.com>,
        akpm@linux-foundation.org
Date: Mon, 29 Aug 2011 13:50:18 +0900
Message-Id: <20110829045018.23165.42899.sendpatchset@rxone.opensource.se>
Subject: [PATCH] leds: Move Renesas TPU LED driver platform data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use the platform_data include directory for the
TPU LED driver, as suggested by Paul Mundt.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/leds/leds-renesas-tpu.c                |    2 +-
 include/linux/leds-renesas-tpu.h               |   14 --------------
 include/linux/platform_data/leds-renesas-tpu.h |   14 ++++++++++++++
 3 files changed, 15 insertions(+), 15 deletions(-)

--- 0016/drivers/leds/leds-renesas-tpu.c
+++ work/drivers/leds/leds-renesas-tpu.c	2011-08-29 13:39:21.000000000 +0900
@@ -26,7 +26,7 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/leds.h>
-#include <linux/leds-renesas-tpu.h>
+#include <linux/platform_data/leds-renesas-tpu.h>
 #include <linux/gpio.h>
 #include <linux/err.h>
 #include <linux/slab.h>
--- 0015/include/linux/leds-renesas-tpu.h
+++ /dev/null	2011-08-29 11:06:11.184294567 +0900
@@ -1,14 +0,0 @@
-#ifndef __LEDS_RENESAS_TPU_H__
-#define __LEDS_RENESAS_TPU_H__
-
-struct led_renesas_tpu_config {
-	char *name;
-	unsigned pin_gpio_fn;
-	unsigned pin_gpio;
-	unsigned int channel_offset;
-	unsigned int timer_bit;
-	unsigned int max_brightness;
-	unsigned int refresh_rate;
-};
-
-#endif /* __LEDS_RENESAS_TPU_H__ */
--- /dev/null
+++ work/include/linux/platform_data/leds-renesas-tpu.h	2011-08-29 13:13:35.000000000 +0900
@@ -0,0 +1,14 @@
+#ifndef __LEDS_RENESAS_TPU_H__
+#define __LEDS_RENESAS_TPU_H__
+
+struct led_renesas_tpu_config {
+	char *name;
+	unsigned pin_gpio_fn;
+	unsigned pin_gpio;
+	unsigned int channel_offset;
+	unsigned int timer_bit;
+	unsigned int max_brightness;
+	unsigned int refresh_rate;
+};
+
+#endif /* __LEDS_RENESAS_TPU_H__ */
