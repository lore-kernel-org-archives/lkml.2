Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2JPHbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:31:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25627 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2JPHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:31:30 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-84-507d0d518021
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 11/17] backlight: locomolcd: fix checkpatch error and warning
Date: Tue, 16 Oct 2012 16:31:28 +0900
Message-id: <007c01cdab70$419d09f0$c4d71dd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAMMpg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd1A3toAg9kv2Swu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG+/0v2Ap+a1Q8/O3VwLhDqYuRk0NCwERizceFrBC2mMSFe+vZ
	uhi5OIQEpjNKbHveDeXMZpJYNnk/M0gVm4CaxJcvh9lBbBGBCInmGbOA4hwczAI+EptnaYKE
	hQRsJVbPeAtWwilgJ7Hx9UEWEFtYwFfi4L+VYHEWAVWJ0/8+gsV5geqn3b3ADmELSvyYfA8s
	ziygJbF+53EmCFteYvOat2CrJATUJR791YW4wEjid+t2qHIRiX0v3jFOYBSahWTSLCSTZiGZ
	NAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwUH8TGoH48oGi0OMAhyMSjy8Gc41
	AUKsiWXFlbmHGCU4mJVEeD0mAoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzNnukBAgJpCeWpGan
	phakFsFkmTg4pRoYe5Nk7hn/Udp4buPuKf0Hj9/tmLJUjq27VDCgiD3VzJDnbHrSPH3P22v3
	rr3MF292X0sseVb01OOiO/Tn8jDtvXyaXc1r36oLxww5LBj3zo2SCXkY75S+LrB4TvKxxd+j
	ZXa+F0tpsr7HWLq/T70+/liom8WkA+tu6vWbhz7+HvA9n/nGL+H1SizFGYmGWsxFxYkAVL6g
	VF4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch error and warning as below:

WARNING: line over 80 characters
WARNING: space prohibited between function name and open parenthesis '('
ERROR: trailing statements should be on next line

Also, long comments are fixed for the preferred style and
unnecessary lines are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/locomolcd.c |   65 +++++++++++++++++++++++------------
 1 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 3a6d541..4cfa87b 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -33,19 +33,25 @@ static unsigned long locomolcd_flags;
 
 static void locomolcd_on(int comadj)
 {
-	locomo_gpio_set_dir(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHA_ON, 0);
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHA_ON, 1);
+	locomo_gpio_set_dir(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHA_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHA_ON, 1);
 	mdelay(2);
 
-	locomo_gpio_set_dir(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHD_ON, 0);
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHD_ON, 1);
+	locomo_gpio_set_dir(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHD_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHD_ON, 1);
 	mdelay(2);
 
 	locomo_m62332_senddata(locomolcd_dev, comadj, 0);
 	mdelay(5);
 
-	locomo_gpio_set_dir(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VEE_ON, 0);
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VEE_ON, 1);
+	locomo_gpio_set_dir(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VEE_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VEE_ON, 1);
 	mdelay(10);
 
 	/* TFTCRST | CPSOUT=0 | CPSEN */
@@ -68,16 +74,19 @@ static void locomolcd_off(int comadj)
 	locomo_writel(0x06, locomolcd_dev->mapbase + LOCOMO_TC);
 	mdelay(1);
 
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHA_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHA_ON, 0);
 	mdelay(110);
 
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VEE_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VEE_ON, 0);
 	mdelay(700);
 
 	/* TFTCRST=0 | CPSOUT=0 | CPSEN = 0 */
 	locomo_writel(0, locomolcd_dev->mapbase + LOCOMO_TC);
 	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_MOD, 0);
-	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHD_ON, 0);
+	locomo_gpio_write(locomolcd_dev->dev.parent,
+			LOCOMO_GPIO_LCD_VSHD_ON, 0);
 }
 
 void locomolcd_power(int on)
@@ -107,7 +116,6 @@ void locomolcd_power(int on)
 }
 EXPORT_SYMBOL(locomolcd_power);
 
-
 static int current_intensity;
 
 static int locomolcd_set_intensity(struct backlight_device *bd)
@@ -122,13 +130,25 @@ static int locomolcd_set_intensity(struct backlight_device *bd)
 		intensity = 0;
 
 	switch (intensity) {
-	/* AC and non-AC are handled differently, but produce same results in sharp code? */
-	case 0: locomo_frontlight_set(locomolcd_dev, 0, 0, 161); break;
-	case 1: locomo_frontlight_set(locomolcd_dev, 117, 0, 161); break;
-	case 2: locomo_frontlight_set(locomolcd_dev, 163, 0, 148); break;
-	case 3: locomo_frontlight_set(locomolcd_dev, 194, 0, 161); break;
-	case 4: locomo_frontlight_set(locomolcd_dev, 194, 1, 161); break;
-
+	/*
+	 * AC and non-AC are handled differently,
+	 * but produce same results in sharp code?
+	 */
+	case 0:
+		locomo_frontlight_set(locomolcd_dev, 0, 0, 161);
+		break;
+	case 1:
+		locomo_frontlight_set(locomolcd_dev, 117, 0, 161);
+		break;
+	case 2:
+		locomo_frontlight_set(locomolcd_dev, 163, 0, 148);
+		break;
+	case 3:
+		locomo_frontlight_set(locomolcd_dev, 194, 0, 161);
+		break;
+	case 4:
+		locomo_frontlight_set(locomolcd_dev, 194, 1, 161);
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -175,9 +195,11 @@ static int locomolcd_probe(struct locomo_dev *ldev)
 
 	locomo_gpio_set_dir(ldev->dev.parent, LOCOMO_GPIO_FL_VR, 0);
 
-	/* the poodle_lcd_power function is called for the first time
+	/*
+	 * the poodle_lcd_power function is called for the first time
 	 * from fs_initcall, which is before locomo is activated.
-	 * We need to recall poodle_lcd_power here*/
+	 * We need to recall poodle_lcd_power here
+	 */
 	if (machine_is_poodle())
 		locomolcd_power(1);
 
@@ -190,8 +212,8 @@ static int locomolcd_probe(struct locomo_dev *ldev)
 							&ldev->dev, NULL,
 							&locomobl_data, &props);
 
-	if (IS_ERR (locomolcd_bl_device))
-		return PTR_ERR (locomolcd_bl_device);
+	if (IS_ERR(locomolcd_bl_device))
+		return PTR_ERR(locomolcd_bl_device);
 
 	/* Set up frontlight so that screen is readable */
 	locomolcd_bl_device->props.brightness = 2;
@@ -226,7 +248,6 @@ static struct locomo_driver poodle_lcd_driver = {
 	.resume = locomolcd_resume,
 };
 
-
 static int __init locomolcd_init(void)
 {
 	return locomo_driver_register(&poodle_lcd_driver);
-- 
1.7.1


