Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab0EZS3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:29:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36906 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab0EZS3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:29:08 -0400
From: Sebastien JAN <s-jan@ti.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Sebastien Jan <s-jan@ti.com>
Subject: [PATCH] Add missing extern to heap_free declaration
Date: Wed, 26 May 2010 20:28:19 +0200
Message-Id: <1274898499-32497-1-git-send-email-s-jan@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Jan <s-jan@ti.com>

heap_free() function is defined in lib/prio_heap.c

Signed-off-by: Sebastien Jan <s-jan@ti.com>
---
 include/linux/prio_heap.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/prio_heap.h b/include/linux/prio_heap.h
index 0809435..fd67387 100644
--- a/include/linux/prio_heap.h
+++ b/include/linux/prio_heap.h
@@ -36,7 +36,7 @@ extern int heap_init(struct ptr_heap *heap, size_t size, gfp_t gfp_mask,
  * heap_free - release a heap's storage
  * @heap: the heap structure whose data should be released
  */
-void heap_free(struct ptr_heap *heap);
+extern void heap_free(struct ptr_heap *heap);
 
 /**
  * heap_insert - insert a value into the heap and return any overflowed value
-- 
1.6.3.3

