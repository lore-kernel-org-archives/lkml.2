Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2BDQUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:20:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34855 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855Ab2BDQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:20:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] leds: Use linux/gpio.h rather than asm/gpio.h
Date: Sat,  4 Feb 2012 16:20:09 +0000
Message-Id: <1328372409-28089-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct usage of the asm include has long been deprecated by the
introduction of gpiolib.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/leds/leds-gpio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 7df74cb..f4c470a 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
@@ -20,8 +21,6 @@
 #include <linux/workqueue.h>
 #include <linux/module.h>
 
-#include <asm/gpio.h>
-
 struct gpio_led_data {
 	struct led_classdev cdev;
 	unsigned gpio;
-- 
1.7.9.rc1

