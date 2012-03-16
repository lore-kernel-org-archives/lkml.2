Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2CPSgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:36:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59027 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2CPSgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:36:36 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: bpm@sgi.com
Cc: elder@kernel.org, xfs-master@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: xfs: fix section mismatch in linux-next
Date: Fri, 16 Mar 2012 11:36:18 -0700
Message-Id: <1331922978-28572-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xfs_qm_exit() is called in init_xfs_fs().

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 fs/xfs/xfs_dquot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4be16a0..1155208 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1065,7 +1065,7 @@ out:
 	return -ENOMEM;
 }
 
-void __exit
+void
 xfs_qm_exit(void)
 {
 	kmem_zone_destroy(xfs_qm_dqtrxzone);
-- 
1.7.7.6

