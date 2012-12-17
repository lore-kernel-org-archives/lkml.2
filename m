Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2LQMIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:08:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16211 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2LQMIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:08:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 17 Dec 2012 04:08:35 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/4] ARM: tegra: add connection name for uart clock table
Date: Mon, 17 Dec 2012 17:38:19 +0530
Message-ID: <1355746101-15291-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com>
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add connection name "uart-clk" for the uart clock information.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/tegra20_clocks_data.c |   12 ++++++------
 arch/arm/mach-tegra/tegra30_clocks_data.c |   10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index a23a073..a7f03c7 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -924,12 +924,12 @@ PERIPH_CLK(i2c1,	"tegra-i2c.0",		"div-clk", 12,	0x124,	26000000,  mux_pllp_pllc_
 PERIPH_CLK(i2c2,	"tegra-i2c.1",		"div-clk", 54,	0x198,	26000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U16);
 PERIPH_CLK(i2c3,	"tegra-i2c.2",		"div-clk", 67,	0x1b8,	26000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U16);
 PERIPH_CLK(dvc,		"tegra-i2c.3",		"div-clk", 47,	0x128,	26000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U16);
-PERIPH_CLK(uarta,	"tegra-uart.0",		NULL,	6,	0x178,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
-PERIPH_CLK(uartb,	"tegra-uart.1",		NULL,	7,	0x17c,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
-PERIPH_CLK(uartc,	"tegra-uart.2",		NULL,	55,	0x1a0,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
-PERIPH_CLK(uartd,	"tegra-uart.3",		NULL,	65,	0x1c0,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
-PERIPH_CLK(uarte,	"tegra-uart.4",		NULL,	66,	0x1c4,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
-PERIPH_CLK(3d,		"3d",			NULL,	24,	0x158,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_MANUAL_RESET); /* scales with voltage and process_id */
+PERIPH_CLK(uarta,	"tegra-uart.0",		"uart-clk",	6,	0x178,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
+PERIPH_CLK(uartb,	"tegra-uart.1",		"uart-clk",	7,	0x17c,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
+PERIPH_CLK(uartc,	"tegra-uart.2",		"uart-clk",	55,	0x1a0,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
+PERIPH_CLK(uartd,	"tegra-uart.3",		"uart-clk",	65,	0x1c0,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
+PERIPH_CLK(uarte,	"tegra-uart.4",		"uart-clk",	66,	0x1c4,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
+PERIPH_CLK(3d,		"3d",			"uart-clk",	24,	0x158,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_MANUAL_RESET); /* scales with voltage and process_id */
 PERIPH_CLK(2d,		"2d",			NULL,	21,	0x15c,	300000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71); /* scales with voltage and process_id */
 PERIPH_CLK(vi,		"tegra_camera",		"vi",	20,	0x148,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71); /* scales with voltage and process_id */
 PERIPH_CLK(vi_sensor,	"tegra_camera",		"vi_sensor",	20,	0x1a8,	150000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | PERIPH_NO_RESET); /* scales with voltage and process_id */
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index e2e6022..4edcf60 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1120,11 +1120,11 @@ PERIPH_CLK(i2c2,	"tegra-i2c.1",		"div-clk", 54,	0x198,	26000000,  mux_pllp_clkm,
 PERIPH_CLK(i2c3,	"tegra-i2c.2",		"div-clk", 67,	0x1b8,	26000000,  mux_pllp_clkm,		MUX | DIV_U16 | PERIPH_ON_APB);
 PERIPH_CLK(i2c4,	"tegra-i2c.3",		"div-clk", 103,	0x3c4,	26000000,  mux_pllp_clkm,		MUX | DIV_U16 | PERIPH_ON_APB);
 PERIPH_CLK(i2c5,	"tegra-i2c.4",		"div-clk", 47,	0x128,	26000000,  mux_pllp_clkm,		MUX | DIV_U16 | PERIPH_ON_APB);
-PERIPH_CLK(uarta,	"tegra-uart.0",		NULL,	6,	0x178,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
-PERIPH_CLK(uartb,	"tegra-uart.1",		NULL,	7,	0x17c,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
-PERIPH_CLK(uartc,	"tegra-uart.2",		NULL,	55,	0x1a0,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
-PERIPH_CLK(uartd,	"tegra-uart.3",		NULL,	65,	0x1c0,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
-PERIPH_CLK(uarte,	"tegra-uart.4",		NULL,	66,	0x1c4,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uarta,	"tegra-uart.0",		"uart-clk",	6,	0x178,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uartb,	"tegra-uart.1",		"uart-clk",	7,	0x17c,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uartc,	"tegra-uart.2",		"uart-clk",	55,	0x1a0,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uartd,	"tegra-uart.3",		"uart-clk",	65,	0x1c0,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
+PERIPH_CLK(uarte,	"tegra-uart.4",		"uart-clk",	66,	0x1c4,	800000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U151 | DIV_U151_UART | PERIPH_ON_APB);
 PERIPH_CLK(vi,		"tegra_camera",		"vi",	20,	0x148,	425000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT);
 PERIPH_CLK(3d,		"3d",			NULL,	24,	0x158,	520000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT | DIV_U71_IDLE | PERIPH_MANUAL_RESET);
 PERIPH_CLK(3d2,		"3d2",			NULL,	98,	0x3b0,	520000000, mux_pllm_pllc_pllp_plla,	MUX | DIV_U71 | DIV_U71_INT | DIV_U71_IDLE | PERIPH_MANUAL_RESET);
-- 
1.7.1.1

