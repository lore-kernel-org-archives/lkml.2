Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2BHLvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:51:23 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:50342
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756130Ab2BHLvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:51:22 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] jffs2: Fix typo in compr.c
Date: Wed,  8 Feb 2012 20:39:39 +0900
Message-Id: <1328701179-1823-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "modul" to "module" in
fs/hffs2/compr.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/jffs2/compr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index 5b6c9d1..96ed3c9 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -340,7 +340,7 @@ int jffs2_unregister_compressor(struct jffs2_compressor *comp)
 
 	if (comp->usecount) {
 		spin_unlock(&jffs2_compressor_list_lock);
-		printk(KERN_WARNING "JFFS2: Compressor modul is in use. Unregister failed.\n");
+		printk(KERN_WARNING "JFFS2: Compressor module is in use. Unregister failed.\n");
 		return -1;
 	}
 	list_del(&comp->list);
-- 
1.7.6.5

