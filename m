Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab2LUFYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:24:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50509 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUFYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:24:45 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c8-50d3f29bcdff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/6] backlight: aat2870: use bl_get_data instead of
 dev_get_drvdata
Date: Fri, 21 Dec 2012 14:24:43 +0900
Message-id: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fO3udRdsnHWRmS2i/6pBmiWTW1A==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zA93Zny4HGOw7b2xxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyPqyby1Rwh73i17sbrA2Ml9i6GDk4JARMJBZvi+9i5AQyxSQu
	3FsPFObiEBJYxihx7t0VJoiEiUT/r/+sEInpjBLP3s5khnBmM0ls3H6dFaSKTUBN4suXw+wg
	tohAhETzjFnMIBuYBXwkNs/SBAkLC4RKzNj3jRnEZhFQlTi45gxYOa+ArUTjnGMsELagxI/J
	98BsZgEtifU7jzNB2PISm9e8ZYY4Wl3i0V9diE16Em0nfjJDlIhI7HvxjhFivIDEt8mHWCDK
	ZSU2HQC7WEKgmV3i7o0N7BB/SUocXHGDZQKj2Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iRESJ1I7GFc2WBxiFOBgVOLhZTS7HCDEmlhWXJl7iFGCg1lJhNf/
	A1CINyWxsiq1KD++qDQntfgQow/Q5ROZpUST84ExnFcSb2hsbGJmYmpibmlqbopDWEmct9kj
	JUBIID2xJDU7NbUgtQhmHBMHp1QDY7Us9+V7u0RKzA5M7/9Yt8pKZcafx0ptRY5s2264BKbm
	1B16F6BTOeFj+HSTTUfrO+ftDIt/rOC1sF9jS/buzqkF2ddNTjqaZeqYfZjKvzlEQeOdTeG0
	dUydgQ9ZjwWvCeYxvh2zt7tFvTLTtZ5HrvBQt+7eua9uTzfP0N/oMffBWoZPS9anK7EUZyQa
	ajEXFScCACv7OvLAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd3Zny4HGExqNrC4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGR/WzWUquMNe8evdDdYG
	xktsXYycHBICJhL9v/6zQthiEhfurQeKc3EICUxnlHj2diYzhDObSWLj9utgVWwCahJfvhxm
	B7FFBCIkmmfMAiri4GAW8JHYPEsTJCwsECoxY983ZhCbRUBV4uCaM2DlvAK2Eo1zjrFA2IIS
	PybfA7OZBbQk1u88zgRhy0tsXvMWbKSEgLrEo7+6EJv0JNpO/GSGKBGR2PfiHeMERoFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHIfPpHYwrmywOMQowMGo
	xMPLaHY5QIg1say4MvcQowQHs5IIr/8HoBBvSmJlVWpRfnxRaU5q8SFGH6BHJzJLiSbnA1NE
	Xkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2Mm+s2lV6Y0f26
	fEnfybxt/040360sZz2r+vLNjokJxgfrCqXT/Z6fW33X6tnrm1uufpn5opj5Q4Dhx36l9IMa
	cuWPPsjeTcoUktD4GL81PnEix+uV7l5P1Jps2uz6qy+Z7RBS0XiwWMvHzCUwePGuiMu7tGsZ
	2utiKmc+r1esXzb1dyPr/ZP2SizFGYmGWsxFxYkA7tR7S/ACAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev,
so we can directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/aat2870_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index 7ff7522..c6fc668 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -74,7 +74,7 @@ static int aat2870_bl_get_brightness(struct backlight_device *bd)
 
 static int aat2870_bl_update_status(struct backlight_device *bd)
 {
-	struct aat2870_bl_driver_data *aat2870_bl = dev_get_drvdata(&bd->dev);
+	struct aat2870_bl_driver_data *aat2870_bl = bl_get_data(bd);
 	struct aat2870_data *aat2870 =
 			dev_get_drvdata(aat2870_bl->pdev->dev.parent);
 	int brightness = bd->props.brightness;
-- 
1.7.2.5


