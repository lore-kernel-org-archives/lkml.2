Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab1FQHXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 03:23:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55415 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab1FQHXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 03:23:21 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] security: inode: fixed coding style issue
Date: Fri, 17 Jun 2011 19:22:21 +1200
Message-Id: <1308295341-27566-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a few coding style issues.

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 security/inode.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index c4df2fb..961f280 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -75,7 +75,8 @@ static struct inode *get_inode(struct super_block *sb, int mode, dev_t dev)
 			inode->i_op = &simple_dir_inode_operations;
 			inode->i_fop = &simple_dir_operations;
 
-			/* directory inodes start off with i_nlink == 2 (for "." entry) */
+			/* directory inodes start off with i_nlink == 2
+			 * (for "." entry) */
 			inc_nlink(inode);
 			break;
 		}
@@ -126,7 +127,7 @@ static inline int positive(struct dentry *dentry)
 
 static int fill_super(struct super_block *sb, void *data, int silent)
 {
-	static struct tree_descr files[] = {{""}};
+	static struct tree_descr files[] = { {""} };
 
 	return simple_fill_super(sb, SECURITYFS_MAGIC, files);
 }
@@ -212,7 +213,7 @@ struct dentry *securityfs_create_file(const char *name, mode_t mode,
 	struct dentry *dentry = NULL;
 	int error;
 
-	pr_debug("securityfs: creating file '%s'\n",name);
+	pr_debug("securityfs: creating file '%s'\n", name);
 
 	error = simple_pin_fs(&fs_type, &mount, &mount_count);
 	if (error) {
-- 
1.7.4.1

