Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab2JOAs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 20:48:57 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:36482 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2JOAs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 20:48:56 -0400
From: Thiago Farina <tfransosi@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] power: remove duplicated include of abx500.h from ab8500_fb.c
Date: Sun, 14 Oct 2012 21:48:45 -0300
Message-Id: <1350262125-25883-1-git-send-email-tfarina@chromium.org>
X-Mailer: git-send-email 1.8.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfarina@chromium.org>
---
 drivers/power/ab8500_fg.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 2db8cc2..1041397 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -15,22 +15,21 @@
  *	Arun R Murthy <arun.murthy@stericsson.com>
  */
 
-#include <linux/init.h>
-#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/power_supply.h>
 #include <linux/kobject.h>
-#include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500.h>
-#include <linux/slab.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
-#include <linux/delay.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
-#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/slab.h>
 #include <linux/time.h>
-#include <linux/completion.h>
 
 #define MILLI_TO_MICRO			1000
 #define FG_LSB_IN_MA			1627
-- 
1.8.0.rc2

