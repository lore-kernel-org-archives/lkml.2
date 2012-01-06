Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293Ab2AFLAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:00:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41483 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab2AFLAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:00:49 -0500
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Alex Elder <aelder@sgi.com>, Ben Myers <bpm@sgi.com>,
        xfs masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 2/2] xfs: cleanup XFS_BB_FSB_OFFSET
Date: Fri,  6 Jan 2012 16:42:18 +0530
Message-Id: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the macro, as this is no more needed in the code. 
Tried to find the reference when it was last used - but the usage 
for this seemed to have been dropped long time ago.

Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
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

