Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2IUI4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:56:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11363 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2IUI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:56:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 21 Sep 2012 01:47:12 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 1/5] ARM: tegra: set up wlan clocks for tegra dt
Date: Fri, 21 Sep 2012 16:54:56 +0800
Message-ID: <1348217700-12309-2-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1348217700-12309-1-git-send-email-wni@nvidia.com>
References: <1348217700-12309-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up the wlan clock tree for Tegra20 and Tegra30.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    4 ++++
 arch/arm/mach-tegra/board-dt-tegra30.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index c339444..d24467a 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -103,8 +103,12 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "pll_a",      "pll_p_out1",   56448000,       true },
 	{ "pll_a_out0", "pll_a",        11289600,       true },
 	{ "cdev1",      NULL,           0,              true },
+	{ "blink",      "clk_32k",      32768,          true },
 	{ "i2s1",       "pll_a_out0",   11289600,       false},
 	{ "i2s2",       "pll_a_out0",   11289600,       false},
+	{ "sdmmc1",	"pll_p",	48000000,	false},
+	{ "sdmmc3",	"pll_p",	48000000,	false},
+	{ "sdmmc4",	"pll_p",	48000000,	false},
 	{ NULL,		NULL,		0,		0},
 };
 
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 53bf60f..3277d1e 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -61,11 +61,15 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "pll_a_out0",	"pll_a",	11289600,	true },
 	{ "extern1",	"pll_a_out0",	0,		true },
 	{ "clk_out_1",	"extern1",	0,		true },
+	{ "blink",	"clk_32k",	32768,		true },
 	{ "i2s0",	"pll_a_out0",	11289600,	false},
 	{ "i2s1",	"pll_a_out0",	11289600,	false},
 	{ "i2s2",	"pll_a_out0",	11289600,	false},
 	{ "i2s3",	"pll_a_out0",	11289600,	false},
 	{ "i2s4",	"pll_a_out0",	11289600,	false},
+	{ "sdmmc1",	"pll_p",	48000000,	false},
+	{ "sdmmc3",	"pll_p",	48000000,	false},
+	{ "sdmmc4",	"pll_p",	48000000,	false},
 	{ NULL,		NULL,		0,		0},
 };
 
-- 
1.7.1

