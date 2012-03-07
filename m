Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2CGINt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:13:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54391 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2CGINs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:13:48 -0500
Message-ID: <4F5718AC.80705@gmail.com>
Date: Wed, 07 Mar 2012 16:13:32 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/locking.c: minor fix on the comment for btrfs_try_tree_write_lock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btrfs_try_tree_write_lock is used for write lock, not for read lock.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/locking.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 5e178d8..4e4705c 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -142,7 +142,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 }
 
 /*
- * returns 1 if we get the read lock and 0 if we don't
+ * returns 1 if we get the write lock and 0 if we don't
  * this won't wait for blocking writers or readers
  */
 int btrfs_try_tree_write_lock(struct extent_buffer *eb)
-- 
1.7.1

