Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab0HNArb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:47:31 -0400
Received: from king.tilera.com ([72.1.168.226]:19659 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab0HNAra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:47:30 -0400
Message-Id: <201008140047.o7E0lTiQ006412@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Aug 2010 20:43:39 -0400
Subject: [PATCH] arch/tile: rename ARCH_KMALLOC_MINALIGN to ARCH_DMA_MINALIGN
To: linux-kernel@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
X-OriginalArrivalTime: 14 Aug 2010 00:47:30.0143 (UTC) FILETIME=[46310EF0:01CB3B4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See commit a6eb9fe105d5de0053b261148cee56c94b4720ca.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/cache.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
index f610184..08a2815 100644
--- a/arch/tile/include/asm/cache.h
+++ b/arch/tile/include/asm/cache.h
@@ -27,11 +27,10 @@
 #define L2_CACHE_ALIGN(x)	(((x)+(L2_CACHE_BYTES-1)) & -L2_CACHE_BYTES)
 
 /*
- * TILE-Gx is fully coherents so we don't need to define
- * ARCH_KMALLOC_MINALIGN.
+ * TILE-Gx is fully coherent so we don't need to define ARCH_DMA_MINALIGN.
  */
 #ifndef __tilegx__
-#define ARCH_KMALLOC_MINALIGN	L2_CACHE_BYTES
+#define ARCH_DMA_MINALIGN	L2_CACHE_BYTES
 #endif
 
 /* use the cache line size for the L2, which is where it counts */
-- 
1.6.5.2

