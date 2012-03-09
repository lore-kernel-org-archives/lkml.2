Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab2CIPVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:21:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40204 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab2CIPVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:21:10 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3 02/13] dmaengine: imx-dma: remove data member from internal structure.
Date: Fri,  9 Mar 2012 16:20:38 +0100
Message-Id: <1331306449-28591-3-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Internal structure is just an auxiliary structure used for the initial
merge which is meant to be gone. As data member is not use anywhere
we can simply remove it.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index a34de17..a5bb9bd 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -132,7 +132,6 @@ enum  imxdma_prep_type {
  */
 
 struct imxdma_channel_internal {
-	void *data;
 	unsigned int dma_mode;
 	struct scatterlist *sg;
 	unsigned int resbytes;
-- 
1.7.0.4

