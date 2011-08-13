Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1HMA2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:28:24 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61717 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab1HMA1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:52 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 10/10]include:linux Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:15 -0700
Message-Id: <1313195235-4522-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/jbd.h      |    2 +-
 include/linux/jbd2.h     |    2 +-
 include/linux/rcupdate.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index e6a5e34..7f3b109 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -273,7 +273,7 @@ typedef struct journal_superblock_s
 enum jbd_state_bits {
 	BH_JBD			/* Has an attached ext3 journal_head */
 	  = BH_PrivateStart,
-	BH_JWrite,		/* Being written to log (@@@ DEBUGGING) */
+	BH_JWrite,		/* Being written to log DEBUGGING */
 	BH_Freed,		/* Has been freed (truncated) */
 	BH_Revoked,		/* Has been revoked from the log */
 	BH_RevokeValid,		/* Revoked flag is valid */
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 38f307b..4a7ad4b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -305,7 +305,7 @@ typedef struct journal_superblock_s
 enum jbd_state_bits {
 	BH_JBD			/* Has an attached ext3 journal_head */
 	  = BH_PrivateStart,
-	BH_JWrite,		/* Being written to log (@@@ DEBUGGING) */
+	BH_JWrite,		/* Being written to log DEBUGGING */
 	BH_Freed,		/* Has been freed (truncated) */
 	BH_Revoked,		/* Has been revoked from the log */
 	BH_RevokeValid,		/* Revoked flag is valid */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8f4f881..cfb5d7b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -443,7 +443,7 @@ extern int rcu_my_thread_group_empty(void);
 	__rcu_dereference_check((p), rcu_read_lock_sched_held() || (c), \
 				__rcu)
 
-#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
+#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /* needed? */
 
 /**
  * rcu_access_index() - fetch RCU index with no dereferencing
-- 
1.7.6

