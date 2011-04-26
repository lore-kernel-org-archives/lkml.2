Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1DZKE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:04:57 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33644 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908Ab1DZKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:04:56 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/4] pch_dma: Modify for checkpatch
Date: Tue, 26 Apr 2011 19:05:50 +0900
Message-Id: <1303812353-6712-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 8d8fef1..9421ed5 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -138,7 +138,8 @@ struct pch_dma {
 #define dma_writel(pd, name, val) \
 	writel((val), (pd)->membase + PCH_DMA_##name)
 
-static inline struct pch_dma_desc *to_pd_desc(struct dma_async_tx_descriptor *txd)
+static inline struct pch_dma_desc *to_pd_desc(
+					struct dma_async_tx_descriptor *txd)
 {
 	return container_of(txd, struct pch_dma_desc, txd);
 }
@@ -163,13 +164,15 @@ static inline struct device *chan2parent(struct dma_chan *chan)
 	return chan->dev->device.parent;
 }
 
-static inline struct pch_dma_desc *pdc_first_active(struct pch_dma_chan *pd_chan)
+static inline struct pch_dma_desc *pdc_first_active(
+						struct pch_dma_chan *pd_chan)
 {
 	return list_first_entry(&pd_chan->active_list,
 				struct pch_dma_desc, desc_node);
 }
 
-static inline struct pch_dma_desc *pdc_first_queued(struct pch_dma_chan *pd_chan)
+static inline struct pch_dma_desc *pdc_first_queued(
+						struct pch_dma_chan *pd_chan)
 {
 	return list_first_entry(&pd_chan->queue,
 				struct pch_dma_desc, desc_node);
-- 
1.7.4

