Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3ADJr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:47:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3608 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3ADJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:47:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Jan 2013 01:43:08 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 6/7] clk: tegra20: remove unused TEGRA_CLK_DUPLICATE()s
Date: Fri, 4 Jan 2013 15:16:42 +0530
Message-ID: <1357292803-28604-6-git-send-email-pgaikwad@nvidia.com>
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
 drivers/clk/tegra/clk-tegra20.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index bb94556..92c1190 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1164,28 +1164,11 @@ static __initdata struct tegra_clk_init_table init_table[] = {
  * table under two names.
  */
 static struct tegra_clk_duplicate tegra_clk_duplicates[] = {
-	TEGRA_CLK_DUPLICATE(uarta,  "serial8250.0", NULL),
-	TEGRA_CLK_DUPLICATE(uartb,  "serial8250.1", NULL),
-	TEGRA_CLK_DUPLICATE(uartc,  "serial8250.2", NULL),
-	TEGRA_CLK_DUPLICATE(uartd,  "serial8250.3", NULL),
-	TEGRA_CLK_DUPLICATE(uarte,  "serial8250.4", NULL),
 	TEGRA_CLK_DUPLICATE(usbd,   "utmip-pad",    NULL),
 	TEGRA_CLK_DUPLICATE(usbd,   "tegra-ehci.0", NULL),
 	TEGRA_CLK_DUPLICATE(usbd,   "tegra-otg",    NULL),
-	TEGRA_CLK_DUPLICATE(hdmi,   "tegradc.0",    "hdmi"),
-	TEGRA_CLK_DUPLICATE(hdmi,   "tegradc.1",    "hdmi"),
-	TEGRA_CLK_DUPLICATE(host1x, "tegra_grhost", "host1x"),
-	TEGRA_CLK_DUPLICATE(gr2d,   "tegra_grhost", "gr2d"),
-	TEGRA_CLK_DUPLICATE(gr3d,   "tegra_grhost", "gr3d"),
-	TEGRA_CLK_DUPLICATE(epp,    "tegra_grhost", "epp"),
-	TEGRA_CLK_DUPLICATE(mpe,    "tegra_grhost", "mpe"),
-	TEGRA_CLK_DUPLICATE(vde,    "tegra-aes",    "vde"),
 	TEGRA_CLK_DUPLICATE(cclk,   NULL,           "cpu"),
 	TEGRA_CLK_DUPLICATE(twd,    "smp_twd",      NULL),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.0", "fast-clk"),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.1", "fast-clk"),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.2", "fast-clk"),
-	TEGRA_CLK_DUPLICATE(pll_p_out3, "tegra-i2c.3", "fast-clk"),
 	TEGRA_CLK_DUPLICATE(clk_max, NULL, NULL), /* Must be the last entry */
 };
 
-- 
1.7.4.1

