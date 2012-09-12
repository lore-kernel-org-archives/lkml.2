Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695Ab2ILRFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:05:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34282 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760787Ab2ILRDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:41 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] fs/jffs2/wbuf.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:21 +0200
Message-Id: <1347469402-27557-14-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 fs/jffs2/wbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index a6597d6..bea0487 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1275,7 +1275,7 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
 	if ((c->flash_size % c->sector_size) != 0) {
 		c->flash_size = (c->flash_size / c->sector_size) * c->sector_size;
 		pr_warn("flash size adjusted to %dKiB\n", c->flash_size);
-	};
+	}
 
 	c->wbuf_ofs = 0xFFFFFFFF;
 	c->wbuf = kmalloc(c->wbuf_pagesize, GFP_KERNEL);

