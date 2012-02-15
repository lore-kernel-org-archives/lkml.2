Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2BOTUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:20:34 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60142 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030Ab2BOTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:20:30 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/dma: linux/module.h included twice
Date: Wed, 15 Feb 2012 20:20:26 +0100
Message-Id: <1329333626-31993-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333630;ca0e1ac3;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/dma/imx-dma.c and drivers/dma/imx-sdma.c included
'linux/module.h' twice, remove the duplicates.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/dma/imx-dma.c  |    1 -
 drivers/dma/imx-sdma.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index e4383ee..678cd01 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -24,7 +24,6 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/dmaengine.h>
-#include <linux/module.h>
 
 #include <asm/irq.h>
 #include <mach/dma-v1.h>
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 8bc5acf..63540d3 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -35,7 +35,6 @@
 #include <linux/dmaengine.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/module.h>
 
 #include <asm/irq.h>
 #include <mach/sdma.h>
-- 
1.7.8.3

