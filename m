Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761Ab2DLBwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:52:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2DLBwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:52:53 -0400
From: Chen Baozi <baozich@gmail.com>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: Chen Baozi <baozich@gmail.com>
Subject: [PATCH] fs/xfs/xfs_dinode.h: fix comments of xfs_dinode_t.
Date: Thu, 12 Apr 2012 01:52:35 +0800
Message-Id: <1334166755-32052-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Chen Baozi <baozich@gmail.com>
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

