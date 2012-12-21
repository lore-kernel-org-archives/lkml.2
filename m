Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab2LUFWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:22:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57329 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2LUFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:22:15 -0500
X-AuditID: cbfee61b-b7f616d00000319b-0c-50d3f2035786
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 08/11] backlight: vgg2432a4: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:22:11 +0900
Message-id: <000c01cddf3b$21163360$63429a20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAAHAGQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zY13mT5cDDO59MbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZZz+fZy74zl2x9fxilgbG2VxdjJwcEgImEk2/P7JD2GISF+6t
	Z+ti5OIQEljGKPGp6z0jTNHHvd9ZIRKLGCU+r/nPBOHMZpJo+3QPrJ1NQE3iy5fDYLaIQIRE
	84xZzF2MHBzMAj4Sm2dpgoSFBGwl2r/uABvKKWAn0Ty3iQXEFhYIkzhw+jxYK4uAqsTNTWfB
	aniB6j/f+AVlC0r8mHwPrJ5ZQEti/c7jTBC2vMTmNW/BVkkIqEs8+qsLcYGRxLcTaxghSkQk
	9r14xwgxXkDi2+RDLBDlshKbDjCDfCIhsIhd4t6HY1D/SkocXHGDZQKjxCwkm2ch2TwLyeZZ
	SFYsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRESWdI7GFc1WBxiFOBgVOLhjbS4HCDE
	mlhWXJl7iFGCg1lJhPf5EqAQb0piZVVqUX58UWlOavEhRh+gyycyS4km5wOjPq8k3tDY2MTM
	xNTE3NLU3BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGxqRl7dcYi0Xf9Zp3mkkvq/I6
	MYUja5K5mJ2w3eVf04qYAhTkDBY+dW+duXzmy4C+NwY7v7aWMxQKmLN5xfz9GZXy1Yevfgtv
	+BSF6bdi5+tYl+bd2fSyZoXJ5426Xid15tybO+tAEd+GmhzbNw1ZHWsXXX9dd/RdxtSJ9ldj
	V90S5/crfBBcqsRSnJFoqMVcVJwIAC7ZuPTZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAV3mT5cDDNqm6Vtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjLOfzzMXfOeu2Hp+MUsD
	42yuLkZODgkBE4mPe7+zQthiEhfurWfrYuTiEBJYxCjxec1/JghnNpNE26d77CBVbAJqEl++
	HAazRQQiJJpnzGLuYuTgYBbwkdg8SxMkLCRgK9H+dQcjiM0pYCfRPLeJBcQWFgiTOHD6PFgr
	i4CqxM1NZ8FqeIHqP9/4BWULSvyYfA+snllAS2L9zuNMELa8xOY1b8FWSQioSzz6qwtxgZHE
	txNrGCFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgTH7TPpHYyrGiwOMQpwMCrx8EZaXA4QYk0sK67MPcQowcGsJML7fAlQiDclsbIqtSg/
	vqg0J7X4EKMP0KMTmaVEk/OBKSWvJN7Q2MTMyNLIzMLIxNwch7CSOG+zR0qAkEB6Yklqdmpq
	QWoRzDgmDk6pBkbHlq05+WfFqvIbHhteexgccLPnIOMUgWNz6jk+85/btPOpl8utxQcieE+0
	3sx4vvR53Nnp3XNabvx6Jns7n1dsV3WRdKtcZXdoe0/5zrWntJ/3Gz75MNnxRniO2qLUO37K
	+y73vlkvu7uN+Z689Y5VdtbBFqYCF0+ZWXybc/AKG8fKyEW1U8uVWIozEg21mIuKEwFMYQWQ
	CAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/vgg2432a4.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index 45e81b4..84d582f 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -208,12 +208,11 @@ static int vgg2432a4_lcd_init(struct ili9320 *lcd,
 #ifdef CONFIG_PM
 static int vgg2432a4_suspend(struct spi_device *spi, pm_message_t state)
 {
-	return ili9320_suspend(dev_get_drvdata(&spi->dev), state);
+	return ili9320_suspend(spi_get_drvdata(spi), state);
 }
-
 static int vgg2432a4_resume(struct spi_device *spi)
 {
-	return ili9320_resume(dev_get_drvdata(&spi->dev));
+	return ili9320_resume(spi_get_drvdata(spi));
 }
 #else
 #define vgg2432a4_suspend	NULL
@@ -242,12 +241,12 @@ static int vgg2432a4_probe(struct spi_device *spi)
 
 static int vgg2432a4_remove(struct spi_device *spi)
 {
-	return ili9320_remove(dev_get_drvdata(&spi->dev));
+	return ili9320_remove(spi_get_drvdata(spi));
 }
 
 static void vgg2432a4_shutdown(struct spi_device *spi)
 {
-	ili9320_shutdown(dev_get_drvdata(&spi->dev));
+	ili9320_shutdown(spi_get_drvdata(spi));
 }
 
 static struct spi_driver vgg2432a4_driver = {
-- 
1.7.2.5


