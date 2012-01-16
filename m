Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2APMR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:17:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60360 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2APMRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:17:55 -0500
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/1] xfs: kill the unused XFS_BB_FSB_OFFSET macro
Date: Mon, 16 Jan 2012 17:54:36 +0530
Message-Id: <1326716676-11842-1-git-send-email-amit.sahrawat83@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the macro, as this is no more needed in the code.
Tried to find the reference when it was last used - but the usage
for this seemed to have been dropped long time ago.

Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_sb.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index cb6ae71..f429d9d 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -529,7 +529,6 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 #define	XFS_BB_TO_FSB(mp,bb)	\
 	(((bb) + (XFS_FSB_TO_BB(mp,1) - 1)) >> (mp)->m_blkbb_log)
 #define	XFS_BB_TO_FSBT(mp,bb)	((bb) >> (mp)->m_blkbb_log)
-#define	XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))
 
 /*
  * File system block to byte conversions.
-- 
1.7.2.3

