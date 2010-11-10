Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0KJXqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:46:31 -0500
Received: from mail.perches.com ([173.55.12.10]:4955 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab0KJXq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:46:28 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH 5/6] fs/jfs: Add printf format/argument verification
Date: Wed, 10 Nov 2010 15:46:17 -0800
Message-Id: <a22ba4f754931aabc3928435e613a1b809d31f9e.1289432524.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289432524.git.joe@perches.com>
References: <cover.1289432524.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __attribute__((format... to jfs_error.

All arguments matched formats, no other changes necessary.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jfs/jfs_superblock.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/jfs/jfs_superblock.h b/fs/jfs/jfs_superblock.h
index 884fc21..1da2538 100644
--- a/fs/jfs/jfs_superblock.h
+++ b/fs/jfs/jfs_superblock.h
@@ -108,6 +108,8 @@ struct jfs_superblock {
 
 extern int readSuper(struct super_block *, struct buffer_head **);
 extern int updateSuper(struct super_block *, uint);
+
+__attribute__((format(printf, 2, 3)))
 extern void jfs_error(struct super_block *, const char *, ...);
 extern int jfs_mount(struct super_block *);
 extern int jfs_mount_rw(struct super_block *, int);
-- 
1.7.3.1.g432b3.dirty

