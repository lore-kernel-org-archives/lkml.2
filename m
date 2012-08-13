Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab2HML7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:59:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34180 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2HML7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:59:43 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] mfd: Fix typo in mfd
Date: Mon, 13 Aug 2012 21:00:25 +0900
Message-Id: <1344859225-25616-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc2.9.ge5acacf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in drivers/mfd

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/mfd/ab8500-gpadc.c        | 2 +-
 drivers/mfd/rc5t583.c             | 2 +-
 drivers/mfd/rdc321x-southbridge.c | 2 +-
 drivers/mfd/tps65911-comparator.c | 2 +-
 include/linux/mfd/max8998.h       | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 866f959..29d72a2 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -342,7 +342,7 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 
 		 /*
 		  * Delay might be needed for ABB8500 cut 3.0, if not, remove
-		  * when hardware will be availible
+		  * when hardware will be available
 		  */
 			msleep(1);
 			break;
diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index cdc1df7..da15101 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -281,7 +281,7 @@ static int __devinit rc5t583_i2c_probe(struct i2c_client *i2c,
 
 	if (i2c->irq) {
 		ret = rc5t583_irq_init(rc5t583, i2c->irq, pdata->irq_base);
-		/* Still continue with waring if irq init fails */
+		/* Still continue with warning, if irq init fails */
 		if (ret)
 			dev_warn(&i2c->dev, "IRQ init failed: %d\n", ret);
 		else
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 685d61e..7b46d66 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -1,5 +1,5 @@
 /*
- * RDC321x MFD southbrige driver
+ * RDC321x MFD southbridge driver
  *
  * Copyright (C) 2007-2010 Florian Fainelli <florian@openwrt.org>
  * Copyright (C) 2010 Bernhard Loos <bernhardloos@googlemail.com>
diff --git a/drivers/mfd/tps65911-comparator.c b/drivers/mfd/tps65911-comparator.c
index 5a62e6b..0b6e361 100644
--- a/drivers/mfd/tps65911-comparator.c
+++ b/drivers/mfd/tps65911-comparator.c
@@ -136,7 +136,7 @@ static __devinit int tps65911_comparator_probe(struct platform_device *pdev)
 
 	ret = comp_threshold_set(tps65910, COMP2, pdata->vmbch2_threshold);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot set COMP2 theshold\n");
+		dev_err(&pdev->dev, "cannot set COMP2 threshold\n");
 		return ret;
 	}
 
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index f4f0dfa..6823548 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -67,7 +67,7 @@ struct max8998_regulator_data {
 /**
  * struct max8998_board - packages regulator init data
  * @regulators: array of defined regulators
- * @num_regulators: number of regultors used
+ * @num_regulators: number of regulators used
  * @irq_base: base IRQ number for max8998, required for IRQs
  * @ono: power onoff IRQ number for max8998
  * @buck_voltage_lock: Do NOT change the values of the following six
-- 
1.7.12.rc2.9.ge5acacf

