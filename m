Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab0LBDzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 22:55:16 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:55628 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab0LBDzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 22:55:15 -0500
Date: Wed, 1 Dec 2010 19:55:10 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        cjb@laptop.org, dsd@laptop.org
Subject: [PATCH] mfd/gpio/misc: add MODULE_ALIAS entries for CS5535
 functions
Message-ID: <20101201195510.3a50d8b6@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds MODULE_ALIAS entries to the various cs5535 subdevice modules; this
allows the modules to automatically be loaded when cs5535-mfd loads.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/cs5535-gpio.c  |    1 +
 drivers/misc/cs5535-mfgpt.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index cc49687..90df6c5 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -388,3 +388,4 @@ module_exit(cs5535_gpio_exit);
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index 499bd64..2669306 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -349,3 +349,4 @@ module_init(cs5535_mfgpt_init);
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("CS5535/CS5536 MFGPT timer driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.7.2.3

