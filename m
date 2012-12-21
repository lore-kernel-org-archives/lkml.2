Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab2LUFVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:21:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40577 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2LUFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:21:35 -0500
X-AuditID: cbfee61b-b7f616d00000319b-50-50d3f1ddfbfc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 07/11] backlight: ams369fg06: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:21:33 +0900
Message-id: <000b01cddf3b$0a713bf0$1f53b3d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAAGHcg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zA927Hy8HGJw5aGxxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyvp05z16wRKCiZ/0btgbGO7xdjJwcEgImEvO//2aEsMUkLtxb
	z9bFyMUhJLCMUeL0pzVACQ6woslvnSHi0xklZj3awwjhzGaS6G/7wgTSzSagJvHly2F2EFtE
	IEKiecYsZpBmZgEfic2zNEHCQgK2Eu1fd4At4xSwk2ie28QCYgsLhEvsOdIONoZFQFXi39L7
	zCA2L1B915ulLBC2oMSPyffAbGYBLYn1O48zQdjyEpvXvGWGuFNd4tFfXYgLjCTaD7YzQpSI
	SOx78Y4RYryAxLfJh1ggymUlNh1gBvlEQmARu8SJWR+YIOEgKXFwxQ2WCUCfItk8C8nmWUg2
	z0KyYgEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MkLiS3sG4qsHiEKMAB6MSD2+kxeUA
	IdbEsuLK3EOMEhzMSiK8z5cAhXhTEiurUovy44tKc1KLDzH6AF0+kVlKNDkfGPN5JfGGxsYm
	ZiamJuaWpuamOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTBG8q69lWt7fEcqH8uuG+ef
	bMgxXXhM/+7ZNRc3O30/dfDh7fe8V7PNfH13VD6p/B+55LXSvvNtp2YE1bn3Vi51N2m4KGBd
	PN2jfttNvzXH1x/ZsfSpCMfu7rk3ur3mrve7er/BIHZbi2OhsfyR3TFbN1dOYA0o/ZCluo/h
	rW1IwtYNSVtDtx36ocRSnJFoqMVcVJwIAPmddqjYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd27Hy8HGNzo0re4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGd/OnGcvWCJQ0bP+DVsD
	4x3eLkYODgkBE4nJb527GDmBTDGJC/fWs3UxcnEICUxnlJj1aA8jhDObSaK/7QsTSBWbgJrE
	ly+H2UFsEYEIieYZs5hBBjEL+EhsnqUJEhYSsJVo/7qDEcTmFLCTaJ7bxAJiCwuES+w50g42
	hkVAVeLf0vvMIDYvUH3Xm6UsELagxI/J98BsZgEtifU7jzNB2PISm9e8ZYa4WV3i0V9diAuM
	JNoPtjNClIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvX
	S87P3cQIjtpn0jsYVzVYHGIU4GBU4uGNtLgcIMSaWFZcmXuIUYKDWUmE9/kSoBBvSmJlVWpR
	fnxRaU5q8SFGH6BHJzJLiSbnAxNKXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+UACGB9MSS1OzU
	1ILUIphxTBycUg2MJo3aDxPXzhR6xTfvo4ditPslxw/eZ9eyLTZo29GrdFWofZP9wlzLuw5Z
	7Gv0DJ9ty/I2cFloFLtX3aXRPe7i58U5mgKr3kWUHFuVFzQlW0n/a+RrGw+VPaWNhRMYFx2r
	Pit9uP9rBWOotebt54sX7j51N2Vjaekx4dSI+1dFXWuT9e+wiOYrsRRnJBpqMRcVJwIALzSa
	OgcDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 72d71e0..bd8a320 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -513,7 +513,7 @@ static int ams369fg06_probe(struct spi_device *spi)
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "ams369fg06 panel driver has been probed.\n");
 
@@ -526,7 +526,7 @@ out_lcd_unregister:
 
 static int ams369fg06_remove(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
@@ -538,7 +538,7 @@ static int ams369fg06_remove(struct spi_device *spi)
 #if defined(CONFIG_PM)
 static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -551,7 +551,7 @@ static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 
 static int ams369fg06_resume(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -564,7 +564,7 @@ static int ams369fg06_resume(struct spi_device *spi)
 
 static void ams369fg06_shutdown(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 }
-- 
1.7.2.5


