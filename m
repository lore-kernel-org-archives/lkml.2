Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1GYO06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:26:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43705 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1GYO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:26:55 -0400
From: ruslanpisarev@gmail.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH] Staging: pohmelfs: Coding style fixes in trans.c
Date: Mon, 25 Jul 2011 17:26:47 +0300
Message-Id: <1311604007-5131-1-git-send-email-ruslan@rpisarev.org.ua>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ruslan Pisarev <ruslan@rpisarev.org.ua>

I fixed whitespace in drivers/staging/pohmelfs/trans.c

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/pohmelfs/trans.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/pohmelfs/trans.c b/drivers/staging/pohmelfs/trans.c
index 36a2535..06c1a74 100644
--- a/drivers/staging/pohmelfs/trans.c
+++ b/drivers/staging/pohmelfs/trans.c
@@ -50,7 +50,7 @@ static int netfs_trans_send_pages(struct netfs_trans *t, struct netfs_state *st)
 	int err = 0;
 	unsigned int i, attached_pages = t->attached_pages, ci;
 	struct msghdr msg;
-	struct page **pages = (t->eng)?t->eng->pages:t->pages;
+	struct page **pages = (t->eng) ? t->eng->pages : t->pages;
 	struct page *p;
 	unsigned int size;
 
@@ -61,7 +61,7 @@ static int netfs_trans_send_pages(struct netfs_trans *t, struct netfs_state *st)
 	msg.msg_flags = MSG_WAITALL | MSG_MORE;
 
 	ci = 0;
-	for (i=0; i<t->page_num; ++i) {
+	for (i = 0; i < t->page_num; ++i) {
 		struct page *page = pages[ci];
 		struct netfs_cmd cmd;
 		struct iovec io;
@@ -169,7 +169,7 @@ int netfs_trans_send(struct netfs_trans *t, struct netfs_state *st)
 	}
 
 	dprintk("%s: sent %s transaction: t: %p, gen: %u, size: %zu, page_num: %u.\n",
-			__func__, (t->page_num)?"partial":"full",
+			__func__, (t->page_num) ? "partial" : "full",
 			t, t->gen, t->iovec.iov_len, t->page_num);
 
 	err = 0;
-- 
1.7.4.1

