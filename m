Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3ADI3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:29:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59970 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3ADI3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:29:13 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e5-50e692d76de2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: linux-fbdev@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Devendra Naga'" <devendra.aaru@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: check null deference of name when device is
 registered
Date: Fri, 04 Jan 2013 17:29:11 +0900
Message-id: <000b01cdea55$92725aa0$b7570fe0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3qVZI++i682cSySRuYEVWyvVvaGQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zQ93rk54FGPzapGFxou8Dq8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo41PyDreAzd8WxGU+YGxj/cnYxcnJICJhITN51khXC
	FpO4cG89WxcjF4eQwDJGiU+/VrPAFB2+9JwVIrGIUWLLyWVQVb8YJf4vfckMUsUmoCbx5cth
	dhBbRCBConnGLGaQImaBaYwSkzccYQJJCAuESJzduBlsLIuAqkT3yXVgcV4BW4kVi1pYIWxB
	iR+T74HVMAtoSazfeZwJwpaX2LzmLdBQDqCT1CUe/dWF2KUnMXH2I6gSEYl9L94xQowXkPg2
	+RALRLmsxKYDYOdICExml1jWtYwZ4jNJiYMrbrBMYBSbhWTzLCSbZyHZPAvJigWMLKsYRVML
	kguKk9JzjfSKE3OLS/PS9ZLzczcxQuJGegfjqgaLQ4wCHIxKPLyWd54GCLEmlhVX5h5ilOBg
	VhLh/az9LECINyWxsiq1KD++qDQntfgQow/Q5ROZpUST84ExnVcSb2hsbGJmYmpibmlqbopD
	WEmcl/HUkwAhgfTEktTs1NSC1CKYcUwcnFINjPUsR6cmTo/olrxQyVG+q+JK8SpzBqnudq7X
	QX/4Chs2xhrMcLnMs2IrxzzO/zLmcdfcOFMXSXvqNMtZvTH3+57/5eoi1bmJdWZLS3aZndFf
	I3Hzdklg1o5Dl0Q6+/ZHTT68feIB3h+7s24saU5ISeL5ZqvOzNy5uvKa2uza5iUfmT/vmKMc
	pMRSnJFoqMVcVJwIAE07lB7IAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd3rk54FGLROVbY40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmHGr+wVbwmbvi
	2IwnzA2Mfzm7GDk5JARMJA5fes4KYYtJXLi3nq2LkYtDSGARo8SWk8ugnF+MEv+XvmQGqWIT
	UJP48uUwO4gtIhAh0TxjFjNIEbPANEaJyRuOMIEkhAVCJM5u3MwCYrMIqEp0n1wHFucVsJVY
	saiFFcIWlPgx+R5YDbOAlsT6nceZIGx5ic1r3gIN5QA6SV3i0V9diF16EhNnP4IqEZHY9+Id
	4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREclc+kdzCu
	arA4xCjAwajEw2t552mAEGtiWXFl7iFGCQ5mJRHez9rPAoR4UxIrq1KL8uOLSnNSiw8x+gA9
	OpFZSjQ5H5gw8kriDY1NzIwsjcwsjEzMzXEIK4nzMp56EiAkkJ5YkpqdmlqQWgQzjomDU6qB
	cXpKjkbKzKMH1YQXb2fd9nP24+W509+cbdv0506jok3/Focq078JBXs/GMXofF+qkjDzoL/b
	xp9br/Kydd75IqhWO+3e2qU/d3baXu8v4Q+e8fT48f+imssf1PGdm2XDubH86fSD8U+n7Oby
	nCbzK9to1t1w1lNK65mKldlvCL489GXbdJ6g7/VKLMUZiYZazEXFiQC4Fu8X9wIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NULL deference of name is checked when device is registered.
If the name is null, it will cause a kernel oops in dev_set_name().

Acked-by: Devendra Naga <devendra.aaru@gmail.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/backlight.c |    5 +++++
 drivers/video/backlight/lcd.c       |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 345f666..f2db904 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -292,6 +292,11 @@ struct backlight_device *backlight_device_register(const char *name,
 	struct backlight_device *new_bd;
 	int rc;
 
+	if (name == NULL) {
+		pr_err("backlight name is null\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	pr_debug("backlight_device_register: name=%s\n", name);
 
 	new_bd = kzalloc(sizeof(struct backlight_device), GFP_KERNEL);
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 34fb6bd..3d0ac0c 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -207,6 +207,11 @@ struct lcd_device *lcd_device_register(const char *name, struct device *parent,
 	struct lcd_device *new_ld;
 	int rc;
 
+	if (name == NULL) {
+		pr_err("lcd name is null\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	pr_debug("lcd_device_register: name=%s\n", name);
 
 	new_ld = kzalloc(sizeof(struct lcd_device), GFP_KERNEL);
-- 
1.7.2.5


