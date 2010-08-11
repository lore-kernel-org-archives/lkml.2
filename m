Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab0HKTMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:12:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27864 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0HKTML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:12:11 -0400
Date: Wed, 11 Aug 2010 12:10:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] mm: fix fatal kernel-doc error
Message-Id: <20100811121047.06c27c1f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix a fatal kernel-doc error due to a #define coming between a
function's kernel-doc notation and the function signature.
(kernel-doc cannot handle this)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-git10.orig/mm/page-writeback.c
+++ linux-2.6.35-git10/mm/page-writeback.c
@@ -825,10 +825,10 @@ void __init page_writeback_init(void)
 /*
  * We tag pages in batches of WRITEBACK_TAG_BATCH to reduce tree_lock latency.
  */
-#define WRITEBACK_TAG_BATCH 4096
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end)
 {
+#define WRITEBACK_TAG_BATCH 4096
 	unsigned long tagged;
 
 	do {

