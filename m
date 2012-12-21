Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab2LUFXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:23:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57472 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2LUFXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:23:16 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-8d-50d3f24367bc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 10/11] backlight: corgi_lcd: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:23:14 +0900
Message-id: <000e01cddf3b$46f0c0a0$d4d241e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAAJ+JA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI13nT5cDDG6uEbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZvw5eYis4wVdx6vxTxgbGdTxdjJwcEgImEh/nXWWEsMUkLtxb
	z9bFyMUhJLCMUeL4mscsXYwcYEXt14Ug4osYJc6+fsMI4cxmkri4ZCILSDebgJrEly+H2UFs
	EYEIieYZs5hBmpkFfCQ2z9IECQsJ2Eq0f90BtoxTwE6ieW4TWKuwQJjEwn+X2UBsFgFViYuH
	roGN4QWqPzP9IxuELSjxY/I9sHpmAS2J9TuPM0HY8hKb17xlhrhTXeLRX12IC4wkfn6YDFUu
	IrHvxTtGiPECEt8mH4J6S1Zi0wFmkE8kBBaxS6w4/I4JEg6SEgdX3GCZwCgxC8nmWUg2z0Ky
	eRaSFQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525ihMSV1A7GlQ0WhxgFOBiVeHgZzS4H
	CLEmlhVX5h5ilOBgVhLh9f8AFOJNSaysSi3Kjy8qzUktPsToA3T5RGYp0eR8YMznlcQbGhub
	mJmYmphbmpqb4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cDIuKbb/a+nRtc957LwVU+y
	Y2cuV+3fLJZbqf144ocPjbv0uD/sWREW9tRqG6f96ZlNH206BBamul8qeS3Dn69sW7NZ+/6b
	Kf8LAkO+pGTdnG0wcwbfwaQ7+13e6E5/O6m257N5W+7peLaH7wx8zT9sXFfF1XpbwnfZondT
	Mrz3W836fDSMreyuEktxRqKhFnNRcSIA/hyrxtgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAV3nT5cDDPadFbC4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGb8OXmIrOMFXcer8U8YG
	xnU8XYwcHBICJhLt14W6GDmBTDGJC/fWs3UxcnEICSxilDj7+g0jhDObSeLikoksIFVsAmoS
	X74cZgexRQQiJJpnzGIGGcQs4COxeZYmSFhIwFai/esORhCbU8BOonluE1irsECYxMJ/l9lA
	bBYBVYmLh66BjeEFqj8z/SMbhC0o8WPyPbB6ZgEtifU7jzNB2PISm9e8ZYa4WV3i0V9diAuM
	JH5+mAxVLiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10v
	OT93EyM4ap9J7WBc2WBxiFGAg1GJh5fR7HKAEGtiWXFl7iFGCQ5mJRFe/w9AId6UxMqq1KL8
	+KLSnNTiQ4w+QI9OZJYSTc4HJpS8knhDYxMzI0sjMwsjE3NzHMJK4rzNHikBQgLpiSWp2amp
	BalFMOOYODilGhiZp575eZntz84tLwN6Kx1TvGv9FSba5v8p+xjtrHOJOWP3Qt+FuU5fXTZ0
	fW60cnvYHmd6n53jhV/It6zGE+8u9vevEsrrrv/78LPpx+5d6cd22DZZXPmp4ZW9jrfWZULS
	c8mwmwIbekq58pR/KjsWz3/h53J2hXBlZ3Hu7fz7Ey/KVPz5/liJpTgj0VCLuag4EQDcNgpJ
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
 drivers/video/backlight/corgi_lcd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index e323fcb..77c81f8 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -460,7 +460,7 @@ static const struct backlight_ops corgi_bl_ops = {
 #ifdef CONFIG_PM
 static int corgi_lcd_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&spi->dev);
+	struct corgi_lcd *lcd = spi_get_drvdata(spi);
 
 	corgibl_flags |= CORGIBL_SUSPENDED;
 	corgi_bl_set_intensity(lcd, 0);
@@ -470,7 +470,7 @@ static int corgi_lcd_suspend(struct spi_device *spi, pm_message_t state)
 
 static int corgi_lcd_resume(struct spi_device *spi)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&spi->dev);
+	struct corgi_lcd *lcd = spi_get_drvdata(spi);
 
 	corgibl_flags &= ~CORGIBL_SUSPENDED;
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_UNBLANK);
@@ -577,7 +577,7 @@ static int corgi_lcd_probe(struct spi_device *spi)
 
 	lcd->kick_battery = pdata->kick_battery;
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_UNBLANK);
 	backlight_update_status(lcd->bl_dev);
 
@@ -594,7 +594,7 @@ err_unregister_lcd:
 
 static int corgi_lcd_remove(struct spi_device *spi)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&spi->dev);
+	struct corgi_lcd *lcd = spi_get_drvdata(spi);
 
 	lcd->bl_dev->props.power = FB_BLANK_UNBLANK;
 	lcd->bl_dev->props.brightness = 0;
-- 
1.7.2.5


