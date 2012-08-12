Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2HLJpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:45:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2HLJpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:45:08 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 2/7] fs/fat: Fix some checkpatch issues in fat.h
Date: Sun, 12 Aug 2012 19:44:42 +1000
Message-Id: <1344764687-4155-3-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly fixed spacing issues such as "foo * bar" and "foo= bar"

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 fs/fat/fat.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 88b6c29..2ef82cf 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -61,7 +61,7 @@ struct msdos_sb_info {
 	unsigned short sec_per_clus; /* sectors/cluster */
 	unsigned short cluster_bits; /* log2(cluster_size) */
 	unsigned int cluster_size;   /* cluster size */
-	unsigned char fats,fat_bits; /* number of FATs, FAT bits (12 or 16) */
+	unsigned char fats, fat_bits; /* number of FATs, FAT bits (12 or 16) */
 	unsigned short fat_start;
 	unsigned long fat_length;    /* FAT start & length (sec.) */
 	unsigned long dir_start;
@@ -328,7 +328,7 @@ extern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
 			      unsigned long arg);
 extern const struct file_operations fat_file_operations;
 extern const struct inode_operations fat_file_inode_operations;
-extern int fat_setattr(struct dentry * dentry, struct iattr * attr);
+extern int fat_setattr(struct dentry *dentry, struct iattr *attr);
 extern void fat_truncate_blocks(struct inode *inode, loff_t offset);
 extern int fat_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
@@ -346,7 +346,7 @@ extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 			  int isvfat, void (*setup)(struct super_block *));
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
-		            struct inode *i2);
+			    struct inode *i2);
 static inline unsigned long fat_dir_hash(int logstart)
 {
 	return hash_32(logstart, FAT_HASH_BITS);
-- 
1.7.9.5

