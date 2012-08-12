Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab2HLJpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:45:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2HLJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:45:16 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 5/7] fs/fat: Fixes some small checkpatch issues in dir.c
Date: Sun, 12 Aug 2012 19:44:45 +1000
Message-Id: <1344764687-4155-6-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit simply removes the spacing between function
definitions and EXPORT_SYMBOL_GPL calls, which were
previously generating warnings.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 fs/fat/dir.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 7b1b9c1..4b04d5e 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -537,7 +537,6 @@ end_of_dir:
 
 	return err;
 }
-
 EXPORT_SYMBOL_GPL(fat_search_long);
 
 struct fat_ioctl_filldir_callback {
@@ -892,7 +891,6 @@ int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 	}
 	return -ENOENT;
 }
-
 EXPORT_SYMBOL_GPL(fat_get_dotdot_entry);
 
 /* See if directory is empty */
@@ -915,7 +913,6 @@ int fat_dir_empty(struct inode *dir)
 	brelse(bh);
 	return result;
 }
-
 EXPORT_SYMBOL_GPL(fat_dir_empty);
 
 /*
@@ -961,7 +958,6 @@ int fat_scan(struct inode *dir, const unsigned char *name,
 	}
 	return -ENOENT;
 }
-
 EXPORT_SYMBOL_GPL(fat_scan);
 
 static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
@@ -1049,7 +1045,6 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(fat_remove_entries);
 
 static int fat_zeroed_cluster(struct inode *dir, sector_t blknr, int nr_used,
@@ -1163,7 +1158,6 @@ error_free:
 error:
 	return err;
 }
-
 EXPORT_SYMBOL_GPL(fat_alloc_new_dir);
 
 static int fat_add_new_entries(struct inode *dir, void *slots, int nr_slots,
@@ -1379,5 +1373,4 @@ error_remove:
 		__fat_remove_entries(dir, pos, free_slots);
 	return err;
 }
-
 EXPORT_SYMBOL_GPL(fat_add_entries);
-- 
1.7.9.5

