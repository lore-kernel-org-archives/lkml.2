Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1AVGbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 01:31:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1AVGbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 01:31:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UDK/JCm/I55TuqqWyl7Lt2FhaMmGBCMF9TY30vBBOlq3vCafOdHBXgUlcwl82PvPH6
         hhsKIhcYysC+kOejNR1K/oL1p8NDa4UwAXdMaVg+T7w/Q3deXHysEC8AWsS/+SCjkKPj
         8NJkxs3hhcaBmd6jXdio7/jrgojfGmbuSqMz4=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: update comments to point correct document
Date: Sat, 22 Jan 2011 15:31:32 +0900
Message-Id: <1295677892-3767-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache-locking.txt is not exist any more, and the path was not
correct anyway. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/dcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9f493ee4dcba..56be05ef4fe3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1779,7 +1779,7 @@ struct dentry *__d_lookup_rcu(struct dentry *parent, struct qstr *name,
 	 * false-negative result. d_lookup() protects against concurrent
 	 * renames using rename_lock seqlock.
 	 *
-	 * See Documentation/vfs/dcache-locking.txt for more details.
+	 * See Documentation/filesystems/path-lookup.txt for more details.
 	 */
 	hlist_bl_for_each_entry_rcu(dentry, node, &b->head, d_hash) {
 		struct inode *i;
@@ -1899,7 +1899,7 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 	 * false-negative result. d_lookup() protects against concurrent
 	 * renames using rename_lock seqlock.
 	 *
-	 * See Documentation/vfs/dcache-locking.txt for more details.
+	 * See Documentation/filesystems/path-lookup.txt for more details.
 	 */
 	rcu_read_lock();
 	
-- 
1.7.3.4.600.g982838b0

