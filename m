Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1GPQLZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 12:11:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45991 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1GPQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 12:11:25 -0400
Date: Sat, 16 Jul 2011 18:10:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>,
        David Woodhouse <dwmw2@infradead.org>, Alex Elder <aelder@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs: Merge split strings
Message-ID: <20110716181035.7db8d8f0@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No idea why these were split in the first place...

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 fs/ecryptfs/keystore.c |    2 +-
 fs/jffs2/readinode.c   |    2 +-
 fs/xfs/xfs_dir2_node.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-3.0-rc5.orig/fs/ecryptfs/keystore.c	2011-05-30 20:45:21.000000000 +0200
+++ linux-3.0-rc5/fs/ecryptfs/keystore.c	2011-07-04 13:16:53.000000000 +0200
@@ -2248,7 +2248,7 @@ write_tag_3_packet(char *dest, size_t *r
 		       auth_tok->token.password.session_key_encryption_key,
 		       crypt_stat->key_size);
 		ecryptfs_printk(KERN_DEBUG,
-				"Cached session key " "encryption key: \n");
+				"Cached session key encryption key:\n");
 		if (ecryptfs_verbosity > 0)
 			ecryptfs_dump_hex(session_key_encryption_key, 16);
 	}
--- linux-3.0-rc5.orig/fs/jffs2/readinode.c	2011-05-20 10:42:43.000000000 +0200
+++ linux-3.0-rc5/fs/jffs2/readinode.c	2011-07-04 13:19:26.000000000 +0200
@@ -1041,7 +1041,7 @@ static int jffs2_get_inode_nodes(struct
 		/* FIXME: point() */
 		err = jffs2_flash_read(c, ref_offset(ref), len, &retlen, buf);
 		if (err) {
-			JFFS2_ERROR("can not read %d bytes from 0x%08x, " "error code: %d.\n", len, ref_offset(ref), err);
+			JFFS2_ERROR("can not read %d bytes from 0x%08x, error code: %d.\n", len, ref_offset(ref), err);
 			goto free_out;
 		}
 
--- linux-3.0-rc5.orig/fs/xfs/xfs_dir2_node.c	2011-05-20 10:42:44.000000000 +0200
+++ linux-3.0-rc5/fs/xfs/xfs_dir2_node.c	2011-07-04 13:19:58.000000000 +0200
@@ -1641,7 +1641,7 @@ xfs_dir2_node_addname_int(
 
 			if (unlikely(xfs_dir2_db_to_fdb(mp, dbno) != fbno)) {
 				xfs_alert(mp,
-			"%s: dir ino " "%llu needed freesp block %lld for\n"
+			"%s: dir ino %llu needed freesp block %lld for\n"
 			"  data block %lld, got %lld ifbno %llu lastfbno %d",
 					__func__, (unsigned long long)dp->i_ino,
 					(long long)xfs_dir2_db_to_fdb(mp, dbno),


-- 
Jean Delvare
