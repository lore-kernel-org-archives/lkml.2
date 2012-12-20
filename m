Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2LTGip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:38:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23497 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2LTGij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:38:39 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-aa-50d2b26e404e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
In-reply-to: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
Subject: [PATCH 4/5] backlight: ld9040: remove redundant return variables
Date: Thu, 20 Dec 2012 15:38:38 +0900
Message-id: <001201cdde7c$a4a59b40$edf0d1c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3efF04bK/W++SuRFi0yIAkd2rsTAAADp0Q
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zY928TZcCDN7OVLG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZF04uYyy4JVhxYdlCpgbG3XxdjJwcEgImEv17VjJC2GISF+6t
	Z+ti5OIQEljGKLF39wEmmKJnew4xQyQWMUo8ODeZBcKZzSQx6cUZsCo2ATWJL18Os4PYIgIR
	Es0zZgF1cHAwC/hIbJ6lCRIWErCVWLBhAlgJp4CdxOzb01hBbGEBT4nG7XPA4iwCqhLzz81k
	AbF5geqP3ZrABmELSvyYfA8sziygJbF+53EmCFteYvOat2CrJATUJR791YW4wEhi7saZ7BAl
	IhL7XrxjhBgvIPFt8iEWiHJZiU0HwN6SEFjGLjFt5nJoQEhKHFxxg2UCo8QsJJtnIdk8C8nm
	WUhWLGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kREllSOxhXNlgcYhTgYFTi4V007VKA
	EGtiWXFl7iFGCQ5mJRHehbcuBgjxpiRWVqUW5ccXleakFh9i9AG6fCKzlGhyPjDq80riDY2N
	TcxMTE3MLU3NTXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgdHQLuPmv5UHH3eTwpAhf
	sbVstcdzBQu3Vxz3VZM5vmJBzwElxa077i806Th7xftr5Qwn//yDQvUl547P5PH/cenHZuOt
	oRsPVmWXNe1MXjPj7OPjuorbHOQ5lAPCXNJXOmftXhnbe2j93wn+c799c76Q0X4lVIyrt3pq
	ikLSqQ0bam1Wm7jfUGIpzkg01GIuKk4EADxTqY/ZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd28TZcCDJYtV7C4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGRdOLmMsuCVYcWHZQqYG
	xt18XYycHBICJhLP9hxihrDFJC7cW8/WxcjFISSwiFHiwbnJLBDObCaJSS/OMIFUsQmoSXz5
	cpgdxBYRiJBonjELqJuDg1nAR2LzLE2QsJCArcSCDRPASjgF7CRm357GCmILC3hKNG6fAxZn
	EVCVmH9uJguIzQtUf+zWBDYIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17wFWyUhoC7x6K8uxAVG
	EnM3zmSHKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeu
	l5yfu4kRHLfPpHYwrmywOMQowMGoxMO7aNqlACHWxLLiytxDjBIczEoivAtvXQwQ4k1JrKxK
	LcqPLyrNSS0+xOgD9OhEZinR5HxgSskriTc0NjEzsjQyszAyMTfHIawkztvskRIgJJCeWJKa
	nZpakFoEM46Jg1OqgVF7p6C2BPOe/oI97Q41f58d42CJePbj4ob6ulKV7IMnpm69VCY4o+6g
	1uS6SMl+gSlB+4tnxuX9ePLTbCf3A/ltjxa8WlDW0xj8QnKPjqyNW6BXnHCP+ekG7a/rdgT3
	3WOPaN+xuzKZ/9uJ+unzM3YJCzcJXuE6vWV6L1+kuMcvg4VrfPd79CuxFGckGmoxFxUnAgB9
	MDSkCAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redundant return variables are removed to reduce the code.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index fd7bb1c..bdc1a7e 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -513,14 +513,9 @@ gamma_err:
 
 static int ld9040_gamma_ctl(struct ld9040 *lcd, int gamma)
 {
-	int ret = 0;
-
-	ret = _ld9040_gamma_ctl(lcd, gamma_table.gamma_22_table[gamma]);
-
-	return ret;
+	return _ld9040_gamma_ctl(lcd, gamma_table.gamma_22_table[gamma]);
 }
 
-
 static int ld9040_ldi_init(struct ld9040 *lcd)
 {
 	int ret, i;
@@ -549,11 +544,7 @@ static int ld9040_ldi_init(struct ld9040 *lcd)
 
 static int ld9040_ldi_enable(struct ld9040 *lcd)
 {
-	int ret = 0;
-
-	ret = ld9040_panel_send_sequence(lcd, seq_display_on);
-
-	return ret;
+	return ld9040_panel_send_sequence(lcd, seq_display_on);
 }
 
 static int ld9040_ldi_disable(struct ld9040 *lcd)
@@ -696,7 +687,6 @@ static const struct backlight_ops ld9040_backlight_ops  = {
 	.update_status = ld9040_set_brightness,
 };
 
-
 static int ld9040_probe(struct spi_device *spi)
 {
 	int ret = 0;
@@ -802,7 +792,6 @@ static int ld9040_remove(struct spi_device *spi)
 #if defined(CONFIG_PM)
 static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	int ret = 0;
 	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
@@ -811,21 +800,16 @@ static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
 	 * when lcd panel is suspend, lcd panel becomes off
 	 * regardless of status.
 	 */
-	ret = ld9040_power(lcd, FB_BLANK_POWERDOWN);
-
-	return ret;
+	return ld9040_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int ld9040_resume(struct spi_device *spi)
 {
-	int ret = 0;
 	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
-	ret = ld9040_power(lcd, FB_BLANK_UNBLANK);
-
-	return ret;
+	return ld9040_power(lcd, FB_BLANK_UNBLANK);
 }
 #else
 #define ld9040_suspend		NULL
-- 
1.7.2.5


