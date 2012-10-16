Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2JPH1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:27:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24779 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPH1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:27:51 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-ea-507d0c75597d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 04/17] backlight: da903x_bl: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:27:49 +0900
Message-id: <007501cdab6f$bedb1200$3c913600$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAD9+w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd1SntoAg5YuXYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxcn1iQT9Pxd6mDWwNjPO4uhg5OSQETCRezZnCBGGLSVy4t56t
	i5GLQ0hgOqNE59sPrBDObCaJcxNusIJUsQmoSXz5cpgdxBYRiJBonjGLuYuRg4NZwEdi8yxN
	kLCQgK3E6hlvwUo4BewkNr4+yAJiCws4S1zvecAIYrMIqEpMO7WLGcTmBaqf0bMcyhaU+DH5
	Hlg9s4CWxPqdx5kgbHmJzWvegq2SEFCXePRXF+ICI4mVvTPZIEpEJPa9eMc4gVFoFpJJs5BM
	moVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfxM6kdjCsbLA4xCnAwKvHw
	ZjjXBAixJpYVV+YeYpTgYFYS4fWYCBTiTUmsrEotyo8vKs1JLT7EKM3BoiTO2+yREiAkkJ5Y
	kpqdmlqQWgSTZeLglGpgXHhNUL5PZfKVDrNNX+eFH76l9WOt0c/6PnX79qdPnWNfWQsJZuzx
	vG9+THtLpeirf1d5f8adC54l75kUGvT249X+Jf0yFWvO3Wq8vvqQS4/an0m7WqfO2iYYP3uh
	1Wz3Z7dCNPkb3n7v+Nuq+4b97ezfGzb3zNpuqpWn9kx9sWKkXfzkuvfvbiuxFGckGmoxFxUn
	AgDtChfHXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: please, no space before tabs
WARNING: quoted string split across lines

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/da903x_bl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 573c7ec..f02e95c 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -2,10 +2,10 @@
  * Backlight driver for Dialog Semiconductor DA9030/DA9034
  *
  * Copyright (C) 2008 Compulab, Ltd.
- * 	Mike Rapoport <mike@compulab.co.il>
+ *	Mike Rapoport <mike@compulab.co.il>
  *
  * Copyright (C) 2006-2008 Marvell International Ltd.
- * 	Eric Miao <eric.miao@marvell.com>
+ *	Eric Miao <eric.miao@marvell.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -199,7 +199,7 @@ static struct platform_driver da903x_backlight_driver = {
 module_platform_driver(da903x_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for Dialog Semiconductor DA9030/DA9034");
-MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>"
-	      "Mike Rapoport <mike@compulab.co.il>");
+MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
+MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:da903x-backlight");
-- 
1.7.1


