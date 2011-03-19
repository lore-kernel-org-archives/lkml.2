Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab1CSPvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:51:16 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:58699 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754778Ab1CSPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:51:10 -0400
Date: Sat, 19 Mar 2011 16:47:54 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: fix whitespace coding style issues
Message-ID: <20110319164754.11e7bb9b@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes whitespace coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 fs/nilfs2/nilfs.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 856e8e4..a8dd344 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -114,19 +114,19 @@ enum {
  * Macros to check inode numbers
  */
 #define NILFS_MDT_INO_BITS   \
-  ((unsigned int)(1 << NILFS_DAT_INO | 1 << NILFS_CPFILE_INO |		\
-		  1 << NILFS_SUFILE_INO | 1 << NILFS_IFILE_INO |	\
-		  1 << NILFS_ATIME_INO | 1 << NILFS_SKETCH_INO))
+	((unsigned int)(1 << NILFS_DAT_INO | 1 << NILFS_CPFILE_INO |	\
+			1 << NILFS_SUFILE_INO | 1 << NILFS_IFILE_INO |	\
+			1 << NILFS_ATIME_INO | 1 << NILFS_SKETCH_INO))
 
 #define NILFS_SYS_INO_BITS   \
-  ((unsigned int)(1 << NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
+	((unsigned int)(1 << NILFS_ROOT_INO) | NILFS_MDT_INO_BITS)
 
 #define NILFS_FIRST_INO(sb) (((struct the_nilfs *)sb->s_fs_info)->ns_first_ino)
 
 #define NILFS_MDT_INODE(sb, ino) \
-  ((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & (1 << (ino))))
+	((ino) < NILFS_FIRST_INO(sb) && (NILFS_MDT_INO_BITS & (1 << (ino))))
 #define NILFS_VALID_INODE(sb, ino) \
-  ((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & (1 << (ino))))
+	((ino) >= NILFS_FIRST_INO(sb) || (NILFS_SYS_INO_BITS & (1 << (ino))))
 
 /**
  * struct nilfs_transaction_info: context information for synchronization
@@ -285,7 +285,7 @@ extern void nilfs_destroy_inode(struct inode *);
 extern void nilfs_error(struct super_block *, const char *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern void nilfs_warning(struct super_block *, const char *, const char *, ...)
-       __attribute__ ((format (printf, 3, 4)));
+	__attribute__ ((format (printf, 3, 4)));
 extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
-- 
1.7.3.4
