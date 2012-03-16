Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161782Ab2CPAIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:08:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59991 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1032384Ab2CPAI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:08:28 -0400
From: Joe Perches <joe@perches.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] ext4: Fix indentation
Date: Thu, 15 Mar 2012 17:07:31 -0700
Message-Id: <3457473a97c505cf9e5c5a34781a82e4e867a2e6.1331856300.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1331856299.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indent a line appropriate.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/extents.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4ca1c7e..c39a737 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -533,8 +533,9 @@ ext4_ext_binsearch_idx(struct inode *inode,
 
 		chix = ix = EXT_FIRST_INDEX(eh);
 		for (k = 0; k < le16_to_cpu(eh->eh_entries); k++, ix++) {
-		  if (k != 0 &&
-		      le32_to_cpu(ix->ei_block) <= le32_to_cpu(ix[-1].ei_block)) {
+			if (k != 0 &&
+			    le32_to_cpu(ix->ei_block) <=
+			    le32_to_cpu(ix[-1].ei_block)) {
 				pr_debug("k=%d, ix=0x%p, first=0x%p\n",
 					 k, ix, EXT_FIRST_INDEX(eh));
 				pr_debug("%u <= %u\n",
-- 
1.7.8.111.gad25c.dirty

