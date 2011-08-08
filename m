Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1HHUfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:35:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54751 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1HHUfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:35:34 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olofj@chromium.org>
Subject: [PATCH v2 1/3] ARM: Tegra: Harmony: Add USB device
Date: Mon,  8 Aug 2011 14:35:13 -0600
Message-Id: <1312835715-893-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1312835715-893-1-git-send-email-swarren@nvidia.com>
References: <1312835715-893-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra USB port is attached an an SMSC9514; a combination USB hub
and Ethernet controller.

This change is extracted from a change in the ChromeOS 2.6.38 kernel.

Signed-off-by: Olof Johansson <olofj@chromium.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: No change

 arch/arm/mach-tegra/board-harmony.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index 846cd7d..f528a5a 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -117,6 +117,7 @@ static struct platform_device *harmony_devices[] __initdata = {
 	&tegra_sdhci_device1,
 	&tegra_sdhci_device2,
 	&tegra_sdhci_device4,
+	&tegra_ehci3_device,
 	&tegra_i2s_device1,
 	&tegra_das_device,
 	&tegra_pcm_device,
@@ -140,6 +141,7 @@ static __initdata struct tegra_clk_init_table harmony_clk_init_table[] = {
 	{ "pll_a_out0",	"pll_a",	11289600,	true },
 	{ "cdev1",	NULL,		0,		true },
 	{ "i2s1",	"pll_a_out0",	11289600,	false},
+	{ "usb3",	"clk_m",	12000000,	true },
 	{ NULL,		NULL,		0,		0},
 };
 
-- 
1.7.0.4

