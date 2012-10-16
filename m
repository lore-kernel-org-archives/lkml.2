Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2JPH2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:28:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15922 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPH2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:28:17 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-dc-507d0c90f706
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 05/17] backlight: generic_bl: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:28:16 +0900
Message-id: <007601cdab6f$cecc56b0$6c650410$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAFPig
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd0JPLUBBs+OyFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mr1ffsRV0sFcs+D+FuYHxE2sXIweHhICJxN5p4V2MnECmmMSF
	e+vZuhi5OIQEFjFKrJvWzA7hzGaS2L53PitIFZuAmsSXL4fZQWwRgQiJ5hmzmEEGMQv4SGye
	pQkSFhKwlVg94y1YCaeAncTG1wdZQGxhAReJFde/MILYLAKqEndXN4ON5AWqX3LkC5QtKPFj
	8j2wemYBLYn1O48zQdjyEpvXvGWGuFld4tFfXYgLjCSWTnrDCFEiIrHvxTvGCYxCs5BMmoVk
	0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziIn0nvYFzVYHGIUYCDUYmH
	N8O5JkCINbGsuDL3EKMEB7OSCK/HRKAQb0piZVVqUX58UWlOavEhRmkOFiVx3maPlAAhgfTE
	ktTs1NSC1CKYLBMHp1QD4/Qz+ud+Ol/PzCiYvbycd4Fghckrz9UzD+Zv9A/ZuPzy1c6O2z8v
	uvBOO7zgf6n31FNeGe/uOPFcmyDC6dN7dNq5hg2bY2Q9exi25ZjP8LrElZKs4SGYp/ZT59ui
	mCa7k1lWXb58Py0ki4RshHJfi+39tad7dmuEMBfD1VQOCxbXctEvxnGnlViKMxINtZiLihMB
	fQGFBF4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/generic_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 8c660fc..0ae155b 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -97,8 +97,8 @@ static int genericbl_probe(struct platform_device *pdev)
 	props.max_brightness = machinfo->max_intensity;
 	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
 				       &props);
-	if (IS_ERR (bd))
-		return PTR_ERR (bd);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
 
 	platform_set_drvdata(pdev, bd);
 
-- 
1.7.1


