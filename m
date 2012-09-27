Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2I0HcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:32:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:2571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab2I0HcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:32:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,494,1344236400"; 
   d="scan'208";a="198436985"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 4/7] dmaengine: dw_dmac: amend description and indentation
Date: Thu, 27 Sep 2012 10:31:58 +0300
Message-Id: <1348731121-2515-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

The driver will be used as a core part for various implementations of the
DesignWare DMA device. The patch adjusts description on the top and corrects
paragraph indentation in few places across the code.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index bbb2a82..9f0129d 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1,14 +1,15 @@
 /*
- * Driver for the Synopsys DesignWare DMA Controller (aka DMACA on
- * AVR32 systems.)
+ * Core driver for the Synopsys DesignWare DMA Controller
  *
  * Copyright (C) 2007-2008 Atmel Corporation
  * Copyright (C) 2010-2011 ST Microelectronics
+ * Copyright (C) 2012 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
 #include <linux/bitops.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -222,7 +223,6 @@ static inline void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
 		channel_readl(dwc, CTL_LO));
 }
 
-
 static inline void dwc_chan_disable(struct dw_dma *dw, struct dw_dma_chan *dwc)
 {
 	channel_clear_bit(dw, CH_EN, dwc->mask);
@@ -1679,6 +1679,7 @@ static int dw_resume_noirq(struct device *dev)
 
 	clk_prepare_enable(dw->clk);
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
+
 	return 0;
 }
 
-- 
1.7.10.4

