Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab0LTXRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:17:53 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10808 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab0LTXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:17:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67414638"
From: Daniel Walker <dwalker@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 5/5] mmc: msm: fix weird spacing
Date: Mon, 20 Dec 2010 15:16:51 -0800
Message-Id: <1292887011-30006-5-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
References: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strange spacing and formatting fixes.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 3f333b1..c5d1d6a 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -339,12 +339,12 @@ static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
 	for (i = 0; i < host->dma.num_ents; i++) {
 		box->cmd = CMD_MODE_BOX;
 
-	/* Initialize sg dma address */
-	sg->dma_address = page_to_dma(mmc_dev(host->mmc), sg_page(sg))
-				+ sg->offset;
+		/* Initialize sg dma address */
+		sg->dma_address = page_to_dma(mmc_dev(host->mmc), sg_page(sg))
+					+ sg->offset;
 
-	if (i == (host->dma.num_ents - 1))
-			box->cmd |= CMD_LC;
+		if (i == (host->dma.num_ents - 1))
+				box->cmd |= CMD_LC;
 		rows = (sg_dma_len(sg) % MCI_FIFOSIZE) ?
 			(sg_dma_len(sg) / MCI_FIFOSIZE) + 1 :
 			(sg_dma_len(sg) / MCI_FIFOSIZE) ;
@@ -479,7 +479,7 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data,
 
 	clks = (unsigned long long)data->timeout_ns * host->clk_rate;
 	do_div(clks, NSEC_PER_SEC);
-	timeout = data->timeout_clks + (unsigned int)clks*2 ;
+	timeout = data->timeout_clks + (unsigned int)clks*2;
 
 	if (datactrl & MCI_DPSM_DMAENABLE) {
 		/* Save parameters for the exec function */
@@ -563,7 +563,7 @@ msmsdcc_pio_read(struct msmsdcc_host *host, char *buffer, unsigned int remain)
 		ptr++;
 		count += sizeof(uint32_t);
 
-		remain -=  sizeof(uint32_t);
+		remain -= sizeof(uint32_t);
 		if (remain == 0)
 			break;
 	}
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
