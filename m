Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2BDQeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:34:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38040 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab2BDQd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:33:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] w1: Use linux/gpio.h rather than asm/gpio.h
Date: Sat,  4 Feb 2012 16:33:55 +0000
Message-Id: <1328373235-5413-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct inclusion of the asm header has long been deprecated by the
introduction of gpiolib.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/w1/masters/w1-gpio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index fcbe742..df600d1 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -13,12 +13,11 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/w1-gpio.h>
+#include <linux/gpio.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
 
-#include <asm/gpio.h>
-
 static void w1_gpio_write_bit_dir(void *data, u8 bit)
 {
 	struct w1_gpio_platform_data *pdata = data;
-- 
1.7.9.rc1

