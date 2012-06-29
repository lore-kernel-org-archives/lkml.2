Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2F2Dal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:30:41 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51307 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2F2D31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:29:27 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fs/namei: fix some typos
Date: Fri, 29 Jun 2012 11:29:18 +0800
Message-Id: <1340940558-9893-3-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340940558-9893-1-git-send-email-yan@linux.vnet.ibm.com>
References: <n>
 <1340940558-9893-1-git-send-email-yan@linux.vnet.ibm.com>
x-cbid: 12062903-9574-0000-0000-0000035A764D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/namei.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 05b9053..adf61b3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1080,7 +1080,7 @@ static struct dentry *lookup_dcache(struct qstr *name, struct dentry *dir,
 
 /*
  * Call i_op->lookup on the dentry.  The dentry must be negative but may be
- * hashed if it was pouplated with DCACHE_NEED_LOOKUP.
+ * hashed if it was populated with DCACHE_NEED_LOOKUP.
  *
  * dir->d_inode->i_mutex must be held
  */
@@ -1737,7 +1737,7 @@ static inline int lookup_last(struct nameidata *nd, struct path *path)
 					nd->flags & LOOKUP_FOLLOW);
 }
 
-/* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
+/* Returns 0 and nd will be valid on success; Returns error, otherwise. */
 static int path_lookupat(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
@@ -2002,7 +2002,7 @@ static inline int check_sticky(struct inode *dir, struct inode *inode)
  *	a. be owner of dir, or
  *	b. be owner of victim, or
  *	c. have CAP_FOWNER capability
- *  6. If the victim is append-only or immutable we can't do antyhing with
+ *  6. If the victim is append-only or immutable we can't do anything with
  *     links pointing to it.
  *  7. If we were asked to remove a directory and victim isn't one - ENOTDIR.
  *  8. If we were asked to remove a non-directory and victim isn't one - EISDIR.
@@ -3018,7 +3018,7 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
  * dentry, and if that is true (possibly after pruning the dcache),
  * then we drop the dentry now.
  *
- * A low-level filesystem can, if it choses, legally
+ * A low-level filesystem can, if it chooses, legally
  * do a
  *
  *	if (!d_unhashed(dentry))
@@ -3366,7 +3366,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH
 	 * This ensures that not everyone will be able to create
-	 * handlink using the passed filedescriptor.
+	 * hardlink using the passed filedescriptor.
 	 */
 	if (flags & AT_EMPTY_PATH) {
 		if (!capable(CAP_DAC_READ_SEARCH))
-- 
1.7.9.5

