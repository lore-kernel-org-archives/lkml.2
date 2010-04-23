Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0DWAhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 20:37:24 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:33461 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0DWAhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 20:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HxQCNqUE0GTdupOmosmAqDEzbDutbLyst1v90YV7g7Wuk6ahvqfMK+spJRVfKKb86a
         M32qBYhpi4IwZxy2uGkstFvdSg/45qtxOSIDPAN2Exp9moUw5rZhPOUy13Fzukp4jEa+
         OdhDe7Qgd6llYFdXcFocKAdexZs1eknPC2Y7U=
From: Chihau Chau <chihau@gmail.com>
To: jmorris@namei.org
Cc: eparis@redhat.com, viro@zeniv.linux.org.uk,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Security: inode: Fix code style issues
Date: Thu, 22 Apr 2010 20:37:15 -0400
Message-Id: <1271983035-26401-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes two code style issues:

- A space required after that close brace '}'

- A space required after that ','

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 security/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index c3a7938..f875f47 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -124,7 +124,7 @@ static inline int positive(struct dentry *dentry)
 
 static int fill_super(struct super_block *sb, void *data, int silent)
 {
-	static struct tree_descr files[] = {{""}};
+	static struct tree_descr files[] = { {""} };
 
 	return simple_fill_super(sb, SECURITYFS_MAGIC, files);
 }
@@ -208,7 +208,7 @@ struct dentry *securityfs_create_file(const char *name, mode_t mode,
 	struct dentry *dentry = NULL;
 	int error;
 
-	pr_debug("securityfs: creating file '%s'\n",name);
+	pr_debug("securityfs: creating file '%s'\n", name);
 
 	error = simple_pin_fs(&fs_type, &mount, &mount_count);
 	if (error) {
-- 
1.5.6.3

