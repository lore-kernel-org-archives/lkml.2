Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab1LHIQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:16:02 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:65484 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1LHIQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:16:00 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Huang Shijie <b32955@freescale.com>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/4] dma: mxs-dma: fix a typo in comment
Date: Thu,  8 Dec 2011 09:15:41 +0100
Message-Id: <95cce41674a2ad03ecd55190ec184eab0069fe3a.1323176362.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1323176362.git.LW@KARO-electronics.de>
References: <cover.1323176362.git.LW@KARO-electronics.de>
In-Reply-To: <cover.1323176362.git.LW@KARO-electronics.de>
References: <cover.1323176362.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/dma/mxs-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index b4588bd..f228f55 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -268,7 +268,7 @@ static irqreturn_t mxs_dma_int_handler(int irq, void *dev_id)
 	/*
 	 * When both completion and error of termination bits set at the
 	 * same time, we do not take it as an error.  IOW, it only becomes
-	 * an error we need to handler here in case of ether it's (1) an bus
+	 * an error we need to handle here in case of either it's (1) a bus
 	 * error or (2) a termination error with no completion.
 	 */
 	stat2 = ((stat2 >> MXS_DMA_CHANNELS) & stat2) | /* (1) */
-- 
1.5.6.5

