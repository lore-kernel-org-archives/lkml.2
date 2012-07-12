Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab2GLNAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:00:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35490 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab2GLNAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:00:40 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: greg@kroah.com, willy@meta-x.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, rmallon@gmail.com,
        Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 1/3] panel: Remove printk(KERN_DEBUG ...) located in the #if 0 block
Date: Thu, 12 Jul 2012 22:00:33 +0900
Message-Id: <1342098033-7932-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deleted #if 0 blocks

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/panel/panel.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 7365089..c625567 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1837,12 +1837,6 @@ static void panel_process_inputs(void)
 	struct list_head *item;
 	struct logical_input *input;
 
-#if 0
-	printk(KERN_DEBUG
-	       "entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
-	       phys_prev, phys_curr);
-#endif
-
 	keypressed = 0;
 	inputs_stable = 1;
 	list_for_each(item, &logical_inputs) {
@@ -2002,10 +1996,6 @@ static struct logical_input *panel_bind_key(char *name, char *press,
 	key->rise_time = 1;
 	key->fall_time = 1;
 
-#if 0
-	printk(KERN_DEBUG "bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
-	       key->value);
-#endif
 	strncpy(key->u.kbd.press_str, press, sizeof(key->u.kbd.press_str));
 	strncpy(key->u.kbd.repeat_str, repeat, sizeof(key->u.kbd.repeat_str));
 	strncpy(key->u.kbd.release_str, release,
-- 
1.7.5.4

