Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab2FIDLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 23:11:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52840 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2FIDLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 23:11:13 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] Fix some comments error in writeback subsystem
Date: Sat,  9 Jun 2012 11:10:55 +0800
Message-Id: <1339211455-9228-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 fs/fs-writeback.c |    4 ++--
 fs/super.c        |    2 +-
 fs/sync.c         |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8d2fb8c..d462fe7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -628,8 +628,8 @@ static long writeback_sb_inodes(struct super_block *sb,
 		}
 
 		/*
-		 * Don't bother with new inodes or inodes beeing freed, first
-		 * kind does not need peridic writeout yet, and for the latter
+		 * Don't bother with new inodes or inodes being freed, first
+		 * kind does not need periodic writeout yet, and for the latter
 		 * kind writeout is handled by the freer.
 		 */
 		spin_lock(&inode->i_lock);
diff --git a/fs/super.c b/fs/super.c
index cf00177..3d65443 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -318,7 +318,7 @@ static int grab_super(struct super_block *s) __releases(sb_lock)
 
 /*
  *	grab_super_passive - acquire a passive reference
- *	@s: reference we are trying to grab
+ *	@sb: reference we are trying to grab
  *
  *	Tries to acquire a passive reference. This is used in places where we
  *	cannot take an active reference but we need to ensure that the
diff --git a/fs/sync.c b/fs/sync.c
index 11e3d1c..1830704 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -92,7 +92,7 @@ static void sync_filesystems(int wait)
 }
 
 /*
- * sync everything.  Start out by waking pdflush, because that writes back
+ * sync everything.  Start out by waking flusher, because that writes back
  * all queues in parallel.
  */
 SYSCALL_DEFINE0(sync)
-- 
1.7.9.5

