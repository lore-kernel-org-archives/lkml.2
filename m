Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1EFJ3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:29:48 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:50620 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab1EFJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:29:12 -0400
X-ASG-Debug-ID: 1304674151-082ecebf0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it,
        khali@linux-fr.org, ben-linux@fluff.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 5/6] mfd: 88pm860x: remove unused parameter
Subject: [PATCH 5/6] mfd: 88pm860x: remove unused parameter
Date: Fri,  6 May 2011 17:21:24 +0800
X-ASG-Orig-Subj: [PATCH 5/6] mfd: 88pm860x: remove unused parameter
Message-Id: <1304673685-21324-5-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1304674151
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_client parameter isn't used in some functions. Just remove it.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/88pm860x-core.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 8e88fba..17dfe9b 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -504,7 +504,6 @@ static void device_irq_exit(struct pm860x_chip *chip)
 }
 
 static void __devinit device_bk_init(struct pm860x_chip *chip,
-				     struct i2c_client *i2c,
 				     struct pm860x_platform_data *pdata)
 {
 	int ret;
@@ -540,7 +539,6 @@ static void __devinit device_bk_init(struct pm860x_chip *chip,
 }
 
 static void __devinit device_led_init(struct pm860x_chip *chip,
-				      struct i2c_client *i2c,
 				      struct pm860x_platform_data *pdata)
 {
 	int ret;
@@ -576,7 +574,6 @@ static void __devinit device_led_init(struct pm860x_chip *chip,
 }
 
 static void __devinit device_regulator_init(struct pm860x_chip *chip,
-					    struct i2c_client *i2c,
 					    struct pm860x_platform_data *pdata)
 {
 	struct regulator_init_data *initdata;
@@ -614,7 +611,6 @@ out:
 }
 
 static void __devinit device_rtc_init(struct pm860x_chip *chip,
-				      struct i2c_client *i2c,
 				      struct pm860x_platform_data *pdata)
 {
 	int ret;
@@ -634,7 +630,6 @@ static void __devinit device_rtc_init(struct pm860x_chip *chip,
 }
 
 static void __devinit device_touch_init(struct pm860x_chip *chip,
-					struct i2c_client *i2c,
 					struct pm860x_platform_data *pdata)
 {
 	int ret;
@@ -654,7 +649,6 @@ static void __devinit device_touch_init(struct pm860x_chip *chip,
 }
 
 static void __devinit device_power_init(struct pm860x_chip *chip,
-					struct i2c_client *i2c,
 					struct pm860x_platform_data *pdata)
 {
 	int ret;
@@ -682,7 +676,6 @@ static void __devinit device_power_init(struct pm860x_chip *chip,
 }
 
 static void __devinit device_onkey_init(struct pm860x_chip *chip,
-					struct i2c_client *i2c,
 					struct pm860x_platform_data *pdata)
 {
 	int ret;
@@ -697,7 +690,6 @@ static void __devinit device_onkey_init(struct pm860x_chip *chip,
 }
 
 static void __devinit device_codec_init(struct pm860x_chip *chip,
-					struct i2c_client *i2c,
 					struct pm860x_platform_data *pdata)
 {
 	int ret;
@@ -765,12 +757,12 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 	if (ret < 0)
 		goto out;
 
-	device_regulator_init(chip, i2c, pdata);
-	device_rtc_init(chip, i2c, pdata);
-	device_onkey_init(chip, i2c, pdata);
-	device_touch_init(chip, i2c, pdata);
-	device_power_init(chip, i2c, pdata);
-	device_codec_init(chip, i2c, pdata);
+	device_regulator_init(chip, pdata);
+	device_rtc_init(chip, pdata);
+	device_onkey_init(chip, pdata);
+	device_touch_init(chip, pdata);
+	device_power_init(chip, pdata);
+	device_codec_init(chip, pdata);
 out:
 	return;
 }
@@ -782,8 +774,8 @@ int __devinit pm860x_device_init(struct pm860x_chip *chip,
 
 	switch (chip->id) {
 	case CHIP_PM8606:
-		device_bk_init(chip, chip->client, pdata);
-		device_led_init(chip, chip->client, pdata);
+		device_bk_init(chip, pdata);
+		device_led_init(chip, pdata);
 		break;
 	case CHIP_PM8607:
 		device_8607_init(chip, chip->client, pdata);
@@ -793,8 +785,8 @@ int __devinit pm860x_device_init(struct pm860x_chip *chip,
 	if (chip->companion) {
 		switch (chip->id) {
 		case CHIP_PM8607:
-			device_bk_init(chip, chip->companion, pdata);
-			device_led_init(chip, chip->companion, pdata);
+			device_bk_init(chip, pdata);
+			device_led_init(chip, pdata);
 			break;
 		case CHIP_PM8606:
 			device_8607_init(chip, chip->companion, pdata);
-- 
1.5.6.5

