Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2LTGfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:35:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16248 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2LTGfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:35:38 -0500
X-AuditID: cbfee61b-b7f616d00000319b-2d-50d2b1b9f3b4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
In-reply-to: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
Subject: [PATCH 5/6] backlight: s6e63m0: remove redundant variable
 'before_power'
Date: Thu, 20 Dec 2012 15:35:37 +0900
Message-id: <000d01cdde7c$38f936e0$aaeba4a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ee9s5WLGjeuuhRceS0Ez4r5xE9AAAFDtQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zQ92dGy8FGEzssbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZfzfvZC1o5K+4vfIpSwPjfJ4uRk4OCQETiYe/ZjNB2GISF+6t
	Z+ti5OIQEljGKNG99CorTNHhX2sZIRLTGSWap0yDcmYzSazctp4dpIpNQE3iy5fDYLaIQIRE
	84xZzF2MHBzMAj4Sm2dpgoSFBGwl7iz+xwJicwrYSTR+2A1WLiwQLPH1z1KwZSwCqhLzph1g
	A7F5gepPtZ9ghrAFJX5MvgfWyyygJbF+53EmCFteYvOat2CrJATUJR791YW4wEji/ta5rBAl
	IhL7XrxjhBgvIPFt8iEWiHJZiU0HmEE+kRBYxi7RdW8dNCAkJQ6uuMEygVFiFpLNs5BsnoVk
	8ywkKxYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECIks6R2MqxosDjEKcDAq8fAumnYp
	QIg1say4MvcQowQHs5II78JbFwOEeFMSK6tSi/Lji0pzUosPMfoAXT6RWUo0OR8Y9Xkl8YbG
	xiZmJqYm5pam5qY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1MGodqjnz/dv/gE/vT8wL
	W6Q8be3vWRtuu059w9Iwq/JmilpWZt2Up1Ja7J36p8pztqa6/slxfu9d+j9uSm36pN3PhWRC
	1T0aKlYa/5px+fGxC7cuV/27J78kTWaq3LHtO03buSs3LFlSxKfm/Unj85TcN3fMLyz8kmTP
	ZHdmhuJzoaVx7g/6959RYinOSDTUYi4qTgQAz+XfRtkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jQd2dGy8FGPTtM7W4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGX8372QtaOSvuL3yKUsD
	43yeLkZODgkBE4nDv9YyQthiEhfurWfrYuTiEBKYzijRPGUaI4Qzm0li5bb17CBVbAJqEl++
	HAazRQQiJJpnzGLuYuTgYBbwkdg8SxMkLCRgK3Fn8T8WEJtTwE6i8cNusHJhgWCJr3+WsoLY
	LAKqEvOmHWADsXmB6k+1n2CGsAUlfky+B9bLLKAlsX7ncSYIW15i85q3YKskBNQlHv3VhbjA
	SOL+1rmsECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS
	9ZLzczcxguP2mfQOxlUNFocYBTgYlXh4F027FCDEmlhWXJl7iFGCg1lJhHfhrYsBQrwpiZVV
	qUX58UWlOanFhxh9gB6dyCwlmpwPTCl5JfGGxiZmRpZGZhZGJubmOISVxHmbPVIChATSE0tS
	s1NTC1KLYMYxcXBKNTCyTpnWIVC40nrfTJ6qRUxaOuIFWR4vuCrfLz/RvXuuwybr06ElX5by
	yj9UWrF4yvyoLGnrQ0davNnlam3XuCe3mvYofF/q829a3r8LQVL52xlaoz78OP381/3M50nC
	AvPtZHWE1n2fFWH6bmu3tr7Dj8YOZoXrHTYX/d06NO+ZL2pcdf+RD7sSS3FGoqEWc1FxIgAC
	G12nCAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'before_power' was used to check the previous status when resume()
is called. However, FB_BLANK_POWERDOWN was used in suspend() all
the time, so there is no need to check the previous status.
Also, redundant return variables are removed to reduce the code.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/s6e63m0.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 87831bb..92e53e2 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -827,44 +827,26 @@ static int s6e63m0_remove(struct spi_device *spi)
 }
 
 #if defined(CONFIG_PM)
-static unsigned int before_power;
-
 static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	int ret = 0;
 	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
-	before_power = lcd->power;
-
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
 	 * regardless of status.
 	 */
-	ret = s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
-
-	return ret;
+	return s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int s6e63m0_resume(struct spi_device *spi)
 {
-	int ret = 0;
 	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
 
-	/*
-	 * after suspended, if lcd panel status is FB_BLANK_UNBLANK
-	 * (at that time, before_power is FB_BLANK_UNBLANK) then
-	 * it changes that status to FB_BLANK_POWERDOWN to get lcd on.
-	 */
-	if (before_power == FB_BLANK_UNBLANK)
-		lcd->power = FB_BLANK_POWERDOWN;
+	lcd->power = FB_BLANK_POWERDOWN;
 
-	dev_dbg(&spi->dev, "before_power = %d\n", before_power);
-
-	ret = s6e63m0_power(lcd, before_power);
-
-	return ret;
+	return s6e63m0_power(lcd, FB_BLANK_UNBLANK);
 }
 #else
 #define s6e63m0_suspend		NULL
-- 
1.7.2.5


