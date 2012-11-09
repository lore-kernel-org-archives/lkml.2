Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2KILp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:45:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42166 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KILpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:45:55 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, patches@linaro.org
Subject: [PATCH 1/8] mmc: sdhci: fix coding style in sdhci_calc_timeout
Date: Fri,  9 Nov 2012 17:09:51 +0530
Message-Id: <1352461198-21941-2-git-send-email-tushar.behera@linaro.org>
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
index c7851c0..2ff2b9e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -667,9 +667,9 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 		return 0xE;
 
 	/* timeout in us */
-	if (!data)
+	if (!data) {
 		target_timeout = cmd->cmd_timeout_ms * 1000;
-	else {
+	} else {
 		target_timeout = data->timeout_ns / 1000;
 		if (host->clock)
 			target_timeout += data->timeout_clks / host->clock;
-- 
1.7.4.1

