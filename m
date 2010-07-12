Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0GLUxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:53:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1783 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0GLUu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:59 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
Subject: [PATCH 25/36] fs/ext3: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:17 -0700
Message-Id: <dd90d7b9b09a3332ebe5c3578b5c90a657edbe02.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext3/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index e2e72c3..d056787 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -337,7 +337,7 @@ int ext3_htree_store_dirent(struct file *dir_file, __u32 hash,
 	struct dir_private_info *info;
 	int len;
 
-	info = (struct dir_private_info *) dir_file->private_data;
+	info = dir_file->private_data;
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-- 
1.7.1.337.g6068.dirty

