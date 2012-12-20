Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab2LTJpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:45:41 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17481 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2LTJp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:45:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 20 Dec 2012 01:45:10 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/9] ARM: tegra: fuse: Add chipid TEGRA114 0x35
Date: Thu, 20 Dec 2012 11:43:59 +0200
Message-ID: <1355996654-6579-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tegra_chip_id TEGRA114 0x35

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/fuse.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-tegra/fuse.h b/arch/arm/mach-tegra/fuse.h
index ff1383d..da78434 100644
--- a/arch/arm/mach-tegra/fuse.h
+++ b/arch/arm/mach-tegra/fuse.h
@@ -37,6 +37,7 @@ enum tegra_revision {
 
 #define TEGRA20		0x20
 #define TEGRA30		0x30
+#define TEGRA114	0x35
 
 extern int tegra_sku_id;
 extern int tegra_cpu_process_id;
-- 
1.7.9.5

