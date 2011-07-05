Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1GEU3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:29:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55320 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1GEU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:29:32 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/3] mmc/tegra: Use engineering names in DT compatible property
Date: Tue,  5 Jul 2011 14:29:20 -0600
Message-Id: <1309897762-23564-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1309897762-23564-1-git-send-email-swarren@nvidia.com>
References: <1309897762-23564-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Engineering names are more stable than marketing names. Hence, use them
for Device Tree compatible properties instead.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/mmc/host/sdhci-pltfm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 9cc92b0..0cf16bb 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -52,7 +52,7 @@ static struct sdhci_ops sdhci_pltfm_ops = {
 #if defined(CONFIG_OF)
 #include <linux/of_device.h>
 static const struct of_device_id sdhci_dt_ids[] = {
-	{ .compatible = "nvidia,tegra250-sdhci", .data = &sdhci_tegra_dt_pdata },
+	{ .compatible = "nvidia,tegra20-sdhci", .data = &sdhci_tegra_dt_pdata },
 	{ }
 };
 MODULE_DEVICE_TABLE(platform, sdhci_dt_ids);
-- 
1.7.0.4

