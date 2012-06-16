Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab2FPMiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 08:38:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33283 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2FPMiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 08:38:07 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/frontswap: cleanup doc and comment error
Date: Sat, 16 Jun 2012 20:37:48 +0800
Message-Id: <1339850268-13384-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 Documentation/vm/frontswap.txt |    4 ++--
 mm/frontswap.c                 |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/vm/frontswap.txt b/Documentation/vm/frontswap.txt
index 37067cf..5ef2d13 100644
--- a/Documentation/vm/frontswap.txt
+++ b/Documentation/vm/frontswap.txt
@@ -25,7 +25,7 @@ with the specified swap device number (aka "type").  A "store" will
 copy the page to transcendent memory and associate it with the type and
 offset associated with the page. A "load" will copy the page, if found,
 from transcendent memory into kernel memory, but will NOT remove the page
-from from transcendent memory.  An "invalidate_page" will remove the page
+from transcendent memory.  An "invalidate_page" will remove the page
 from transcendent memory and an "invalidate_area" will remove ALL pages
 associated with the swap type (e.g., like swapoff) and notify the "device"
 to refuse further stores with that swap type.
@@ -99,7 +99,7 @@ server configured with a large amount of RAM... without pre-configuring
 how much of the RAM is available for each of the clients!
 
 In the virtual case, the whole point of virtualization is to statistically
-multiplex physical resources acrosst the varying demands of multiple
+multiplex physical resources across the varying demands of multiple
 virtual machines.  This is really hard to do with RAM and efforts to do
 it well with no kernel changes have essentially failed (except in some
 well-publicized special-case workloads).
diff --git a/mm/frontswap.c b/mm/frontswap.c
index e250255..174c3f3 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(__frontswap_init);
  * "Store" data from a page to frontswap and associate it with the page's
  * swaptype and offset.  Page must be locked and in the swap cache.
  * If frontswap already contains a page with matching swaptype and
- * offset, the frontswap implmentation may either overwrite the data and
+ * offset, the frontswap implementation may either overwrite the data and
  * return success or invalidate the page from frontswap and return failure.
  */
 int __frontswap_store(struct page *page)
-- 
1.7.9.5

