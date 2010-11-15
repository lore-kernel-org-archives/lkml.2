Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab0KODI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:08:27 -0500
Received: from mail.perches.com ([173.55.12.10]:1239 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884Ab0KODF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:59 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH 36/44] fs/ocfs2: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:55 -0800
Message-Id: <e32409b17aaa1a54fec85f3654583ef08fcf851c.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/refcounttree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index b5f9160..da14a42 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3704,7 +3704,7 @@ int ocfs2_refcount_cow_xattr(struct inode *inode,
 	context->cow_start = cow_start;
 	context->cow_len = cow_len;
 	context->ref_tree = ref_tree;
-	context->ref_root_bh = ref_root_bh;;
+	context->ref_root_bh = ref_root_bh;
 	context->cow_object = xv;
 
 	context->cow_duplicate_clusters = ocfs2_duplicate_clusters_by_jbd;
-- 
1.7.3.1.g432b3.dirty

