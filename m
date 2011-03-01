Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1CAKeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 05:34:18 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:38863 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977Ab1CAKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 05:34:17 -0500
From: Per Forlin <per.forlin@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH] ste_dma40: assign device_prep_dma_sg for dma_memcpy
Date: Tue, 1 Mar 2011 11:32:59 +0100
Message-ID: <1298975579-1594-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 6e1d46a..1dd8ea3 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2496,7 +2496,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	base->dma_memcpy.device_alloc_chan_resources = d40_alloc_chan_resources;
 	base->dma_memcpy.device_free_chan_resources = d40_free_chan_resources;
 	base->dma_memcpy.device_prep_dma_memcpy = d40_prep_memcpy;
-	base->dma_slave.device_prep_dma_sg = d40_prep_sg;
+	base->dma_memcpy.device_prep_dma_sg = d40_prep_sg;
 	base->dma_memcpy.device_prep_slave_sg = d40_prep_slave_sg;
 	base->dma_memcpy.device_tx_status = d40_tx_status;
 	base->dma_memcpy.device_issue_pending = d40_issue_pending;
-- 
1.6.3.3

