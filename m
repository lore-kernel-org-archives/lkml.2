Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2GJLWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:22:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2GJLWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:22:30 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: greg@kroah.com, willy@meta-x.org
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 1/3] panel: Use pr_debug(...) rather than printk(KERN_DEBUG ...)
Date: Tue, 10 Jul 2012 20:22:18 +0900
Message-Id: <1341919338-8800-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is inspired by checkpatch.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/panel/panel.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 7365089..6f40ec8 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1838,9 +1838,8 @@ static void panel_process_inputs(void)
 	struct logical_input *input;
 
 #if 0
-	printk(KERN_DEBUG
-	       "entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
-	       phys_prev, phys_curr);
+	pr_debug("entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
+		 phys_prev, phys_curr);
 #endif
 
 	keypressed = 0;
@@ -2003,8 +2002,8 @@ static struct logical_input *panel_bind_key(char *name, char *press,
 	key->fall_time = 1;
 
 #if 0
-	printk(KERN_DEBUG "bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
-	       key->value);
+	pr_debug("bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
+		 key->value);
 #endif
 	strncpy(key->u.kbd.press_str, press, sizeof(key->u.kbd.press_str));
 	strncpy(key->u.kbd.repeat_str, repeat, sizeof(key->u.kbd.repeat_str));
-- 
1.7.5.4

