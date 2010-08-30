Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0H3DNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:13:04 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45735 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab0H3DND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:13:03 -0400
Date: Mon, 30 Aug 2010 05:12:20 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] mm: pageblock-flags.h: dead code removed
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Message-id: <ced62161886b800e8f0706cc6a17786d69f4200a.1283137455.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit removes two unused macros one of which was, as
a matter of fact, invalid.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/pageblock-flags.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index e8c0612..0949302 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -65,9 +65,4 @@ unsigned long get_pageblock_flags_group(struct page *page,
 void set_pageblock_flags_group(struct page *page, unsigned long flags,
 					int start_bitidx, int end_bitidx);
 
-#define get_pageblock_flags(page) \
-			get_pageblock_flags_group(page, 0, NR_PAGEBLOCK_BITS-1)
-#define set_pageblock_flags(page) \
-			set_pageblock_flags_group(page, 0, NR_PAGEBLOCK_BITS-1)
-
 #endif	/* PAGEBLOCK_FLAGS_H */
-- 
1.7.1


