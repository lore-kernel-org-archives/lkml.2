Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab2EOHzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:55:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28846 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab2EOHzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:55:00 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-61-4fb20bbf8ef4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 4/7] backlight: generic_bl: use pr_info instead of printk
Date: Tue, 15 May 2012 16:54:38 +0900
Message-id: <000f01cd326f$fa8325f0$ef8971d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0yb/pt5l0mTPhUTk6ywJswv1UhBg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_info instead of printk to allow dynamic debugging.
It also fixes checkpatch warnings as below:

WARNING: printk() should include KERN_ facility level

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/generic_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 9ce6170..fa57154 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -106,7 +106,7 @@ static int genericbl_probe(struct platform_device *pdev)
 
 	generic_backlight_device = bd;
 
-	printk("Generic Backlight Driver Initialized.\n");
+	pr_info("Generic Backlight Driver Initialized.\n");
 	return 0;
 }
 
@@ -120,7 +120,7 @@ static int genericbl_remove(struct platform_device *pdev)
 
 	backlight_device_unregister(bd);
 
-	printk("Generic Backlight Driver Unloaded\n");
+	pr_info("Generic Backlight Driver Unloaded\n");
 	return 0;
 }
 
-- 
1.7.1


