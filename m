Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab2J2PST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:18:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab2J2PSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:18:15 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] md: Fix typo in drivers/md
Date: Tue, 30 Oct 2012 00:18:08 +0900
Message-Id: <1351523888-16579-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in drivers/md.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/md/md.c                               | 2 +-
 drivers/md/persistent-data/dm-block-manager.c | 4 ++--
 drivers/md/persistent-data/dm-btree.h         | 2 +-
 drivers/md/raid5.c                            | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 12293a0..c131744 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4124,7 +4124,7 @@ static struct md_sysfs_entry md_size =
 __ATTR(component_size, S_IRUGO|S_IWUSR, size_show, size_store);
 
 
-/* Metdata version.
+/* Metadata version.
  * This is one of
  *   'none' for arrays with no metadata (good luck...)
  *   'external' for arrays with externally managed metadata,
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 5ba2777..a3ae091 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -25,7 +25,7 @@
  * may be held at once.  This is just an implementation detail.
  *
  * ii) Recursive locking attempts are detected and return EINVAL.  A stack
- * trace is also emitted for the previous lock aquisition.
+ * trace is also emitted for the previous lock acquisition.
  *
  * iii) Priority is given to write locks.
  */
@@ -109,7 +109,7 @@ static int __check_holder(struct block_lock *lock)
 			DMERR("previously held here:");
 			print_stack_trace(lock->traces + i, 4);
 
-			DMERR("subsequent aquisition attempted here:");
+			DMERR("subsequent acquisition attempted here:");
 			t.nr_entries = 0;
 			t.max_entries = MAX_STACK;
 			t.entries = entries;
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
index ae02c84..a2cd5044 100644
--- a/drivers/md/persistent-data/dm-btree.h
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -35,7 +35,7 @@ struct dm_transaction_manager;
  */
 
 /*
- * Infomation about the values stored within the btree.
+ * Information about the values stored within the btree.
  */
 struct dm_btree_value_type {
 	void *context;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8f2a2ff..320df0c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1612,7 +1612,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	 * This happens in stages:
 	 * 1/ create a new kmem_cache and allocate the required number of
 	 *    stripe_heads.
-	 * 2/ gather all the old stripe_heads and tranfer the pages across
+	 * 2/ gather all the old stripe_heads and transfer the pages across
 	 *    to the new stripe_heads.  This will have the side effect of
 	 *    freezing the array as once all stripe_heads have been collected,
 	 *    no IO will be possible.  Old stripe heads are freed once their
-- 
1.8.0.rc3.16.g8ead1bf

