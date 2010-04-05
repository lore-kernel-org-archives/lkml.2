Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab0DEXzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:55:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:47032 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070Ab0DEXyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:54:51 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH -mm 06/12] m68k: use asm-generic/scatterlist.h
Date: Tue,  6 Apr 2010 08:52:41 +0900
Message-Id: <1270511567-18567-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 arch/m68k/include/asm/scatterlist.h |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/arch/m68k/include/asm/scatterlist.h b/arch/m68k/include/asm/scatterlist.h
index e27ad90..175da06 100644
--- a/arch/m68k/include/asm/scatterlist.h
+++ b/arch/m68k/include/asm/scatterlist.h
@@ -1,23 +1,9 @@
 #ifndef _M68K_SCATTERLIST_H
 #define _M68K_SCATTERLIST_H
 
-#include <linux/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-	unsigned int length;
-
-	dma_addr_t dma_address;	/* A place to hang host-specific addresses at. */
-};
+#include <asm-generic/scatterlist.h>
 
 /* This is bogus and should go away. */
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
-
 #endif /* !(_M68K_SCATTERLIST_H) */
-- 
1.7.0

