Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750766Ab2LUFUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:20:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57092 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2LUFUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:20:42 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-1c-50d3f1a956e9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 05/11] backlight: tdo24m: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:20:40 +0900
Message-id: <000901cddf3a$eb2e4df0$c18ae9d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAADvAQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zA92VHy8HGJw6KWFxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyNnbMZy44zF/xoHs6ewPjX54uRk4OCQETiW2dyxghbDGJC/fW
	s3UxcnEICSxjlLh+6iE7TNGD2f1QiUWMEs/eH4RyZjNJXG3+wgRSxSagJvHly2GwDhGBCInm
	GbOYuxg5OJgFfCQ2z9IECQsJ2Eq0f90Bto1TwE6ieW4TC0iJsECwxJ6twSBhFgFViR9Tn7GA
	2LxA5cve7maEsAUlfky+BxZnFtCSWL/zOBOELS+xec1bsE0SAuoSj/7qQhxgJPHv3gI2iBIR
	iX0v3jFCjBeQ+Db5EAtEuazEpgPMII9ICCxil1jy4BEzxLuSEgdX3GCZwCgxC8nmWUg2z0Ky
	eRaSFQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525ihMSV1A7GlQ0WhxgFOBiVeHgZzS4H
	CLEmlhVX5h5ilOBgVhLh9f8AFOJNSaysSi3Kjy8qzUktPsToA3T5RGYp0eR8YMznlcQbGhub
	mJmYmphbmpqb4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cA4PTHM/qOz+H1XXl/ztZfM
	796fLGfUs1dvU6u3ZVCkT67lpiKffy9Wdt8T5/V9+DdD7ezSlT/WCFxcL+ot/219+dzGtAkH
	Z/BEOHxbKcL2cUF8qdACi6xJDndkfngv+pvzf8+i7x4ps+8e+Le73+76Luu1xr9qVl+e+3Au
	u1jf22dvUo3mf+FTU2Ipzkg01GIuKk4EAAC3HjLYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd2VHy8HGPxZKGJxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMzZ2zGcuOMxf8aB7OnsD
	41+eLkZODgkBE4kHs/vZIGwxiQv31gPZXBxCAosYJZ69PwjlzGaSuNr8hQmkik1ATeLLl8Ps
	ILaIQIRE84xZzF2MHBzMAj4Sm2dpgoSFBGwl2r/uYASxOQXsJJrnNrGAlAgLBEvs2RoMEmYR
	UJX4MfUZC4jNC1S+7O1uRghbUOLH5HtgcWYBLYn1O48zQdjyEpvXvAXbJCGgLvHory7EAUYS
	/+4tYIMoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66X
	nJ+7iREctc+kdjCubLA4xCjAwajEw8todjlAiDWxrLgy9xCjBAezkgiv/wegEG9KYmVValF+
	fFFpTmrxIUYfoEcnMkuJJucDE0peSbyhsYmZkaWRmYWRibk5DmElcd5mj5QAIYH0xJLU7NTU
	gtQimHFMHJxSDYwc23ySlP0PLdUUuV8de/r1utDFjllSx1PidsssYGuZV2Do6iDifWubkLlo
	DccV1V6eau6rbHuiWs+vu7d1qu+iiwdMo+IXXPWsuPfPue508TydsO1NX64cv9ckJjQ9bP7E
	9a+Lqnouea5t3jVpyWIpC5ZT7yVKP4dGb3M5VP7zUecVCfst79qVWIozEg21mIuKEwEuxPdc
	BwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tdo24m.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index ad2325f..0016208 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -390,7 +390,7 @@ static int tdo24m_probe(struct spi_device *spi)
 	if (IS_ERR(lcd->lcd_dev))
 		return PTR_ERR(lcd->lcd_dev);
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 	err = tdo24m_power(lcd, FB_BLANK_UNBLANK);
 	if (err)
 		goto out_unregister;
@@ -404,7 +404,7 @@ out_unregister:
 
 static int tdo24m_remove(struct spi_device *spi)
 {
-	struct tdo24m *lcd = dev_get_drvdata(&spi->dev);
+	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
@@ -415,14 +415,14 @@ static int tdo24m_remove(struct spi_device *spi)
 #ifdef CONFIG_PM
 static int tdo24m_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct tdo24m *lcd = dev_get_drvdata(&spi->dev);
+	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	return tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int tdo24m_resume(struct spi_device *spi)
 {
-	struct tdo24m *lcd = dev_get_drvdata(&spi->dev);
+	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	return tdo24m_power(lcd, FB_BLANK_UNBLANK);
 }
@@ -434,7 +434,7 @@ static int tdo24m_resume(struct spi_device *spi)
 /* Power down all displays on reboot, poweroff or halt */
 static void tdo24m_shutdown(struct spi_device *spi)
 {
-	struct tdo24m *lcd = dev_get_drvdata(&spi->dev);
+	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 }
-- 
1.7.2.5


