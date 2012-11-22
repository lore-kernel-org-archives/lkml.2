Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab2KVSt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:49:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44975 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab2KVStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:49:21 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org, trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] mips: lantiq: Fix typo endianess in dma.c
Date: Fri, 23 Nov 2012 01:05:13 +0900
Message-Id: <1353600313-11983-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.273.g2d242fb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo ENDIANESS to ENDIANNESS in
arc/mips/lantiq/xway/dma.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/mips/lantiq/xway/dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/lantiq/xway/dma.c b/arch/mips/lantiq/xway/dma.c
index 55d2c4f..0f7228d 100644
--- a/arch/mips/lantiq/xway/dma.c
+++ b/arch/mips/lantiq/xway/dma.c
@@ -48,7 +48,7 @@
 #define DMA_CLK_DIV4		BIT(6)		/* polling clock divider */
 #define DMA_2W_BURST		BIT(1)		/* 2 word burst length */
 #define DMA_MAX_CHANNEL		20		/* the soc has 20 channels */
-#define DMA_ETOP_ENDIANESS	(0xf << 8) /* endianess swap etop channels */
+#define DMA_ETOP_ENDIANNESS	(0xf << 8) /* endianness swap etop channels */
 #define DMA_WEIGHT	(BIT(17) | BIT(16))	/* default channel wheight */
 
 #define ltq_dma_r32(x)			ltq_r32(ltq_dma_membase + (x))
@@ -191,10 +191,10 @@ ltq_dma_init_port(int p)
 	switch (p) {
 	case DMA_PORT_ETOP:
 		/*
-		 * Tell the DMA engine to swap the endianess of data frames and
+		 * Tell the DMA engine to swap the endianness of data frames and
 		 * drop packets if the channel arbitration fails.
 		 */
-		ltq_dma_w32_mask(0, DMA_ETOP_ENDIANESS | DMA_PDEN,
+		ltq_dma_w32_mask(0, DMA_ETOP_ENDIANNESS | DMA_PDEN,
 			LTQ_DMA_PCTRL);
 		break;
 
-- 
1.8.0.273.g2d242fb

