Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab2H1HBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 03:01:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37622 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2H1HBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 03:01:51 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] dma: tegra: remove useless include of <mach/*.h>
Date: Tue, 28 Aug 2012 00:01:45 -0700
Message-Id: <1346137305-7226-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Nothing from this file is needed, so remove the include. This helps
single zImage work by reducing use of the mach-tegra/include/mach/
directory.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 24acd71..1949e53 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -32,7 +32,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
-#include <mach/clk.h>
 #include "dmaengine.h"
 
 #define TEGRA_APBDMA_GENERAL			0x0
-- 
1.7.9.5

