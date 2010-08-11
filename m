Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0HKCMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:12:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:49700 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928Ab0HKCMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:12:10 -0400
Date: Wed, 11 Aug 2010 11:11:06 +0900
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tile: remove unused ISA_DMA_THRESHOLD define
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100811111000J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 11 Aug 2010 11:11:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to define ISA_DMA_THRESHOLD

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/tile/include/asm/scatterlist.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/scatterlist.h b/arch/tile/include/asm/scatterlist.h
index c560424..ad8deec 100644
--- a/arch/tile/include/asm/scatterlist.h
+++ b/arch/tile/include/asm/scatterlist.h
@@ -15,8 +15,6 @@
 #ifndef _ASM_TILE_SCATTERLIST_H
 #define _ASM_TILE_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD	(~0UL)
-
 #include <asm-generic/scatterlist.h>
 
 #endif /* _ASM_TILE_SCATTERLIST_H */
-- 
1.6.5

