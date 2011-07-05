Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab1GEUSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:18:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40991 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1GEUSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:18:11 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] spi/tegra: Use engineering names in DT compatible property
Date: Tue,  5 Jul 2011 14:18:02 -0600
Message-Id: <1309897082-22695-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Engineering names are more stable than marketing names. Hence, use them
for Device Tree compatible properties instead.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Grant, this is against devicetree/arm, and also makes sense for
devicetree/test.

 .../devicetree/bindings/spi/spi_nvidia.txt         |    2 +-
 drivers/spi/spi_tegra.c                            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi_nvidia.txt b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
index bde450b..6b9e518 100644
--- a/Documentation/devicetree/bindings/spi/spi_nvidia.txt
+++ b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
@@ -1,5 +1,5 @@
 NVIDIA Tegra 2 SPI device
 
 Required properties:
-- compatible : should be "nvidia,tegra250-spi".
+- compatible : should be "nvidia,tegra20-spi".
 - gpios : should specify GPIOs used for chipselect.
diff --git a/drivers/spi/spi_tegra.c b/drivers/spi/spi_tegra.c
index 1e7de98..b0e3586 100644
--- a/drivers/spi/spi_tegra.c
+++ b/drivers/spi/spi_tegra.c
@@ -598,7 +598,7 @@ MODULE_ALIAS("platform:spi_tegra");
 
 #ifdef CONFIG_OF
 static struct of_device_id spi_tegra_of_match_table[] __devinitdata = {
-	{ .compatible = "nvidia,tegra250-spi", },
+	{ .compatible = "nvidia,tegra20-spi", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, spi_tegra_of_match_table);
-- 
1.7.0.4

