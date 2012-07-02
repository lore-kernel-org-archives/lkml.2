Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab2GBI0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:26:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13518 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab2GBI0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:26:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 02 Jul 2012 01:26:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] dma: tegra: rename driver and compatible to match with dts
Date: Mon, 2 Jul 2012 13:52:08 +0530
Message-ID: <1341217328-6676-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com>
References: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the compatible name and driver name to match with
tegra dts file and as per clock driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index c0836a7..340c617 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1177,10 +1177,10 @@ static struct tegra_dma_chip_data tegra30_dma_chip_data = {
 
 static const struct of_device_id tegra_dma_of_match[] __devinitconst = {
 	{
-		.compatible = "nvidia,tegra30-apbdma-new",
+		.compatible = "nvidia,tegra30-apbdma",
 		.data = &tegra30_dma_chip_data,
 	}, {
-		.compatible = "nvidia,tegra20-apbdma-new",
+		.compatible = "nvidia,tegra20-apbdma",
 		.data = &tegra20_dma_chip_data,
 	}, {
 	},
@@ -1395,7 +1395,7 @@ static const struct dev_pm_ops tegra_dma_dev_pm_ops __devinitconst = {
 
 static struct platform_driver tegra_dmac_driver = {
 	.driver = {
-		.name	= "tegra20-apbdma",
+		.name	= "tegra-apbdma",
 		.owner = THIS_MODULE,
 		.pm	= &tegra_dma_dev_pm_ops,
 		.of_match_table = of_match_ptr(tegra_dma_of_match),
-- 
1.7.1.1

