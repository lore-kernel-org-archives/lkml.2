Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3ADJrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:47:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3610 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3ADJr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:47:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Jan 2013 01:47:16 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 7/7] clk: tegra30: remove unused TEGRA_CLK_DUPLICATE()s
Date: Fri, 4 Jan 2013 15:16:43 +0530
Message-ID: <1357292803-28604-7-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
References: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With device tree support added for Tegra clocks look up is done from
device tree, remove unused TEGRA_CLK_DUPLICATE()s.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/clk/tegra/clk-tegra30.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 2b3b4f7..57db77d 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1932,18 +1932,9 @@ static __initdata struct tegra_clk_init_table init_table[] = {
  * table under two names.
  */
 static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
-	TEGRA_CLK_DUPLICATE(uarta,  "serial8250.0", NULL),
-	TEGRA_CLK_DUPLICATE(uartb,  "serial8250.1", NULL),
-	TEGRA_CLK_DUPLICATE(uartc,  "serial8250.2", NULL),
-	TEGRA_CLK_DUPLICATE(uartd,  "serial8250.3", NULL),
-	TEGRA_CLK_DUPLICATE(uarte,  "serial8250.4", NULL),
 	TEGRA_CLK_DUPLICATE(usbd, "utmip-pad", NULL),
 	TEGRA_CLK_DUPLICATE(usbd, "tegra-ehci.0", NULL),
 	TEGRA_CLK_DUPLICATE(usbd, "tegra-otg", NULL),
-	TEGRA_CLK_DUPLICATE(hdmi, "tegradc.0", "hdmi"),
-	TEGRA_CLK_DUPLICATE(hdmi, "tegradc.1", "hdmi"),
-	TEGRA_CLK_DUPLICATE(dsib, "tegradc.0", "dsib"),
-	TEGRA_CLK_DUPLICATE(dsia, "tegradc.1", "dsia"),
 	TEGRA_CLK_DUPLICATE(bsev, "tegra-avp", "bsev"),
 	TEGRA_CLK_DUPLICATE(bsev, "nvavp", "bsev"),
 	TEGRA_CLK_DUPLICATE(vde, "tegra-aes", "vde"),
@@ -1952,33 +1943,8 @@ static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
 	TEGRA_CLK_DUPLICATE(cml1, "tegra_sata_cml", NULL),
 	TEGRA_CLK_DUPLICATE(cml0, "tegra_pcie", "cml"),
 	TEGRA_CLK_DUPLICATE(pciex, "tegra_pcie", "pciex"),
-	TEGRA_CLK_DUPLICATE(i2c1, "tegra-i2c-slave.0", NULL),
-	TEGRA_CLK_DUPLICATE(i2c2, "tegra-i2c-slave.1", NULL),
-	TEGRA_CLK_DUPLICATE(i2c3, "tegra-i2c-slave.2", NULL),
-	TEGRA_CLK_DUPLICATE(i2c4, "tegra-i2c-slave.3", NULL),
-	TEGRA_CLK_DUPLICATE(i2c5, "tegra-i2c-slave.4", NULL),
-	TEGRA_CLK_DUPLICATE(sbc1, "spi_slave_tegra.0", NULL),
-	TEGRA_CLK_DUPLICATE(sbc2, "spi_slave_tegra.1", NULL),
-	TEGRA_CLK_DUPLICATE(sbc3, "spi_slave_tegra.2", NULL),
-	TEGRA_CLK_DUPLICATE(sbc4, "spi_slave_tegra.3", NULL),
-	TEGRA_CLK_DUPLICATE(sbc5, "spi_slave_tegra.4", NULL),
-	TEGRA_CLK_DUPLICATE(sbc6, "spi_slave_tegra.5", NULL),
 	TEGRA_CLK_DUPLICATE(twd, "smp_twd", NULL),
 	TEGRA_CLK_DUPLICATE(vcp, "nvavp", "vcp"),
-	TEGRA_CLK_DUPLICATE(i2s0, NULL, "i2s0"),
-	TEGRA_CLK_DUPLICATE(i2s1, NULL, "i2s1"),
-	TEGRA_CLK_DUPLICATE(i2s2, NULL, "i2s2"),
-	TEGRA_CLK_DUPLICATE(i2s3, NULL, "i2s3"),
-	TEGRA_CLK_DUPLICATE(i2s4, NULL, "i2s4"),
-	TEGRA_CLK_DUPLICATE(dam0, NULL, "dam0"),
-	TEGRA_CLK_DUPLICATE(dam1, NULL, "dam1"),
-	TEGRA_CLK_DUPLICATE(dam2, NULL, "dam2"),
-	TEGRA_CLK_DUPLICATE(spdif_in, NULL, "spdif_in"),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.0", "fast-clk"),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.1", "fast-clk"),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.2", "fast-clk"),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.3", "fast-clk"),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.4", "fast-clk"),
 	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* MUST be the last entry */
 };
 
-- 
1.7.4.1

