Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2LTG3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:29:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21777 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2LTG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:29:12 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ac-50d2b037cfd9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
In-reply-to: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
Subject: [PATCH 2/5] backlight: ams369fg06: remove unnecessary NULL deference
 check
Date: Thu, 20 Dec 2012 15:29:10 +0900
Message-id: <000501cdde7b$526fe160$f74fa420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3eeyqi7zfdOO97SfGBrHQPr76IuAAAAd1Q
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zQ13zDZcCDCZ85LG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZl04vYStoFKp48f4DcwPjSb4uRk4OCQETifdrm9ggbDGJC/fW
	A9lcHEICyxglXvXOZIcpmrn5OwtEYhGjxKJL55ghnNlMEo377zGCVLEJqEl8+XIYrENEIEKi
	ecYsoCIODmYBH4nNszRBwkICthLtcw8zgdicAnYSzR+OgpULC4RK9P06zgxiswioSlxsfwoW
	5wWqb73RxAhhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bsFUSAuoSj/7qQlxgJNGw/S47RImI
	xL4X7xghxgtIfJt8iAWiXFZi0wGwTyQEFrFLrFx2hRHiX0mJgytusExglJiFZPMsJJtnIdk8
	C8mKBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzFCIkt6B+OqBotDjAIcjEo8vIumXQoQ
	Yk0sK67MPcQowcGsJMK78NbFACHelMTKqtSi/Pii0pzU4kOMPkCXT2SWEk3OB0Z9Xkm8obGx
	iZmJqYm5pam5KQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2MWxRMWyvsvaN1Dh06zLFv
	WRH7o2iJX4578lZzK+q2+DqbKUycVjlj3UO2Ft4Gpuyd7yqDGG4v/HUy/unbGyoai95pLZyw
	d+a7TZcOdP28uPy2XFO/9Y6fhgoJZ4ycU/5xTLCpUox9nrno2d/pqR+um3S/FCmUPvuY25xB
	cefla0F8HpNNJfYbKLEUZyQaajEXFScCAEhruI/ZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAV3zDZcCDK5fYrO4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGZdOL2EraBSqePH+A3MD
	40m+LkZODgkBE4mZm7+zQNhiEhfurWfrYuTiEBJYxCix6NI5ZghnNpNE4/57jCBVbAJqEl++
	HGYHsUUEIiSaZ8wCKuLgYBbwkdg8SxMkLCRgK9E+9zATiM0pYCfR/OEoWLmwQKhE36/jzCA2
	i4CqxMX2p2BxXqD61htNjBC2oMSPyffADmIW0JJYv/M4E4QtL7F5zVuwVRIC6hKP/upCXGAk
	0bD9LjtEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS9
	5PzcTYzguH0mvYNxVYPFIUYBDkYlHt5F0y4FCLEmlhVX5h5ilOBgVhLhXXjrYoAQb0piZVVq
	UX58UWlOavEhRh+gRycyS4km5wNTSl5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAhgfTEktTs
	1NSC1CKYcUwcnFINjFUt3LUp+/izOL78PaHy6F0V38mtajNlviQZBWWcZ5565MLDjNzCEFPu
	OJ6w1O8NUsxOJztTQ5fJ6Ro1qoafchdW3ZEV8SzVXyWTMSswKCDfwfSXfPV5nkUGp//sWbLG
	RLNDYsePCWmaz6Mv/Sw4cPiOYRYn49EvJl/uSHjPftBQocYgfolViaU4I9FQi7moOBEAWDfZ
	YQgDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary NULL deference check, because
it was already checked in ams369fg06_probe(). Also, unnecessary
parentheses are removed in ams369fg06_power_is_on().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 55b2792..b4bf130 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -314,26 +314,17 @@ static int ams369fg06_ldi_disable(struct ams369fg06 *lcd)
 
 static int ams369fg06_power_is_on(int power)
 {
-	return ((power) <= FB_BLANK_NORMAL);
+	return power <= FB_BLANK_NORMAL;
 }
 
 static int ams369fg06_power_on(struct ams369fg06 *lcd)
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
@@ -375,14 +366,10 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
 
 static int ams369fg06_power_off(struct ams369fg06 *lcd)
 {
-	int ret = 0;
-	struct lcd_platform_data *pd = NULL;
+	int ret;
+	struct lcd_platform_data *pd;
 
 	pd = lcd->lcd_pd;
-	if (!pd) {
-		dev_err(lcd->dev, "platform data is NULL\n");
-		return -EFAULT;
-	}
 
 	ret = ams369fg06_ldi_disable(lcd);
 	if (ret) {
@@ -392,11 +379,7 @@ static int ams369fg06_power_off(struct ams369fg06 *lcd)
 
 	msleep(pd->power_off_delay);
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
-	} else
-		pd->power_on(lcd->ld, 0);
+	pd->power_on(lcd->ld, 0);
 
 	return 0;
 }
@@ -535,8 +518,9 @@ static int ams369fg06_probe(struct spi_device *spi)
 		lcd->power = FB_BLANK_POWERDOWN;
 
 		ams369fg06_power(lcd, FB_BLANK_UNBLANK);
-	} else
+	} else {
 		lcd->power = FB_BLANK_UNBLANK;
+	}
 
 	dev_set_drvdata(&spi->dev, lcd);
 
-- 
1.7.2.5


