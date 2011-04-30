Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab1D3NvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 09:51:24 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:60349 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab1D3NvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 09:51:14 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 3/5] dmaengine: at_hdmac: debug information sg_len for prep_slave_sg
Date: Sat, 30 Apr 2011 16:57:47 +0200
Message-Id: <bfce3e98b8de71810db7f147436215a03167daa0.1304174965.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1303791881.896.18.camel@vkoul-udesk3>
References: <1303791881.896.18.camel@vkoul-udesk3>
In-Reply-To: <35f32b2bdf51d9d5867ca352ce96d786c74a58eb.1304174965.git.nicolas.ferre@atmel.com>
References: <35f32b2bdf51d9d5867ca352ce96d786c74a58eb.1304174965.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index ed9d924..8f50a0f 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -687,7 +687,8 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct scatterlist	*sg;
 	size_t			total_len = 0;
 
-	dev_vdbg(chan2dev(chan), "prep_slave_sg: %s f0x%lx\n",
+	dev_vdbg(chan2dev(chan), "prep_slave_sg (%d): %s f0x%lx\n",
+			sg_len,
 			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
 			flags);
 
-- 
1.7.3

