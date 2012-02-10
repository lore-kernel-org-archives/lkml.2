Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2BJPlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:41:47 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:42906
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751904Ab2BJPlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:41:46 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: wim@iguana.be, linux-watchdog@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] watchdog: Fix typo in pnx4008_wdt.c
Date: Sat, 11 Feb 2012 00:40:56 +0900
Message-Id: <1328888456-3827-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "resouce" to "resource" in
drivers/watchdog/pnx4008_wdt.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/watchdog/pnx4008_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 8e210aa..dfae030 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -264,7 +264,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (wdt_mem == NULL) {
 		printk(KERN_INFO MODULE_NAME
-			"failed to get memory region resouce\n");
+			"failed to get memory region resource\n");
 		return -ENOENT;
 	}
 
-- 
1.7.6.5

