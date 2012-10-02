Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2JBLmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:42:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:3579 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab2JBLmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:42:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="151464420"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/4] dmaengine: dw_dmac: remove CLK dependency
Date: Tue,  2 Oct 2012 14:42:00 +0300
Message-Id: <1349178121-9105-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
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

