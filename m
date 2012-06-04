Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401Ab2FDLus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:50:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57009 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2FDLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:50:47 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: jaswinder.singh@linaro.org, vinod.koul@intel.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/1] DMA: PL330: Add missing static storage class specifier
Date: Mon,  4 Jun 2012 17:09:45 +0530
Message-Id: <1338809985-6864-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warning:
drivers/dma/pl330.c:2542:5: warning: symbol 'add_desc' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/dma/pl330.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index cbcc28e..63b6ad5 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2539,7 +2539,7 @@ static inline void _init_desc(struct dma_pl330_desc *desc)
 }
 
 /* Returns the number of descriptors added to the DMAC pool */
-int add_desc(struct dma_pl330_dmac *pdmac, gfp_t flg, int count)
+static int add_desc(struct dma_pl330_dmac *pdmac, gfp_t flg, int count)
 {
 	struct dma_pl330_desc *desc;
 	unsigned long flags;
-- 
1.7.4.1

