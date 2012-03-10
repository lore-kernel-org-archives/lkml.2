Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab2CJDoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:44:13 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:61689 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228Ab2CJDoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:44:09 -0500
Date: Sat, 10 Mar 2012 02:51:59 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/6] Squashfs: remove redundant length initialisation in
 squashfs_readdir
Message-ID: <4f5ac1cf.K/inlZTZuzcOGj8k%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index 9dfe2ce..bbd3864 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -105,7 +105,7 @@ static int squashfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 	struct inode *inode = file->f_dentry->d_inode;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	u64 block = squashfs_i(inode)->start + msblk->directory_table;
-	int offset = squashfs_i(inode)->offset, length = 0, dir_count, size,
+	int offset = squashfs_i(inode)->offset, length, dir_count, size,
 				type, err;
 	unsigned int inode_number;
 	struct squashfs_dir_header dirh;
-- 
1.7.5.4

