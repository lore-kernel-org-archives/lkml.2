Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2DZGiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:38:08 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:50606 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2DZGiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:38:07 -0400
From: Chen Baozi <baozich@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, Chen Baozi <baozich@gmail.com>
Subject: [RESEND PATCH] fs/xfs/xfs_dinode.h: fix comments of xfs_dinode_t.
Date: Thu, 26 Apr 2012 06:37:44 +0800
Message-Id: <1335393464-13835-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XFS: fix comments

fix:
- comments about xfs_dinode_t.

Signed-off-by: Chen Baozi <baozich@gmail.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_dinode.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index a372163..1d9643b 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -33,7 +33,7 @@ typedef struct xfs_timestamp {
  * variable size the leftover area split into a data and an attribute fork.
  * The format of the data and attribute fork depends on the format of the
  * inode as indicated by di_format and di_aformat.  To access the data and
- * attribute use the XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR macros
+ * attribute use the XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR macros
  * below.
  *
  * There is a very similar struct icdinode in xfs_inode which matches the
-- 
1.7.1

