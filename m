Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2CEQQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:16:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65482 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab2CEQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:16:52 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 02/14] dmaengine: imx-dma: remove data member form internal structure.
Date: Mon,  5 Mar 2012 17:16:24 +0100
Message-Id: <1330964196-32623-3-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used anywhere in the driver.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 28d716c..1a9be6d 100644
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

