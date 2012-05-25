Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2EYQs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:48:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47389 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2EYQs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:48:57 -0400
From: Chen Baozi <baozich@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [RESEND PATCH] xfs: fix typo in comment of xfs_dinode_t.
Date: Sat, 26 May 2012 00:48:47 +0800
Message-Id: <D347A332-0256-43E4-8FCE-BCFC1DD478C8@gmail.com>
Cc: linux-kernel@vger.kernel.org, bpm@sgi.com
To: xfs@oss.sgi.com
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be "XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR" instead
of "XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR".

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