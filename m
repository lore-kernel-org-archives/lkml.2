Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2IEIly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:41:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2IEIlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:41:52 -0400
From: ycnian@gmail.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, trivial@kernel.org
Cc: Yanchuan Nian <ycnian@gmail.com>
Subject: [PATCH][trivial]vfs: Fix a typo in fs/libfs.c
Date: Wed,  5 Sep 2012 16:31:29 +0800
Message-Id: <1346833889-3385-1-git-send-email-ycnian@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanchuan Nian <ycnian@gmail.com>

Just a typo in the description of function generic_fh_to_parent. Please apply.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 fs/libfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index a74cb17..7cc37ca 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -874,7 +874,7 @@ struct dentry *generic_fh_to_dentry(struct super_block *sb, struct fid *fid,
 EXPORT_SYMBOL_GPL(generic_fh_to_dentry);
 
 /**
- * generic_fh_to_dentry - generic helper for the fh_to_parent export operation
+ * generic_fh_to_parent - generic helper for the fh_to_parent export operation
  * @sb:		filesystem to do the file handle conversion on
  * @fid:	file handle to convert
  * @fh_len:	length of the file handle in bytes
-- 
1.7.4.4

