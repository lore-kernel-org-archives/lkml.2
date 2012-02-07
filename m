Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2BGNWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:22:18 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:36690
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756280Ab2BGNWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:22:17 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] btrfs: Fix typo in free-space-cache.c
Date: Tue,  7 Feb 2012 22:21:45 +0900
Message-Id: <1328620905-1713-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "cace" to "cache" in
fs/btrfs/free-space-cache.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c2f2059..7f4f302 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1067,7 +1067,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		spin_unlock(&block_group->lock);
 		ret = 0;
 #ifdef DEBUG
-		printk(KERN_ERR "btrfs: failed to write free space cace "
+		printk(KERN_ERR "btrfs: failed to write free space cache "
 		       "for block group %llu\n", block_group->key.objectid);
 #endif
 	}
-- 
1.7.6.5

