Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2HLJp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:45:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2HLJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:45:05 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 1/7] fs/fat: Fix a checkpatch issue in namei_msdos.c
Date: Sun, 12 Aug 2012 19:44:41 +1000
Message-Id: <1344764687-4155-2-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a space before an equals sign/operator in line 410.

Yeah, I know. It's a lame commit, but at least it works!

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 fs/fat/namei_msdos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index c27c630..c1055e7 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -407,7 +407,7 @@ out:
 static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	struct super_block *sb= inode->i_sb;
+	struct super_block *sb = inode->i_sb;
 	struct fat_slot_info sinfo;
 	int err;
 
-- 
1.7.9.5

