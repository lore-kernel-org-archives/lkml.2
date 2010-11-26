Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0KZQfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:35:52 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41693 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KZQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:35:51 -0500
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] fs/fs-writeback.c: Fix sync_inodes_sb() return value kernel-doc
Date: Fri, 26 Nov 2010 16:35:10 +0000
Message-Id: <1290789310-2626-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sync_inodes_sb() function does not have a return value.  Remove the
outdated documentation comment.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 fs/fs-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3d06ccc..13a6b69 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1164,7 +1164,7 @@ EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
  * @sb: the superblock
  *
  * This function writes and waits on any dirty inode belonging to this
- * super_block. The number of pages synced is returned.
+ * super_block.
  */
 void sync_inodes_sb(struct super_block *sb)
 {
-- 
1.7.2.3

