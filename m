Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2D1MON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 08:14:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34320 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2D1MOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 08:14:10 -0400
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH] cifs: Fix comment as d_alloc_root() is replaced by d_make_root()
Date: Sat, 28 Apr 2012 14:13:53 +0200
Message-Id: <1335615233-17746-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For more details see <file: Documentation/filesystems/porting>.

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/cifs/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d342128..62843d9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -125,7 +125,7 @@ cifs_read_super(struct super_block *sb)
 		goto out_no_root;
 	}
 
-	/* do that *after* d_alloc_root() - we want NULL ->d_op for root here */
+	/* do that *after* d_make_root() - we want NULL ->d_op for root here */
 	if (cifs_sb_master_tcon(cifs_sb)->nocase)
 		sb->s_d_op = &cifs_ci_dentry_ops;
 	else
-- 
1.7.9.5

