Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0DEXy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:54:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:47014 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab0DEXyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:54:41 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH -mm 05/12] m32r: use use asm-generic/scatterlist.h
Date: Tue,  6 Apr 2010 08:52:40 +0900
Message-Id: <1270511567-18567-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/include/asm/scatterlist.h |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/arch/m32r/include/asm/scatterlist.h b/arch/m32r/include/asm/scatterlist.h
index 1ed372c..aeeddd8 100644
--- a/arch/m32r/include/asm/scatterlist.h
+++ b/arch/m32r/include/asm/scatterlist.h
@@ -1,20 +1,7 @@
 #ifndef _ASM_M32R_SCATTERLIST_H
 #define _ASM_M32R_SCATTERLIST_H
 
-#include <asm/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-    unsigned long sg_magic;
-#endif
-    char *  address;    /* Location data is to be transferred to, NULL for
-                         * highmem page */
-    unsigned long page_link;
-    unsigned int offset;/* for highmem, page offset */
-
-    dma_addr_t dma_address;
-    unsigned int length;
-};
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD (0x1fffffff)
 
-- 
1.7.0

