Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2GMIKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:10:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:38058 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab2GMIJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:09:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="165343774"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/3] dw_dmac: mark dwc_dump_lli inline
Date: Fri, 13 Jul 2012 11:09:32 +0300
Message-Id: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9151511..db56ef4 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -413,7 +413,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	spin_unlock_irqrestore(&dwc->lock, flags);
 }
 
-static void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
+static inline void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
 {
 	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
 			"  desc: s0x%llx d0x%llx l0x%llx c0x%x:%x\n",
-- 
1.7.10.4

