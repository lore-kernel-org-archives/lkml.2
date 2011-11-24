Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1KXC6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:58:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46117 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1KXC6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:58:07 -0500
Message-ID: <4ECDB2B2.2000206@gmail.com>
Date: Thu, 24 Nov 2011 10:57:54 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: mel@csn.ul.ie, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cleanup comment in include/linux/compaction.h for defer_compaction
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No compact_defer_limit is found in kernel source code.
Per the code implementation, compact_defer_limit should be
zone->compact_defer_shift. Cleanup the comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 include/linux/compaction.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index cc9f7a4..b297a9c 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -32,8 +32,8 @@ extern unsigned long compact_zone_order(struct zone *zone, int order,
 
 /*
  * Compaction is deferred when compaction fails to result in a page
- * allocation success. 1 << compact_defer_limit compactions are skipped up
- * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
+ * allocation success. 1 << zone->compact_defer_shift compactions are
+ * skipped up to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
  */
 static inline void defer_compaction(struct zone *zone)
 {
-- 
1.7.1

