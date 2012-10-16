Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2JPTOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:14:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2JPTOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:14:31 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 10/10] ext4: resize: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:05 +0530
Message-Id: <1350414785-7848-10-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch.pl reported issues

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/resize.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/resize.c b/linux-3.7-rc1/fs/ext4/resize.c
index 7a75e10..c00bb81 100644
--- a/linux-3.7-rc1/fs/ext4/resize.c
+++ b/linux-3.7-rc1/fs/ext4/resize.c
@@ -691,7 +691,7 @@ static int verify_reserved_gdb(struct super_block *sb,
 
 	while ((grp = ext4_list_backups(sb, &three, &five, &seven)) < end) {
 		if (le32_to_cpu(*p++) !=
-		    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
+		    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk) {
 			ext4_warning(sb, "reserved GDT %llu"
 				     " missing grp %d (%llu)",
 				     blk, grp,
@@ -917,7 +917,7 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 			      ext4_group_t group)
 {
 	struct super_block *sb = inode->i_sb;
-	int reserved_gdb =le16_to_cpu(EXT4_SB(sb)->s_es->s_reserved_gdt_blocks);
+	int reserved_gdb = le16_to_cpu(EXT4_SB(sb)->s_es->s_reserved_gdt_blocks);
 	struct buffer_head **primary;
 	struct buffer_head *dind;
 	struct ext4_iloc iloc;
@@ -1232,7 +1232,7 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 	ext4_group_t			group;
 	__u16				*bg_flags = flex_gd->bg_flags;
 	int				i, gdb_off, gdb_num, err = 0;
-	
+
 
 	for (i = 0; i < flex_gd->count; i++, group_data++, bg_flags++) {
 		group = group_data->group;
-- 
1.7.7.3

