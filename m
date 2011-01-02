Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab1ABHVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:34043 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1ABHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Curt Wohlgemuth <curtw@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 016/260] ext4: Remove extraneous newlines in ext4_msg() calls
Date: Sun,  2 Jan 2011 02:15:12 -0500
Message-Id: <1293952756-15010-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:24.0006 (UTC) FILETIME=[858DD660:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Curt Wohlgemuth <curtw@google.com>

commit fbe845ddf368f77f86aa7500f8fd2690f54c66a8 upstream.

Addresses-Google-Bug: #2562325

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/inode.c |    6 +++---
 fs/ext4/super.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 89a31e8..3c479ef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2283,7 +2283,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 		ext4_msg(mpd->inode->i_sb, KERN_CRIT,
 			 "delayed block allocation failed for inode %lu at "
 			 "logical offset %llu with max blocks %zd with "
-			 "error %d\n", mpd->inode->i_ino,
+			 "error %d", mpd->inode->i_ino,
 			 (unsigned long long) next,
 			 mpd->b_size >> mpd->inode->i_blkbits, err);
 		printk(KERN_CRIT "This should not happen!!  "
@@ -2951,7 +2951,7 @@ retry:
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
-			       "%ld pages, ino %lu; err %d\n", __func__,
+			       "%ld pages, ino %lu; err %d", __func__,
 				wbc->nr_to_write, inode->i_ino, ret);
 			goto out_writepages;
 		}
@@ -3026,7 +3026,7 @@ retry:
 	if (pages_skipped != wbc->pages_skipped)
 		ext4_msg(inode->i_sb, KERN_CRIT,
 			 "This should not happen leaving %s "
-			 "with nr_to_write = %ld ret = %d\n",
+			 "with nr_to_write = %ld ret = %d",
 			 __func__, wbc->nr_to_write, ret);
 
 	/* Update index */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d83cdcb..f9e57e1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2998,7 +2998,7 @@ no_journal:
 	err = ext4_setup_system_zone(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize system "
-			 "zone (%d)\n", err);
+			 "zone (%d)", err);
 		goto failed_mount4;
 	}
 
-- 
1.7.3.3

