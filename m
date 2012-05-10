Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab2EJDIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:08:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47002 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab2EJDIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:08:53 -0400
From: zwu.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, wuzhy@linux.vnet.ibm.com, stefanha@linux.vnet.ibm.com,
        trbecker@trbecker.org
Subject: [PATCH v2] block: Remove some unnecessary codes
Date: Thu, 10 May 2012 11:06:33 +0800
Message-Id: <1336619193-4808-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051003-5518-0000-0000-00000449E949
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 block/partition-generic.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 6df5d69..b6a9d5b 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -473,7 +473,6 @@ rescan:
 	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
 		sector_t size, from;
-		struct partition_meta_info *info = NULL;
 
 		size = state->parts[p].size;
 		if (!size)
@@ -508,8 +507,6 @@ rescan:
 			}
 		}
 
-		if (state->parts[p].has_info)
-			info = &state->parts[p].info;
 		part = add_partition(disk, p, from, size,
 				     state->parts[p].flags,
 				     &state->parts[p].info);
-- 
1.7.6

