Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1KXMrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:47:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52944 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1KXMrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:47:20 -0500
MIME-Version: 1.0
From: Rahul Bedarkar <rpal143@gmail.com>
Date: Thu, 24 Nov 2011 18:16:59 +0530
Message-ID: <CA+NV+Vn2jq3r3VsS1pL_XEQPF5=ph3FAx2_wDGdLnCvZDFXUFQ@mail.gmail.com>
Subject: [PATCH]: Added comments in fat.h
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    Added comments in fat.h

    signed off by <rpal143@gmail.com>

[master b5334fc] Added comments in fat.h
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 1510a4d..3b64fe0 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -75,7 +75,7 @@ struct msdos_sb_info {
        struct fat_mount_options options;
        struct nls_table *nls_disk;  /* Codepage used on disk */
        struct nls_table *nls_io;    /* Charset used for input and display */
-       const void *dir_ops;                 /* Opaque; default
directory operations */
+       const void *dir_ops;         /* Opaque; default directory operations */
        int dir_per_block;           /* dir entries per block */
        int dir_per_block_bits;      /* log2(dir_per_block) */

@@ -179,6 +179,7 @@ static inline u8 fat_make_attrs(struct inode *inode)
        return attrs;
 }

+/* Sets the FAT attribute byte for thid inode */
 static inline void fat_save_attrs(struct inode *inode, u8 attrs)
 {
        if (fat_mode_can_hold_ro(inode))


Regards,
Rahul Bedarkar
