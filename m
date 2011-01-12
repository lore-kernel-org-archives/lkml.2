Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1ALN3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:29:22 -0500
Received: from mail.atmel.fr ([81.80.104.162]:36329 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418Ab1ALN3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:29:14 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hong.xu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/6] dmaengine: at_hdmac: trivial add precision to unmapping comment
Date: Wed, 12 Jan 2011 15:39:06 +0100
Message-Id: <1294843150-6962-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
References: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Dan,

I link this patch series to the previous single patch that I sent a few days
ago so that you will have the whole overview of current (little) improvements
on the Atmel at_hdmac driver.

Thanks, best regards,

Nicolas.

 drivers/dma/at_hdmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index ee7dacd..a4dd4bc 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -253,7 +253,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	/* move myself to free_list */
 	list_move(&desc->desc_node, &atchan->free_list);
 
-	/* unmap dma addresses */
+	/* unmap dma addresses (not on slave channels) */
 	if (!atchan->chan_common.private) {
 		struct device *parent = chan2parent(&atchan->chan_common);
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-- 
1.7.3

