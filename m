Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2FLIpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:45:10 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:35613 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2FLIpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:45:03 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@linux.intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmaengine: at_hdmac: trivial: fix comment in header
Date: Tue, 12 Jun 2012 10:44:55 +0200
Message-ID: <1339490695-28796-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all Atmel SoCs were pointed out in header comment which was bringing
confusion. Remove the truncated list of supported devices, replace by the
only one that is not supported.

Reported-by: Elen Song <elen.song@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7292aa8..bb16013 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -9,10 +9,9 @@
  * (at your option) any later version.
  *
  *
- * This supports the Atmel AHB DMA Controller,
- *
- * The driver has currently been tested with the Atmel AT91SAM9RL
- * and AT91SAM9G45 series.
+ * This supports the Atmel AHB DMA Controller found in several Atmel SoCs.
+ * The only Atmel DMA Controller that is not covered by this driver is the one
+ * found on AT91SAM9263.
  */
 
 #include <linux/clk.h>
-- 
1.7.10

