Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2EJCN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:13:28 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:32947 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2EJCN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:13:27 -0400
From: zwu.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, wuzhy@linux.vnet.ibm.com, stefanha@linux.vnet.ibm.com
Subject: [PATCH] block: remove some unnecessary codes
Date: Thu, 10 May 2012 10:13:15 +0800
Message-Id: <1336615995-3813-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051002-5518-0000-0000-00000449B4E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 block/partition-generic.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 6df5d69..4c03880 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -473,7 +473,6 @@ rescan:
 	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
 		sector_t size, from;
-		struct partition_meta_info *info = NULL;
 
 		size = state->parts[p].size;
 		if (!size)
@@ -509,7 +508,6 @@ rescan:
 		}
 
 		if (state->parts[p].has_info)
-			info = &state->parts[p].info;
 		part = add_partition(disk, p, from, size,
 				     state->parts[p].flags,
 				     &state->parts[p].info);
-- 
1.7.6

