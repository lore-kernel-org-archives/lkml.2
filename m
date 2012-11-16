Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab2KPIg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:36:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11843 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2KPIgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:36:23 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-1a-50a5fb060bc0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: lcd: return ENXIO when ops functions cannot be
 called
Date: Fri, 16 Nov 2012 17:36:21 +0900
Message-id: <002b01cdc3d5$74ccc680$5e665380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3D1XSws5T8Ky+WQBq9zN05ZAMNRg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zI12230sDDB6t5rC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZU/q72Qoe8VbMvKzWwDiXu4uRk0NCwERi46Y+FghbTOLCvfVs
	ILaQwDJGiYZONZiaIxd+ANVwAcUXMUpMPLqGFcKZzSQxc0I7WAebgJrEly+H2UFsEYEIieYZ
	s5i7GDk4mAV8JDbP0gQJCwsES7TO/MkMYrMIqEpsujkFbDGvgK3ElZVzWSFsQYkfk++BxZkF
	tCTW7zzOBGHLS2xe8xZspISAusSjv7oQm/QkHj7ezQZRIiKx78U7RojxAhLfJh9igSiXldh0
	gBnkYgmBdnaJKTv6of6VlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIyRKpHYwrmywOMQowMGoxMMreHtpgBBrYllxZe4hRgkOZiUR3ukvgEK8
	KYmVValF+fFFpTmpxYcYfYAun8gsJZqcD4zgvJJ4Q2NjEzMTUxNzS1NzUxzCSuK8zR4pAUIC
	6YklqdmpqQWpRTDjmDg4pRoY4wO2RX0wSrvTVSRgIbNyw3KXuHXLjjaplpTc3HZPYdXl+5Z3
	q0R2aq+8+OmgQ8z87u8ndm1Pz69TEHlzUfzdlnkNrxaJMvt7ln3JEBF/PL1waenMJSxX+50i
	ppyemGr5J9Jf8Hu3u6mP3jQv7dCj4pYrMiRcv3jsW2nkJXuoxFztY/yrU5UGSizFGYmGWsxF
	xYkAFNnMl78CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV2230sDDA4+ZbG4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGVP6u9kKHvFWzLys1sA4
	l7uLkZNDQsBE4siFHywQtpjEhXvr2boYuTiEBBYxSkw8uoYVwpnNJDFzQjsbSBWbgJrEly+H
	2UFsEYEIieYZs5i7GDk4mAV8JDbP0gQJCwsES7TO/MkMYrMIqEpsujkFbAGvgK3ElZVzWSFs
	QYkfk++BxZkFtCTW7zzOBGHLS2xe8xZspISAusSjv7oQm/QkHj7ezQZRIiKx78U7xgmMArOQ
	TJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Cp9J7WBc2WBxiFGA
	g1GJh1fw9tIAIdbEsuLK3EOMEhzMSiK8018AhXhTEiurUovy44tKc1KLDzH6AD06kVlKNDkf
	mCDySuINjU3MjCyNzCyMTMzNcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamBMM/z9bov9
	kfDzX2u0HvCo/FMJOvvwkVX0A8MXvA4KzioRCzz3Vylb2XmcdC0PUJlfwVY8qfSGjfunjI3z
	npepr1t36hi3uv0de40Xwo+29EVvOKXvJjF/RtyFi+Wu7JM70sr/f1//KuPMXd5iz+bLqdt2
	J324ta1l6t1jb7tlXz6S+eqw9eUyJZbijERDLeai4kQAEQ+6K+8CAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, when ops functions cannot be called,
lcd_show_contrast() and lcd_store_contrast() returned 0,
instead of ENXIO.

Thus, in this case, a local variable 'rc' for return value
should be initialized as ENXIO, after kstrtoul() is called.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/lcd.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index a5d0d02..34fb6bd 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -108,7 +108,7 @@ static ssize_t lcd_show_power(struct device *dev, struct device_attribute *attr,
 static ssize_t lcd_store_power(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
+	int rc;
 	struct lcd_device *ld = to_lcd_device(dev);
 	unsigned long power;
 
@@ -116,6 +116,8 @@ static ssize_t lcd_store_power(struct device *dev,
 	if (rc)
 		return rc;
 
+	rc = -ENXIO;
+
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_power) {
 		pr_debug("set power to %lu\n", power);
@@ -144,7 +146,7 @@ static ssize_t lcd_show_contrast(struct device *dev,
 static ssize_t lcd_store_contrast(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	int rc = -ENXIO;
+	int rc;
 	struct lcd_device *ld = to_lcd_device(dev);
 	unsigned long contrast;
 
@@ -152,6 +154,8 @@ static ssize_t lcd_store_contrast(struct device *dev,
 	if (rc)
 		return rc;
 
+	rc = -ENXIO;
+
 	mutex_lock(&ld->ops_lock);
 	if (ld->ops && ld->ops->set_contrast) {
 		pr_debug("set contrast to %lu\n", contrast);
-- 
1.7.2.5


