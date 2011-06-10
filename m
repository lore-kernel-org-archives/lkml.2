Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab1FJWPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:15:44 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:56434 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJWPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:15:43 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1307744140!10961482!7
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.69]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dma/ep93xx_dma.c: local symbols should be static
Date: Fri, 10 Jun 2011 15:15:05 -0700
User-Agent: KMail/1.9.9
CC: <mika.westerberg@iki.fi>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106101515.05990.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'ep93xx_dma_prep_dma_memcpy' is only used in this driver
and should be marked static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>

---

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 0766c1e..5d7a49b 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -902,7 +902,7 @@ static void ep93xx_dma_free_chan_resources(struct dma_chan *chan)
  *
  * Returns a valid DMA descriptor or %NULL in case of failure.
  */
-struct dma_async_tx_descriptor *
+static struct dma_async_tx_descriptor *
 ep93xx_dma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest,
 			   dma_addr_t src, size_t len, unsigned long flags)
 {
