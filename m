Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2LTGhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:37:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23335 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2LTGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:37:47 -0500
X-AuditID: cbfee61b-b7f616d00000319b-69-50d2b23a23f1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
In-reply-to: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
Subject: [PATCH 2/5] backlight: ld9040: remove unnecessary NULL deference check
Date: Thu, 20 Dec 2012 15:37:45 +0900
Message-id: <001001cdde7c$855e6780$901b3680$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3efF04bK/W++SuRFi0yIAkd2rsTAAAAlVg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zA12rTZcCDBav4LS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ2zvOMRb0C1VcPXqYvYHxAl8XIyeHhICJRMuyFywQtpjEhXvr
	2boYuTiEBJYxSnxqXcUKU/TxyWdGEFtIYDqjxNQvHBBFs5kkns2cAZZgE1CT+PLlMDuILSIQ
	IdE8YxZzFyMHB7OAj8TmWZoQvbYSCzZMACvhFLCTmH17Gth8YQF/iZYH+8HGsAioSjy6Nhes
	lReo/sTGCpAwr4CgxI/J98DuZBbQkli/8zgThC0vsXnNW7ByCQF1iUd/dSEOMJLY3twLVS4i
	se/FO6jpAhLfJh9igSiXldh0gBnkEQmBeewS9y5vZoT4VlLi4IobLBMYJWYh2TwLyeZZSDbP
	QrJiASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYyQqJLewbiqweIQowAHoxIP76JplwKE
	WBPLiitzDzFKcDArifAuvHUxQIg3JbGyKrUoP76oNCe1+BCjD9DlE5mlRJPzgRGfVxJvaGxs
	YmZiamJuaWpuikNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAMj83rPOnWNjptZQuzRtdzL
	pP8llU7ZtH92TlftqUSVtzfXboxX/Xo+t+OiozxHy94XG++fZwlKcSzZ/TspblOc6gaFQwbO
	1Rvm7Zq/lu/Ny5QvcwWK3z3kP7XIREmcw4zD4vXMtOavMvMFLlsLmrz4XPUqz2GTGmfs3pXR
	64vFW6/tMsmbt+W3EktxRqKhFnNRcSIAtGJl5NcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQV2rTZcCDBovs1hc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjO0d5xgL+oUqrh49zN7A
	eIGvi5GTQ0LAROLjk8+MELaYxIV769lAbCGB6YwSU79wdDFyAdmzmSSezZwBVsQmoCbx5cth
	dhBbRCBConnGLOYuRg4OZgEfic2zNCF6bSUWbJgAVsIpYCcx+/Y0VhBbWMBfouXBfrAxLAKq
	Eo+uzQVr5QWqP7GxAiTMKyAo8WPyPRYQm1lAS2L9zuNMELa8xOY1b8HKJQTUJR791YU4wEhi
	e3MvVLmIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT8
	3E2M4Jh9Jr2DcVWDxSFGAQ5GJR7eRdMuBQixJpYVV+YeYpTgYFYS4V1462KAEG9KYmVValF+
	fFFpTmrxIUYfoD8nMkuJJucD00leSbyhsYmZkaWRmYWRibk5DmElcd5mj5QAIYH0xJLU7NTU
	gtQimHFMHJxSDYxqhgYHBJseSTxNctvj0nuk5u56sVqrpqQTHQamtnkby6XOfOt42jCfWT5N
	eKvlVrX1D5sMDCqNDQwv1G/OFkiLPXUiVOzBxM+X2f5J8ahtaAnYc8Mh49n3DC2FHwtZTPbs
	WKEcxSEYU+MWbLHuSWGGyP+QoFgvCaUvURZG3dqaa2+6TY3cqcRSnJFoqMVcVJwIAKgtNsMG	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary NULL deference check, because it
was already checked in ld9040_probe(). Also, power_is_on is
replaced with ld9040_power_is_on().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index a52a6a7..45f795a 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -43,7 +43,6 @@
 
 #define MIN_BRIGHTNESS		0
 #define MAX_BRIGHTNESS		24
-#define power_is_on(pwr)	((pwr) <= FB_BLANK_NORMAL)
 
 struct ld9040 {
 	struct device			*dev;
@@ -567,15 +566,17 @@ static int ld9040_ldi_disable(struct ld9040 *lcd)
 	return ret;
 }
 
+static int ld9040_power_is_on(int power)
+{
+	return power <= FB_BLANK_NORMAL;
+}
+
 static int ld9040_power_on(struct ld9040 *lcd)
 {
 	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
+	struct lcd_platform_data *pd;
+
 	pd = lcd->lcd_pd;
-	if (!pd) {
-		dev_err(lcd->dev, "platform data is NULL.\n");
-		return -EFAULT;
-	}
 
 	/* lcd power on */
 	ld9040_regulator_enable(lcd);
@@ -605,14 +606,10 @@ static int ld9040_power_on(struct ld9040 *lcd)
 
 static int ld9040_power_off(struct ld9040 *lcd)
 {
-	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
+	int ret;
+	struct lcd_platform_data *pd;
 
 	pd = lcd->lcd_pd;
-	if (!pd) {
-		dev_err(lcd->dev, "platform data is NULL.\n");
-		return -EFAULT;
-	}
 
 	ret = ld9040_ldi_disable(lcd);
 	if (ret) {
@@ -632,9 +629,9 @@ static int ld9040_power(struct ld9040 *lcd, int power)
 {
 	int ret = 0;
 
-	if (power_is_on(power) && !power_is_on(lcd->power))
+	if (ld9040_power_is_on(power) && !ld9040_power_is_on(lcd->power))
 		ret = ld9040_power_on(lcd);
-	else if (!power_is_on(power) && power_is_on(lcd->power))
+	else if (!ld9040_power_is_on(power) && ld9040_power_is_on(lcd->power))
 		ret = ld9040_power_off(lcd);
 
 	if (!ret)
@@ -773,8 +770,9 @@ static int ld9040_probe(struct spi_device *spi)
 		lcd->power = FB_BLANK_POWERDOWN;
 
 		ld9040_power(lcd, FB_BLANK_UNBLANK);
-	} else
+	} else {
 		lcd->power = FB_BLANK_UNBLANK;
+	}
 
 	dev_set_drvdata(&spi->dev, lcd);
 
-- 
1.7.2.5


