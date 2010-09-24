Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0IXBGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 21:06:52 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8630 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0IXBGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 21:06:51 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] MIPS: Octeon: Remove plat_map_dma_mem_page().
Date: Thu, 23 Sep 2010 18:06:38 -0700
Message-Id: <1285290398-4358-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-10-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-10-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 24 Sep 2010 01:06:51.0273 (UTC) FILETIME=[C5372F90:01CB5B84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now unused.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---

This is a small addition to the rest of the patch set.  It could be
rolled into [PATCH 9/9] MIPS: Octeon: Rewrite DMA mapping functions.

 .../include/asm/mach-cavium-octeon/dma-coherence.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
index a0058fb..cedf254 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
@@ -23,12 +23,6 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	BUG();
 }
 
-static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
-	struct page *page)
-{
-	BUG();
-}
-
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
-- 
1.7.2.2

