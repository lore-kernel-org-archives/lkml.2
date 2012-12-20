Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2LTGev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:34:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22712 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2LTGem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:34:42 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-3b-50d2b1811723
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
In-reply-to: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
Subject: [PATCH 3/6] backlight: s6e63m0: remove unnecessary NULL deference check
Date: Thu, 20 Dec 2012 15:34:41 +0900
Message-id: <000b01cdde7c$175f3980$461dac80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ee9s5WLGjeuuhRceS0Ez4r5xE9AAABpYw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zY93GjZcCDCbtUba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZU3btYS/YLlax4eRTtgbGTqEuRk4OCQETiZnntjFB2GISF+6t
	Z+ti5OIQEljGKPHsxnsmmKJfT86yQCSmM0q8/TqHEcKZzSTxa8dudpAqNgE1iS9fDoPZIgIR
	Es0zZjF3MXJwMAv4SGyepQkSFhKwlbiz+B8LiM0pYCfR+AGiVVggQKL78Uowm0VAVeLNry1g
	NbxA9f33OxkhbEGJH5PvgcWZBbQk1u88zgRhy0tsXvMWbJWEgLrEo7+6EBcYSVzvvsQIUSIi
	se/FO0aI8QIS3yYfYoEol5XYdIAZ5BMJgXnsEs3Petgh/pWUOLjiBssERolZSDbPQrJ5FpLN
	s5CsWMDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjJLKkdjCubLA4xCjAwajEw7to2qUA
	IdbEsuLK3EOMEhzMSiK8C29dDBDiTUmsrEotyo8vKs1JLT7E6AN0+URmKdHkfGDU55XEGxob
	m5iZmJqYW5qam+IQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXA6NY+71z34urA/2+q78lG
	5c+Sypdp+37ql6ZZkhbzg8hJwuWPBB59b3cxb2246+n9tiHou4/64rtveBnvBCcfXVDfZPjo
	J9eN9ScVYnYlaidN37LI5WvCF+9rvzV5NiZeDFE9qcvOfDRCnK9ok/6H3+wGutkWx79Knr50
	ROh5ywvbqeKlEiXLlFiKMxINtZiLihMB11hNqtkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jQd3GjZcCDK68lbO4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGVN27WEv2C5WseHkU7YG
	xk6hLkZODgkBE4lfT86yQNhiEhfurWfrYuTiEBKYzijx9uscRghnNpPErx272UGq2ATUJL58
	OQxmiwhESDTPmMXcxcjBwSzgI7F5liZIWEjAVuLO4n9gQzkF7CQaP0C0CgsESHQ/Xglmswio
	Srz5tQWshheovv9+JyOELSjxY/I9sDizgJbE+p3HmSBseYnNa96CrZIQUJd49FcX4gIjievd
	lxghSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefn
	bmIEx+0zqR2MKxssDjEKcDAq8fAumnYpQIg1say4MvcQowQHs5II78JbFwOEeFMSK6tSi/Lj
	i0pzUosPMfoAPTqRWUo0OR+YUvJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQnlqRmp6YW
	pBbBjGPi4JRqYDzr+pr3/7yXThaeb539+NSkv6s4ZgTYu84szndbU+li8nF12ut/5v9FOozL
	ZokwfyrYznWO3/nkdhd/ScWfh+R/vFlXobW3iKe2Ve7ivx8mF4r5+WcuVD7yXZcvcbNsR5eh
	+LHJF2pen0kvWLl68eWy2PC7SkekjLQ/TurVvOEZUOJ7fcbGAiWW4oxEQy3mouJEAFCnVRAI	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary NULL deference check, because it
was already checked in s6e63m0_probe(). Also, POWER_IS_ON is
replaced with s6e63m0_power_is_on().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/s6e63m0.c |   41 ++++++++++++------------------------
 1 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index cff4515..633f0d3 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -43,8 +43,6 @@
 #define MIN_BRIGHTNESS		0
 #define MAX_BRIGHTNESS		10
 
-#define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)
-
 struct s6e63m0 {
 	struct device			*dev;
 	struct spi_device		*spi;
@@ -501,23 +499,19 @@ static int s6e63m0_ldi_disable(struct s6e63m0 *lcd)
 	return ret;
 }
 
+static int s6e63m0_power_is_on(int power)
+{
+	return power <= FB_BLANK_NORMAL;
+}
+
 static int s6e63m0_power_on(struct s6e63m0 *lcd)
 {
 	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
-	struct backlight_device *bd = NULL;
+	struct lcd_platform_data *pd;
+	struct backlight_device *bd;
 
 	pd = lcd->lcd_pd;
-	if (!pd) {
-		dev_err(lcd->dev, "platform data is NULL.\n");
-		return -EFAULT;
-	}
-
 	bd = lcd->bd;
-	if (!bd) {
-		dev_err(lcd->dev, "backlight device is NULL.\n");
-		return -EFAULT;
-	}
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
@@ -559,14 +553,10 @@ static int s6e63m0_power_on(struct s6e63m0 *lcd)
 
 static int s6e63m0_power_off(struct s6e63m0 *lcd)
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
 
 	ret = s6e63m0_ldi_disable(lcd);
 	if (ret) {
@@ -576,11 +566,7 @@ static int s6e63m0_power_off(struct s6e63m0 *lcd)
 
 	msleep(pd->power_off_delay);
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
-	} else
-		pd->power_on(lcd->ld, 0);
+	pd->power_on(lcd->ld, 0);
 
 	return 0;
 }
@@ -589,9 +575,9 @@ static int s6e63m0_power(struct s6e63m0 *lcd, int power)
 {
 	int ret = 0;
 
-	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
+	if (s6e63m0_power_is_on(power) && !s6e63m0_power_is_on(lcd->power))
 		ret = s6e63m0_power_on(lcd);
-	else if (!POWER_IS_ON(power) && POWER_IS_ON(lcd->power))
+	else if (!s6e63m0_power_is_on(power) && s6e63m0_power_is_on(lcd->power))
 		ret = s6e63m0_power_off(lcd);
 
 	if (!ret)
@@ -812,8 +798,9 @@ static int s6e63m0_probe(struct spi_device *spi)
 		lcd->power = FB_BLANK_POWERDOWN;
 
 		s6e63m0_power(lcd, FB_BLANK_UNBLANK);
-	} else
+	} else {
 		lcd->power = FB_BLANK_UNBLANK;
+	}
 
 	dev_set_drvdata(&spi->dev, lcd);
 
-- 
1.7.2.5


