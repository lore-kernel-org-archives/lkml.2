Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab2KILqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:46:17 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42166 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2KILqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:46:12 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, patches@linaro.org
Subject: [PATCH 6/8] mmc: sdhci: fix coding style in sdhci_execute_tuning
Date: Fri,  9 Nov 2012 17:09:56 +0530
Message-Id: <1352461198-21941-7-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org>
References: <1352461198-21941-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/mmc/host/sdhci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index b947155..4bed582 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1792,9 +1792,9 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		requires_tuning_nonuhs = true;
 
 	if (((ctrl & SDHCI_CTRL_UHS_MASK) == SDHCI_CTRL_UHS_SDR104) ||
-	    requires_tuning_nonuhs)
+	    requires_tuning_nonuhs) {
 		ctrl |= SDHCI_CTRL_EXEC_TUNING;
-	else {
+	} else {
 		spin_unlock(&host->lock);
 		enable_irq(host->irq);
 		sdhci_runtime_pm_put(host);
-- 
1.7.4.1

