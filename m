Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab1EYMN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:13:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:13423 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000Ab1EYMNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:13:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="8442393"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>, Per Forlin <per.forlin@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 2/2] dmaengine: add TODO items for future work on dma drivers
Date: Wed, 25 May 2011 17:09:30 +0530
Message-Id: <1306323570-11133-3-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306323570-11133-1-git-send-email-vinod.koul@intel.com>
References: <1306323570-11133-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/TODO |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/TODO

diff --git a/drivers/dma/TODO b/drivers/dma/TODO
new file mode 100644
index 0000000..b67d184
--- /dev/null
+++ b/drivers/dma/TODO
@@ -0,0 +1,12 @@
+TODO for slave dma
+
+1. Move remaining drivers to use new slave interface
+2. Remove old slave pointer machansim
+3. Make issue_pending to start the transaction in below drivers
+	- mpc512x_dma
+	- imx-dma
+	- imx-sdma
+	- mxs-dma.c
+	- dw_dmac
+	- intel_mid_dma
+	- ste_dma40
-- 
1.7.0.4

