Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0IYSe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:34:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54221 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab0IYSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KXHENuEYnRG7KnN6iJA4F+g6Wtec+vy9Sbw9hNPfbUzrSnUYSE6+x5aiI40E7twvPs
         pBn4PuAax+PM/dG4Uor4B0R998OhUl86BzMuhB7Du5AOJZASfvOUcc8VXAC6GsMi3RSX
         ML17YMwZS/qkFhgp6ol1yDoN6NLNTNAXsDOLM=
From: Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 03/10] Fs: ext: balloc: fixed a few issues that checkpatch.pl was having
Date: Sat, 25 Sep 2010 14:31:54 -0400
Message-Id: <1285439521-2557-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tracey Dent <Tdent48227@gmail.com>

Fixed space after a variable with help of checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/balloc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index bd30799..ca3a161 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -390,9 +390,9 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	 * Check to see if we are freeing blocks across a group
 	 * boundary.
 	 */
-	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) {
+	if (bit + count > EXT4_BLOCKS_PER_GROUP(sb)) 
 		goto error_return;
-	}
+
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
 	if (!bitmap_bh)
 		goto error_return;
@@ -710,7 +710,7 @@ static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
 	if (!ext4_bg_has_super(sb, group))
 		return 0;
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG))
 		return le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
 	else
 		return EXT4_SB(sb)->s_gdb_count;
@@ -731,11 +731,11 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_group_t group)
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
 	unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);
 
-	if (!EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG) ||
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
 			metagroup < first_meta_bg)
 		return ext4_bg_num_gdb_nometa(sb, group);
 
-	return ext4_bg_num_gdb_meta(sb,group);
+	return ext4_bg_num_gdb_meta(sb, group);
 
 }
 
-- 
1.7.3

