Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0H3RnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:43:19 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45517 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab0H3RnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:43:18 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: Don't use dotl version of mknod for dotu inode operations
Date: Mon, 30 Aug 2010 23:13:07 +0530
Message-Id: <1283190187-27236-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not use dotlversion for the dotu inode operations

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b23b6a5..82013be 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1942,7 +1942,7 @@ static const struct inode_operations v9fs_dir_inode_operations_dotu = {
 	.unlink = v9fs_vfs_unlink,
 	.mkdir = v9fs_vfs_mkdir,
 	.rmdir = v9fs_vfs_rmdir,
-	.mknod = v9fs_vfs_mknod_dotl,
+	.mknod = v9fs_vfs_mknod,
 	.rename = v9fs_vfs_rename,
 	.getattr = v9fs_vfs_getattr,
 	.setattr = v9fs_vfs_setattr,
-- 
1.7.0.4

