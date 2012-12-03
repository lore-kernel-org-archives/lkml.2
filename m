Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2LCCZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:25:56 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:56881 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab2LCCZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:25:55 -0500
From: zwu.kernel@gmail.com
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] ext4: remove some unused code lines
Date: Mon,  3 Dec 2012 10:25:34 +0800
Message-Id: <1354501534-23655-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120302-7408-0000-0000-00000ABBCD48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  In ext4_ext_in_cache(), some codes are redundant,
this patch will remove them.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7011ac9..43ec639 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2156,7 +2156,6 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 		  struct ext4_extent *ex)
 {
 	struct ext4_ext_cache *cex;
-	struct ext4_sb_info *sbi;
 	int ret = 0;
 
 	/*
@@ -2164,7 +2163,6 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 	 */
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	cex = &EXT4_I(inode)->i_cached_extent;
-	sbi = EXT4_SB(inode->i_sb);
 
 	/* has cache valid data? */
 	if (cex->ec_len == 0)
-- 
1.7.6.5

