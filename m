Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2BKMfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:35:36 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:46766
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754896Ab2BKMff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:35:35 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: standby24x7@gmail.com
Subject: [PATCH] [trivial] cramfs: Fix typo in inode.c
Date: Sat, 11 Feb 2012 21:35:12 +0900
Message-Id: <1328963712-2220-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "endianess" to "endianness" in
fs/cramfs/inode.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 fs/cramfs/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index a2ee8f9..04d51f9 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -257,10 +257,10 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Do sanity checks on the superblock */
 	if (super.magic != CRAMFS_MAGIC) {
-		/* check for wrong endianess */
+		/* check for wrong endianness */
 		if (super.magic == CRAMFS_MAGIC_WEND) {
 			if (!silent)
-				printk(KERN_ERR "cramfs: wrong endianess\n");
+				printk(KERN_ERR "cramfs: wrong endianness\n");
 			goto out;
 		}
 
@@ -270,7 +270,7 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
-				printk(KERN_ERR "cramfs: wrong endianess\n");
+				printk(KERN_ERR "cramfs: wrong endianness\n");
 			else if (!silent)
 				printk(KERN_ERR "cramfs: wrong magic\n");
 			goto out;
-- 
1.7.6.5

