Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1H3HIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:08:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58743 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1H3HIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:08:34 -0400
Subject: [PATCH] dmaengine i.MX DMA/SDMA: add missing include of
 linux/module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 15:08:24 +0800
Message-ID: <1314688104.23734.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing include of linux/module.h to fix build error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/dma/imx-dma.c  |    1 +
 drivers/dma/imx-sdma.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index d99f71c..d746899 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -14,6 +14,7 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index b5cc27d..eab1fe7 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
-- 
1.7.4.1



