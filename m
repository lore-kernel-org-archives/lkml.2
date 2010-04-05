Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0DEX42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:56:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:47031 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab0DEXyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:54:51 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH -mm 03/12] cris: use asm-generic/scatterlist.h
Date: Tue,  6 Apr 2010 08:52:38 +0900
Message-Id: <1270511567-18567-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/include/asm/scatterlist.h |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/arch/cris/include/asm/scatterlist.h b/arch/cris/include/asm/scatterlist.h
index faff53a..249a784 100644
--- a/arch/cris/include/asm/scatterlist.h
+++ b/arch/cris/include/asm/scatterlist.h
@@ -1,22 +1,7 @@
 #ifndef __ASM_CRIS_SCATTERLIST_H
 #define __ASM_CRIS_SCATTERLIST_H
 
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	char *  address;    /* Location data is to be transferred to */
-	unsigned int length;
-
-	/* The following is i386 highmem junk - not used by us */
-	unsigned long page_link;
-	unsigned int offset;/* for highmem, page offset */
-
-};
-
-#define sg_dma_address(sg)	((sg)->address)
-#define sg_dma_len(sg)		((sg)->length)
-/* i386 junk */
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD (0x1fffffff)
 
-- 
1.7.0

