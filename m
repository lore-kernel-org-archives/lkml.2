Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0DEX4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:56:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:47039 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083Ab0DEXyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:54:54 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH -mm 04/12] h8300: use asm-generic/scatterlist.h
Date: Tue,  6 Apr 2010 08:52:39 +0900
Message-Id: <1270511567-18567-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Apr 2010 08:54:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/include/asm/scatterlist.h |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/arch/h8300/include/asm/scatterlist.h b/arch/h8300/include/asm/scatterlist.h
index d3ecdd8..de08a4a 100644
--- a/arch/h8300/include/asm/scatterlist.h
+++ b/arch/h8300/include/asm/scatterlist.h
@@ -1,17 +1,7 @@
 #ifndef _H8300_SCATTERLIST_H
 #define _H8300_SCATTERLIST_H
 
-#include <asm/types.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;
-	dma_addr_t	dma_address;
-	unsigned int	length;
-};
+#include <asm-generic/scatterlist.h>
 
 #define ISA_DMA_THRESHOLD	(0xffffffff)
 
-- 
1.7.0

