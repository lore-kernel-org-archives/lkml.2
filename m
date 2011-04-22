Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1DVQfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:35:11 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:48032 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab1DVQfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:35:07 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 3/5] dmaengine: at_hdmac: debug information sg_len for prep_slave_sg
Date: Fri, 22 Apr 2011 19:41:59 +0200
Message-Id: <5c1f9b7a5843b1e476a3f3e98d4e8d2fa6065f16.1303493836.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
In-Reply-To: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
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

