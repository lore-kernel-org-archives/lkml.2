Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126Ab2LUFTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:19:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49742 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2LUFTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:19:32 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-51-50d3f1631a4d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 03/11] backlight: s6e63m0: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:19:30 +0900
Message-id: <000701cddf3a$c162b060$44281120$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAABdBA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zA93kj5cDDNZtEbC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZX9rXsBcsF6jo/p7SwHiFt4uRg0NCwERi84bYLkZOIFNM4sK9
	9WwgtpDAMkaJ9795IeImEhNer2XsYuQCii9ilJh25RSUM5tJ4sj+TcwgVWwCahJfvhxmB7FF
	BCIkmmfMYgZZwCzgI7F5libEUFuJ9q87GEFsTgE7iea5TSwgtrBAiMTKKfuZQGwWAVWJ1V/n
	gdm8QPX/r0yFsgUlfky+B1bPLKAlsX7ncSYIW15i85q3zBC/qEs8+qsLcYGRROOx64wQJSIS
	+168Y4QYLyDxbfIhFohyWYlNB5hBPpEQmMcu0XfqCDPEv5ISB1fcYJnAKDELyeZZSDbPQrJ5
	FpIVCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmKExJTUDsaVDRaHGAU4GJV4eBnNLgcI
	sSaWFVfmHmKU4GBWEuH1/wAU4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5HxgvOeVxBsaG5uY
	mZiamFuampviEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwJjRMl9/Ryyf7rW+50fOnjjl
	skNENyz2vJhuEafR363c/16apzXVH+GQ5ruh8eHx9MT160OjQ2Vmpk8skqpXn1/z+e4xhiuy
	pxdqV69b7f/Q/Kuy3MbJrU8PL7rT9JVDcOLb+r7ytvu25tHGFxY43l7OZVfwxXDl00T+JbGx
	m3dtt2o5ppjU9kuJpTgj0VCLuag4EQBJW+Ly1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd3kj5cDDObf5ba4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGV/a17AXLBeo6P6e0sB4
	hbeLkZNDQsBEYsLrtYwQtpjEhXvr2boYuTiEBBYxSky7cooRwpnNJHFk/yZmkCo2ATWJL18O
	s4PYIgIREs0zZgHFOTiYBXwkNs/SBAkLCdhKtH/dATaUU8BOonluEwuILSwQIrFyyn4mEJtF
	QFVi9dd5YDYvUP3/K1OhbEGJH5PvgdUzC2hJrN95nAnClpfYvOYt2CoJAXWJR391IS4wkmg8
	dp0RokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcNQ+k9rBuLLB4hCjAAejEg8vo9nlACHWxLLiytxDjBIczEoivP4fgEK8KYmVValF+fFF
	pTmpxYcYfYAencgsJZqcD0woeSXxhsYmZkaWRmYWRibm5jiElcR5mz1SAoQE0hNLUrNTUwtS
	i2DGMXFwSjUwnj3e0Sioyx0/Wzfnt+T3bfGL1+9foPjHXSaI75rqkl/TD/afnH28a0/444ay
	5YV2ByTC2B6tTtTdkaFx8ZjxzTOc+QuZEjrjOptStssHRNxdk/dzW/rFEOcvR8wd1WYclTfJ
	/liqUn0wSEVQWGFN0g7v0vrbu9ZPiJo/V8r+Y2llWFxuuAOPEktxRqKhFnNRcSIA6JHjlgcD	AAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/s6e63m0.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 0969a4048..2126b96 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -793,7 +793,7 @@ static int s6e63m0_probe(struct spi_device *spi)
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "s6e63m0 panel driver has been probed.\n");
 
@@ -806,7 +806,7 @@ out_lcd_unregister:
 
 static int s6e63m0_remove(struct spi_device *spi)
 {
-	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+	struct s6e63m0 *lcd = spi_get_drvdata(spi);
 
 	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 	device_remove_file(&spi->dev, &dev_attr_gamma_table);
@@ -820,7 +820,7 @@ static int s6e63m0_remove(struct spi_device *spi)
 #if defined(CONFIG_PM)
 static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+	struct s6e63m0 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -833,7 +833,7 @@ static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
 
 static int s6e63m0_resume(struct spi_device *spi)
 {
-	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+	struct s6e63m0 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -847,7 +847,7 @@ static int s6e63m0_resume(struct spi_device *spi)
 /* Power down all displays on reboot, poweroff or halt. */
 static void s6e63m0_shutdown(struct spi_device *spi)
 {
-	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+	struct s6e63m0 *lcd = spi_get_drvdata(spi);
 
 	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 }
-- 
1.7.2.5


