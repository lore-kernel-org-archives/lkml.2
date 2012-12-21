Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750828Ab2LUFTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:19:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54787 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2LUFTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:19:04 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a2-50d3f1465912
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 02/11] backlight: ld9040: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:19:01 +0900
Message-id: <000601cddf3a$b00c8480$10258d80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAAAYEQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zY123j5cDDG795bK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZp7r1CjoEKg7t7mZtYNzC28XIySEhYCLR+mAJM4QtJnHh3no2
	EFtIYBmjxJVlqjA1nXsvMkPEFzFKHHkS0sXIBWTPZpLoXnALLMEmoCbx5cthdhBbRCBConnG
	LKA4BwezgI/E5lmaEL22Eu1fdzCC2JwCdhLNc5tYQEqEBYIlpkxRBgmzCKhKtG16AHYCL1D5
	jI1vmCFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3kLtklCQF3i0V9diAOMJLpWnoQqEZHY9+Id
	I8R4AYlvkw+xQJTLSmw6wAzyiITAdHaJFdsbmCC+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxY
	wMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyMkoqR3MK5qsDjEKMDBqMTDG2lxOUCINbGs
	uDL3EKMEB7OSCO/zJUAh3pTEyqrUovz4otKc1OJDjD5Al09klhJNzgdGe15JvKGxsYmZiamJ
	uaWpuSkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjLP3Ry3s3WwmU6KaxLacgS1MSb/S
	LjPzb5DH56UvX3zoeBulYLjl0poNNy5J/b8soJDbk3D4/FOnmayhm2UlfkXz5JzrlOstOa52
	53bXjCXRC1sT1q7/EtFUcFVg8tv6J+uK+o9x6P8yuBJVvOdBf0/jy7i5dda2vrurz667c7az
	+tfLb4e2+CixFGckGmoxFxUnAgDXfX8j1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jAV23j5cDDCa+Y7O4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGae69Qo6BCoO7e5mbWDc
	wtvFyMkhIWAi0bn3IjOELSZx4d56NhBbSGARo8SRJyFdjFxA9mwmie4Ft8CK2ATUJL58OcwO
	YosIREg0z5gFFOfgYBbwkdg8SxOi11ai/esORhCbU8BOonluEwtIibBAsMSUKcogYRYBVYm2
	TQ/AVvEClc/Y+IYZwhaU+DH5HguIzSygJbF+53EmCFteYvOat2CbJATUJR791YU4wEiia+VJ
	qBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsY
	wRH7THoH46oGi0OMAhyMSjy8kRaXA4RYE8uKK3MPMUpwMCuJ8D5fAhTiTUmsrEotyo8vKs1J
	LT7E6AP06ERmKdHkfGAyySuJNzQ2MTOyNDKzMDIxN8chrCTO2+yREiAkkJ5YkpqdmlqQWgQz
	jomDU6qBcV1Zse33zLWVf5h7k146cX1+KhZ2Sdi6PaRXen7k9cAr96Znsj+d4e1pqHb6xeMf
	meWeQR9mM1pa5yZ+U/UrOle37X+H2MfN+xZn3goqWN54+nf5X2n+dfcze8sMNwuEvDKSn7n9
	1fvJyrd+LxDZMbGCt1tI3Ov30qU882Ks+GcsqOi77btojRJLcUaioRZzUXEiAP7ut3UFAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 12b5c01..24f2c9a 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -755,7 +755,7 @@ static int ld9040_probe(struct spi_device *spi)
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "ld9040 panel driver has been probed.\n");
 	return 0;
@@ -770,7 +770,7 @@ out_free_regulator:
 
 static int ld9040_remove(struct spi_device *spi)
 {
-	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
@@ -783,7 +783,7 @@ static int ld9040_remove(struct spi_device *spi)
 #if defined(CONFIG_PM)
 static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -796,7 +796,7 @@ static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
 
 static int ld9040_resume(struct spi_device *spi)
 {
-	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -810,7 +810,7 @@ static int ld9040_resume(struct spi_device *spi)
 /* Power down all displays on reboot, poweroff or halt. */
 static void ld9040_shutdown(struct spi_device *spi)
 {
-	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
 }
-- 
1.7.2.5


