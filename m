Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2JPH1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:27:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15733 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPH1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:27:16 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-5c-507d0c539ab2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 03/17] backlight: corgi_lcd: fix checkpatch error and warning
Date: Tue, 16 Oct 2012 16:27:15 +0900
Message-id: <007401cdab6f$aaa93d70$fffbb850$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAACFRg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd1gntoAg3sfTCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG09b3rAXdghWPDz9ib2C8w9vFyMEhIWAi8eaUVhcjJ5ApJnHh
	3nq2LkYuDiGB6YwSu26dZYZwZjNJLHq8mBmkik1ATeLLl8PsILaIQIRE84xZzCCDmAV8JDbP
	0gQJCwnYSqye8RashFPATmLj64MsICXCAr4S/btiQcIsAqoSNx89YwUJ8wKVdy5PAgnzCghK
	/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIi9UlHv3VhdhvJHH7yTU2iBIRiX0v3jFOYBSahWTS
	LCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwQH8THoH46oGi0OMAhyM
	Sjy8Gc41AUKsiWXFlbmHGCU4mJVEeD0mAoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzNnukBAgJ
	pCeWpGanphakFsFkmTg4pRoY1xmtrpRTWR91TeaLD+/SoznSHEs2f3S9OzV66qW7/Sd2yVo7
	NX1insX7TC7z4M6AoGvqT29d85zZoKDxomnJ/vsnF00qf6EocvKu0p2G8zqJ7OUstSJiqRWz
	/n1O+Fp4LuzM9+ILKvdsT9ooMhbGmEQ+fOzQ0yostm4Z1y45z+T6/Q7dzM4GSizFGYmGWsxF
	xYkAM+FwkVwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch error and warning as below:

WARNING: please, no space before tabs
WARNING: quoted string split across lines
ERROR: space required before the open parenthesis '('

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/corgi_lcd.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index c781768..7171815 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -6,8 +6,8 @@
  *  Based on Sharp's 2.4 Backlight Driver
  *
  *  Copyright (c) 2008 Marvell International Ltd.
- *  	Converted to SPI device based LCD/Backlight device driver
- *  	by Eric Miao <eric.miao@marvell.com>
+ *	Converted to SPI device based LCD/Backlight device driver
+ *	by Eric Miao <eric.miao@marvell.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
@@ -192,7 +192,7 @@ static void lcdtg_set_phadadj(struct corgi_lcd *lcd, int mode)
 {
 	int adj;
 
-	switch(mode) {
+	switch (mode) {
 	case CORGI_LCD_MODE_VGA:
 		/* Setting for VGA */
 		adj = sharpsl_param.phadadj;
@@ -495,8 +495,9 @@ static int setup_gpio_backlight(struct corgi_lcd *lcd,
 		err = devm_gpio_request(&spi->dev, pdata->gpio_backlight_on,
 					"BL_ON");
 		if (err) {
-			dev_err(&spi->dev, "failed to request GPIO%d for "
-				"backlight_on\n", pdata->gpio_backlight_on);
+			dev_err(&spi->dev,
+				"failed to request GPIO%d for backlight_on\n",
+				pdata->gpio_backlight_on);
 			return err;
 		}
 
@@ -508,8 +509,9 @@ static int setup_gpio_backlight(struct corgi_lcd *lcd,
 		err = devm_gpio_request(&spi->dev, pdata->gpio_backlight_cont,
 					"BL_CONT");
 		if (err) {
-			dev_err(&spi->dev, "failed to request GPIO%d for "
-				"backlight_cont\n", pdata->gpio_backlight_cont);
+			dev_err(&spi->dev,
+				"failed to request GPIO%d for backlight_cont\n",
+				pdata->gpio_backlight_cont);
 			return err;
 		}
 
-- 
1.7.1


