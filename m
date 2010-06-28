Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0F1Nlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:41:45 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:54286 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754844Ab0F1Nlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:41:44 -0400
Date: Mon, 28 Jun 2010 15:41:42 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/2] Removing dead CONFIG_IOMMU_DEBUG
Message-ID: <79a9f3d21c0b49be4278179357311731ab7ece5c.1277731915.git.siccegge@cs.fau.de>
References: <cover.1277731915.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277731915.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_IOMMU_DEBUG doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/ia64/kernel/pci-dma.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index f6b1ff0..b70d53a 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -26,11 +26,7 @@ EXPORT_SYMBOL(bad_dma_address);
 static int iommu_sac_force __read_mostly;
 
 int no_iommu __read_mostly;
-#ifdef CONFIG_IOMMU_DEBUG
-int force_iommu __read_mostly = 1;
-#else
 int force_iommu __read_mostly;
-#endif
 
 int iommu_pass_through;
 
-- 
1.7.0.4

