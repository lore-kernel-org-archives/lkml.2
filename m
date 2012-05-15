Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab2EOH4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:56:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22604 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab2EOH4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:56:49 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-0c-4fb20c406a0d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Andrzej Zaborowski'" <balrogg@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 6/7] backlight: omap1: use pr_info instead of printk
Date: Tue, 15 May 2012 16:56:48 +0900
Message-id: <001101cd3270$47d85be0$d78913a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0ycEezchhJ3mz2ToKbCbQ2BqJ/qg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_info instead of printk to allow dynamic debugging.

It also fixes checkpatch warning as below:
WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

Cc: Andrzej Zaborowski <balrogg@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/omap1_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 0175bfb..4e191e5 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -168,7 +168,7 @@ static int omapbl_probe(struct platform_device *pdev)
 	dev->props.brightness = pdata->default_intensity;
 	omapbl_update_status(dev);
 
-	printk(KERN_INFO "OMAP LCD backlight initialised\n");
+	pr_info("OMAP LCD backlight initialised\n");
 
 	return 0;
 }
-- 
1.7.1


