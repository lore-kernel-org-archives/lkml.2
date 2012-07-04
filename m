Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2GDJhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:37:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1094 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2GDJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:37:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jul 2012 02:36:39 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@nvidia.com>, <olof@lixom.net>, <ccross@android.com>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <arnd@arndb.de>, <grant.likely@secretlab.ca>,
        <cjb@laptop.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 1/5] ARM: tegra: set up wlan clocks for tegra dt
Date: Wed, 4 Jul 2012 17:34:44 +0800
Message-ID: <1341394488-13169-2-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1341394488-13169-1-git-send-email-wni@nvidia.com>
References: <1341394488-13169-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up the wlan clock tree for Tegra20 and Tegra30.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    1 +
 arch/arm/mach-tegra/board-dt-tegra30.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 70a19a9..fbcc7d9 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -78,6 +78,7 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "pll_a",      "pll_p_out1",   56448000,       true },
 	{ "pll_a_out0", "pll_a",        11289600,       true },
 	{ "cdev1",      NULL,           0,              true },
+	{ "blink",      "clk_32k",      32768,          true },
 	{ "i2s1",       "pll_a_out0",   11289600,       false},
 	{ "i2s2",       "pll_a_out0",   11289600,       false},
 	{ NULL,		NULL,		0,		0},
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 53bf60f..2d73c61 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -61,6 +61,7 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "pll_a_out0",	"pll_a",	11289600,	true },
 	{ "extern1",	"pll_a_out0",	0,		true },
 	{ "clk_out_1",	"extern1",	0,		true },
+	{ "blink",	"clk_32k",	32768,		true },
 	{ "i2s0",	"pll_a_out0",	11289600,	false},
 	{ "i2s1",	"pll_a_out0",	11289600,	false},
 	{ "i2s2",	"pll_a_out0",	11289600,	false},
-- 
1.7.1

