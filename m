Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab1CXT3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:29:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60296 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023Ab1CXT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HRUTzOyXMCKZPoldeU2aZOrkMh2BxPhgJUnQh1m5l2Db8IUtuteBSYOYp7D155mlIQ
         uEnC/C8aWcdtdhoqt2J78y8mvBJf/TusdfKs+WIMqhE8E8VgoAunqLPaAzbkqk789JMs
         nHOKEmeIX+qqLWIFiPrxsCiXBZyUbbdaX8jpo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 16/21]fs:logfs Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:54 -0700
Message-Id: <1300994819-30930-16-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/logfs/readwrite.c    |    2 +-
 fs/ocfs2/refcounttree.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index ee99a9f..3dcb3a6 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -481,7 +481,7 @@ static int inode_write_alias(struct super_block *sb,
 			val = inode_val0(inode);
 			break;
 		case INODE_USED_OFS:
-			val = cpu_to_be64(li->li_used_bytes);;
+			val = cpu_to_be64(li->li_used_bytes);
 			break;
 		case INODE_SIZE_OFS:
 			val = cpu_to_be64(i_size_read(inode));
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index c384d63..c4feced 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3707,7 +3707,7 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
 	context->cow_start = cow_start;
 	context->cow_len = cow_len;
 	context->ref_tree = ref_tree;
-	context->ref_root_bh = ref_root_bh;;
+	context->ref_root_bh = ref_root_bh;
 	context->cow_object = xv;
 
 	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_jbd;
-- 
1.7.4.1

