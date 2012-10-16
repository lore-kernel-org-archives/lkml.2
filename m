Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab2JPTN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:13:56 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59494 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2JPTNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:13:53 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 05/10] ext4: file: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:00 +0530
Message-Id: <1350414785-7848-5-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed errors reported by checkpatch.pl

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/file.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/file.c b/linux-3.7-rc1/fs/ext4/file.c
index bf3966b..17068a7 100644
--- a/linux-3.7-rc1/fs/ext4/file.c
+++ b/linux-3.7-rc1/fs/ext4/file.c
@@ -43,8 +43,7 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1) &&
-		        !EXT4_I(inode)->i_reserved_data_blocks)
-	{
+			!EXT4_I(inode)->i_reserved_data_blocks) {
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
 		up_write(&EXT4_I(inode)->i_data_sem);
@@ -221,7 +220,7 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int ext4_file_open(struct inode * inode, struct file * filp)
+static int ext4_file_open(struct inode *inode, struct file *filp)
 {
 	struct super_block *sb = inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-- 
1.7.7.3

