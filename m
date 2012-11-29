Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2K2KAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:00:31 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52927 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2K2KA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:00:29 -0500
From: zwu.kernel@gmail.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] ext4: remove some unused code lines
Date: Thu, 29 Nov 2012 18:00:00 +0800
Message-Id: <1354183200-8628-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112910-5806-0000-0000-00001C4EF47C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

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

