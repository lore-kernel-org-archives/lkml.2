Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0JVFSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:18:00 -0400
Received: from mail.perches.com ([173.55.12.10]:3482 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0JVFR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:17:28 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] fs/jfs: typo fix of faild to failed
Date: Thu, 21 Oct 2010 22:17:18 -0700
Message-Id: <2d82f543e3fd9a32ed14e6a660a92197be1ed476.1287724261.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jfs/jfs_mount.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index 7b698f2..9895595 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -97,7 +97,7 @@ int jfs_mount(struct super_block *sb)
 
 	ipaimap = diReadSpecial(sb, AGGREGATE_I, 0);
 	if (ipaimap == NULL) {
-		jfs_err("jfs_mount: Faild to read AGGREGATE_I");
+		jfs_err("jfs_mount: Failed to read AGGREGATE_I");
 		rc = -EIO;
 		goto errout20;
 	}
@@ -148,7 +148,7 @@ int jfs_mount(struct super_block *sb)
 	if ((sbi->mntflag & JFS_BAD_SAIT) == 0) {
 		ipaimap2 = diReadSpecial(sb, AGGREGATE_I, 1);
 		if (!ipaimap2) {
-			jfs_err("jfs_mount: Faild to read AGGREGATE_I");
+			jfs_err("jfs_mount: Failed to read AGGREGATE_I");
 			rc = -EIO;
 			goto errout35;
 		}
-- 
1.7.3.1.g432b3.dirty

