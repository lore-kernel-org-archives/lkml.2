Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab2GNDia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 23:38:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56609 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab2GNDi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 23:38:29 -0400
From: Chen Baozi <baozich@gmail.com>
To: bpm@sgi.com
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Chen Baozi <baozich@gmail.com>
Subject: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
Date: Sat, 14 Jul 2012 03:38:13 +0800
Message-Id: <1342208293-3405-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial typo error that has written "It" to "Is".

Signed-off-by: Chen Baozi <baozich@gmail.com>
---
 fs/xfs/xfs_da_btree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index dbf7c07..be30bd4 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -32,7 +32,7 @@ struct zone;
 /*
  * This structure is common to both leaf nodes and non-leaf nodes in the Btree.
  *
- * Is is used to manage a doubly linked list of all blocks at the same
+ * It is used to manage a doubly linked list of all blocks at the same
  * level in the Btree, and to identify which type of block this is.
  */
 #define XFS_DA_NODE_MAGIC	0xfebe	/* magic number: non-leaf blocks */
-- 
1.7.1

