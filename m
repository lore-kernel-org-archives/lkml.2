Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2JQKcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:32:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:17406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595Ab2JQKb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:31:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,599,1344236400"; 
   d="scan'208";a="207096008"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 1/4] dmaengine: dw_dmac: remove CLK dependency
Date: Wed, 17 Oct 2012 13:31:15 +0300
Message-Id: <1350469879-16018-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

This driver could be used on different platforms. Thus, the HAVE_CLK dependency
is dropped away.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 677cd6e..df32537 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -83,7 +83,6 @@ config INTEL_IOP_ADMA
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA support"
-	depends on HAVE_CLK
 	select DMA_ENGINE
 	default y if CPU_AT32AP7000
 	help
-- 
1.7.10.4

