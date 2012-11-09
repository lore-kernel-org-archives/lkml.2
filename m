Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2KILqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:46:07 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60310 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2KILqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:46:02 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, patches@linaro.org
Subject: [PATCH 3/8] mmc: sdhci: fix coding style in sdhci_finish_data
Date: Fri,  9 Nov 2012 17:09:53 +0530
Message-Id: <1352461198-21941-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org>
References: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/mmc/host/sdhci.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 2d3d76e..73bb41f 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -924,9 +924,9 @@ static void sdhci_finish_data(struct sdhci_host *host)
 	host->data = NULL;
 
 	if (host->flags & SDHCI_REQ_USE_DMA) {
-		if (host->flags & SDHCI_USE_ADMA)
+		if (host->flags & SDHCI_USE_ADMA) {
 			sdhci_adma_table_post(host, data);
-		else {
+		} else {
 			dma_unmap_sg(mmc_dev(host->mmc), data->sg,
 				data->sg_len, (data->flags & MMC_DATA_READ) ?
 					DMA_FROM_DEVICE : DMA_TO_DEVICE);
@@ -964,8 +964,9 @@ static void sdhci_finish_data(struct sdhci_host *host)
 		}
 
 		sdhci_send_command(host, data->stop);
-	} else
+	} else {
 		tasklet_schedule(&host->finish_tasklet);
+	}
 }
 
 static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
-- 
1.7.4.1

