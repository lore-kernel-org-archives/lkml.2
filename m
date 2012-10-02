Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2JBLmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:42:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:3579 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab2JBLmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:42:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="151464418"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/4] dmaengine: dw_dmac: add module alias
Date: Tue,  2 Oct 2012 14:41:59 +0300
Message-Id: <1349178121-9105-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

It's good to have a quasistatic name for the platform driver.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 0b88ced..bbb2a82 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1712,6 +1712,7 @@ static struct platform_driver dw_driver = {
 
 module_platform_driver(dw_driver);
 
+MODULE_ALIAS("platform:dw_dmac");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
-- 
1.7.10.4

