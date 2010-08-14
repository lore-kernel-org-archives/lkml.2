Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab0HNHCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 03:02:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:39531 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab0HNHCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 03:02:44 -0400
Date: Sat, 14 Aug 2010 16:02:37 +0900
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        anemo@mba.ocn.ne.jp
Subject: [PATCH] MIPS: TX49xx: rename ARCH_KMALLOC_MINALIGN to
 ARCH_DMA_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100814160128H.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Aug 2010 16:02:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures need to set ARCH_DMA_MINALIGN to the minimum DMA
alignment (the commit
a6eb9fe105d5de0053b261148cee56c94b4720ca). Defining
ARCH_KMALLOC_MINALIGN doesn't work anymore.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/mips/include/asm/mach-tx49xx/kmalloc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/mach-tx49xx/kmalloc.h b/arch/mips/include/asm/mach-tx49xx/kmalloc.h
index b74caf6..ff9a8b8 100644
--- a/arch/mips/include/asm/mach-tx49xx/kmalloc.h
+++ b/arch/mips/include/asm/mach-tx49xx/kmalloc.h
@@ -1,6 +1,6 @@
 #ifndef __ASM_MACH_TX49XX_KMALLOC_H
 #define __ASM_MACH_TX49XX_KMALLOC_H
 
-#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
+#define ARCH_DMA_MINALIGN L1_CACHE_BYTES
 
 #endif /* __ASM_MACH_TX49XX_KMALLOC_H */
-- 
1.6.5

