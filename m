Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2LQGS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:18:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12976 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2LQGS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:18:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 16 Dec 2012 22:16:30 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: [PATCH 3/4] ARM: dt: tegra30.dtsi: Add SCU node
Date: Mon, 17 Dec 2012 08:18:03 +0200
Message-ID: <1355725087-11363-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355725087-11363-1-git-send-email-hdoyu@nvidia.com>
References: <1355725087-11363-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Snoop Control Unit(SCU) node for Cortex A9 MP.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/boot/dts/tegra30.dtsip |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/tegra30.dtsip b/arch/arm/boot/dts/tegra30.dtsip
index 8feba6d..84a41c2 100644
--- a/arch/arm/boot/dts/tegra30.dtsip
+++ b/arch/arm/boot/dts/tegra30.dtsip
@@ -91,6 +91,11 @@
 		};
 	};
 
+	scu {
+		compatible = "arm,cortex-a9-scu";
+		reg = <0x50040000 0x58>;
+	};
+
 	timer@50004600 {
 		compatible = "arm,cortex-a9-twd-timer";
 		reg = <0x50040600 0x20>;
-- 
1.7.9.5

