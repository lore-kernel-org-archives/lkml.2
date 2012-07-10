Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2GJLZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:25:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55669 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2GJLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:25:07 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: greg@kroah.com, willy@meta-x.org
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 2/3] panel: Use pr_info(...) rather than printk(KERN_INFO ...)
Date: Tue, 10 Jul 2012 20:24:51 +0900
Message-Id: <1341919491-8868-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1341919338-8800-1-git-send-email-yamanetoshi@gmail.com>
References: <1341919338-8800-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is inspired by checkpatch.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/panel/panel.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 6f40ec8..7b79f53 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -2298,12 +2298,12 @@ int panel_init(void)
 	register_reboot_notifier(&panel_notifier);
 
 	if (pprt)
-		printk(KERN_INFO "Panel driver version " PANEL_VERSION
-		       " registered on parport%d (io=0x%lx).\n", parport,
-		       pprt->port->base);
+		pr_info("Panel driver version " PANEL_VERSION
+			" registered on parport%d (io=0x%lx).\n", parport,
+			pprt->port->base);
 	else
-		printk(KERN_INFO "Panel driver version " PANEL_VERSION
-		       " not yet registered\n");
+		pr_info("Panel driver version " PANEL_VERSION
+			" not yet registered\n");
 	/* tells various subsystems about the fact that initialization
 	   is finished */
 	init_in_progress = 0;
-- 
1.7.5.4

