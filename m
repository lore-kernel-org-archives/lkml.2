Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3ADJrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:47:18 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3600 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3ADJrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:47:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Jan 2013 01:47:04 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 4/7] arm: tegra20: remove auxdata
Date: Fri, 4 Jan 2013 15:16:40 +0530
Message-ID: <1357292803-28604-4-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
References: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove AUXDATA as clock are initialized from device node.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index c774a80..2b5fed7 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -70,36 +70,12 @@ struct tegra_ehci_platform_data tegra_ehci3_pdata = {
 };
 
 struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC3_BASE, "sdhci-tegra.2", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC4_BASE, "sdhci-tegra.3", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C_BASE, "tegra-i2c.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C2_BASE, "tegra-i2c.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C3_BASE, "tegra-i2c.2", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2c-dvc", TEGRA_DVC_BASE, "tegra-i2c.3", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra20-i2s.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S2_BASE, "tegra20-i2s.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-das", TEGRA_APB_MISC_DAS_BASE, "tegra20-das", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB_BASE, "tegra-ehci.0",
 		       &tegra_ehci1_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB2_BASE, "tegra-ehci.1",
 		       &tegra_ehci2_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB3_BASE, "tegra-ehci.2",
 		       &tegra_ehci3_pdata),
-	OF_DEV_AUXDATA("nvidia,tegra20-apbdma", TEGRA_APB_DMA_BASE, "tegra-apbdma", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-sflash", 0x7000c380, "spi", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D400, "spi_tegra.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D600, "spi_tegra.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D800, "spi_tegra.2", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000DA00, "spi_tegra.3", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-host1x", 0x50000000, "host1x", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54200000, "tegradc.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54240000, "tegradc.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-hdmi", 0x54280000, "hdmi", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-dsi", 0x54300000, "dsi", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra20-tvo", 0x542c0000, "tvo", NULL),
 	{}
 };
 
-- 
1.7.4.1

