Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2KILrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:47:53 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60310 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2KILp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:45:58 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, patches@linaro.org
Subject: [PATCH 2/8] mmc: sdhci: fix coding style in sdhci_set_transfer_mode
Date: Fri,  9 Nov 2012 17:09:52 +0530
Message-Id: <1352461198-21941-3-git-send-email-tushar.behera@linaro.org>
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
index 2ff2b9e..2d3d76e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -898,9 +898,9 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
 		 * If we are sending CMD23, CMD12 never gets sent
 		 * on successful completion (so no Auto-CMD12).
 		 */
-		if (!host->mrq->sbc && (host->flags & SDHCI_AUTO_CMD12))
+		if (!host->mrq->sbc && (host->flags & SDHCI_AUTO_CMD12)) {
 			mode |= SDHCI_TRNS_AUTO_CMD12;
-		else if (host->mrq->sbc && (host->flags & SDHCI_AUTO_CMD23)) {
+		} else if (host->mrq->sbc && (host->flags & SDHCI_AUTO_CMD23)) {
 			mode |= SDHCI_TRNS_AUTO_CMD23;
 			sdhci_writel(host, host->mrq->sbc->arg, SDHCI_ARGUMENT2);
 		}
-- 
1.7.4.1

