Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2CNFoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 01:44:12 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56369 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2CNFoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 01:44:09 -0400
Message-ID: <4F60301B.8030601@gmail.com>
Date: Wed, 14 Mar 2012 13:43:55 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/ctree.h: trivial fixup the comment for struct btrfs_dev_extent
 with the right fields' names
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/ctree.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80b6486..a515e4e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -597,9 +597,9 @@ struct btrfs_extent_ref_v0 {
 } __attribute__ ((__packed__));
 
 
-/* dev extents record free space on individual devices.  The owner
+/* dev extents record free space on individual devices.  The chunk_tree
  * field points back to the chunk allocation mapping tree that allocated
- * the extent.  The chunk tree uuid field is a way to double check the owner
+ * the extent.  The chunk_tree_uuid field is a way to double check the owner
  */
 struct btrfs_dev_extent {
 	__le64 chunk_tree;
-- 
1.7.1

