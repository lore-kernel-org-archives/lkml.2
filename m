Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2HXLvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:51:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61432 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2HXLvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:51:49 -0400
From: yan <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] fs/inode.c: fix legacy comment about inode lock
Date: Fri, 24 Aug 2012 19:51:36 +0800
Message-Id: <1345809097-854-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inode_lock has been changed to inode_hash_lock

Signed-off-by: yan <clouds.yan@gmail.com>
---
 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index ac8d904..a9be0a3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -778,7 +778,7 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
- * Called with the inode lock held.
+ * Called with the inode_hash_lock held.
  */
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
-- 
1.7.9.5

