Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab2K0G7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:59:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1229 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab2K0G7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:59:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 26 Nov 2012 22:59:34 -0800
From: Sivaram Nair <sivaramn@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Sivaram Nair <sivaramn@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: remove unused functions in mach/clk.h
Date: Tue, 27 Nov 2012 08:59:12 +0200
Message-ID: <1353999553-5196-1-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleaning up patch that removes couple of functions in
mach/clk.h that are no longer used and does not have any body.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/clk.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index 95f3a54..64d2657 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -34,11 +34,6 @@ enum tegra_clk_ex_param {
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
 
-#ifndef CONFIG_COMMON_CLK
-unsigned long clk_get_rate_all_locked(struct clk *c);
-#endif
-
-void tegra2_sdmmc_tap_delay(struct clk *c, int delay);
 int tegra_clk_cfg_ex(struct clk *c, enum tegra_clk_ex_param p, u32 setting);
 
 #endif
-- 
1.7.9.5

