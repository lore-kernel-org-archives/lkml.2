Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab2GFCWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 22:22:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34075 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab2GFCWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 22:22:05 -0400
Message-ID: <4FF64BC0.40607@gmail.com>
Date: Fri, 06 Jul 2012 10:21:52 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: fix comment in extents.c/ext4_ext_check_cache
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the branch test, it means no valid data cached.
Fix the comment here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91341ec..5207b7b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2121,7 +2121,7 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 	cex = &EXT4_I(inode)->i_cached_extent;
 	sbi = EXT4_SB(inode->i_sb);
 
-	/* has cache valid data? */
+	/* do not cache valid data? */
 	if (cex->ec_len == 0)
 		goto errout;
 
-- 
1.7.1

