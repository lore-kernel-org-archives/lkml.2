Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab0LTXRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:17:41 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49662 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192Ab0LTXRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:17:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67624264"
From: Daniel Walker <dwalker@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 4/5] mmc: msm: fix non-tab spacing
Date: Mon, 20 Dec 2010 15:16:50 -0800
Message-Id: <1292887011-30006-4-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
References: <1292887011-30006-1-git-send-email-dwalker@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple lines have non-tab spacing infront of them. Just replace
them with tabs.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index c64a659..3f333b1 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -168,8 +168,8 @@ uint32_t msmsdcc_fifo_addr(struct msmsdcc_host *host)
 
 static inline void
 msmsdcc_start_command_exec(struct msmsdcc_host *host, u32 arg, u32 c) {
-       msmsdcc_writel(host, arg, MMCIARGUMENT);
-       msmsdcc_writel(host, c, MMCICOMMAND);
+	msmsdcc_writel(host, arg, MMCIARGUMENT);
+	msmsdcc_writel(host, c, MMCICOMMAND);
 }
 
 static void
@@ -305,7 +305,7 @@ static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
 	host->dma.sg = data->sg;
 	host->dma.num_ents = data->sg_len;
 
-       BUG_ON(host->dma.num_ents > NR_SG); /* Prevent memory corruption */
+	BUG_ON(host->dma.num_ents > NR_SG); /* Prevent memory corruption */
 
 	nc = host->dma.nc;
 
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
