Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab2GYMKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:10:18 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:46682 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932934Ab2GYMIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:08:52 -0400
From: Felipe Balbi <balbi@ti.com>
To: zbr@ioremap.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3/6] w1: omap-hdq: convert to module_platform_driver
Date: Wed, 25 Jul 2012 15:05:29 +0300
Message-Id: <1343217932-25372-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.11
In-Reply-To: <1343217932-25372-1-git-send-email-balbi@ti.com>
References: <1343217932-25372-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trivial patch, no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/w1/masters/omap_hdq.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 404a4de..1ebddcf 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -654,19 +654,7 @@ static int __devexit omap_hdq_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __init
-omap_hdq_init(void)
-{
-	return platform_driver_register(&omap_hdq_driver);
-}
-module_init(omap_hdq_init);
-
-static void __exit
-omap_hdq_exit(void)
-{
-	platform_driver_unregister(&omap_hdq_driver);
-}
-module_exit(omap_hdq_exit);
+module_platform_driver(omap_hdq_driver);
 
 module_param(w1_id, int, S_IRUSR);
 MODULE_PARM_DESC(w1_id, "1-wire id for the slave detection");
-- 
1.7.11

