Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2FZOft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:35:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43031 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab2FZOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:35:48 -0400
From: Chen Baozi <baozich@gmail.com>
To: bpm@sgi.com
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Chen Baozi <baozich@gmail.com>
Subject: [PATCH] xfs: Fix comment typo of xfs_open_devices()
Date: Tue, 26 Jun 2012 22:35:05 +0800
Message-Id: <1340721305-3602-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since "get_sb_bdev()" has been changed to "mount_bdev()", fix
the comment accordingly.

Signed-off-by: Chen Baozi <baozich@gmail.com>
---
 fs/xfs/xfs_super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0d9de41..3cf4a5c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -649,7 +649,7 @@ xfs_close_devices(
  *
  * We only have to handle opening the log and realtime volumes here if
  * they are present.  The data subvolume has already been opened by
- * get_sb_bdev() and is stored in sb->s_bdev.
+ * mount_bdev() and is stored in sb->s_bdev.
  */
 STATIC int
 xfs_open_devices(
-- 
1.7.1

