Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2EJH5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:57:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19144 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab2EJH5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:57:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 10 May 2012 00:43:25 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] ARM: dt: tegra30.dtsi: Add Memory Controller(MC) nodes
Date: Thu, 10 May 2012 10:42:33 +0300
Message-ID: <1336635764-30597-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
References: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Tegra MC(Memory Controller) nodes for tegra30.dtsi.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/boot/dts/tegra30.dtsi |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 9d650fb..167ccbc 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -229,4 +229,13 @@
 		compatible = "nvidia,tegra30-ahb";
 		reg = <0x6000c004 0x14c>; /* AHB Arbitration + Gizmo Controller */
 	};
+
+	mc {
+		compatible = "nvidia,tegra30-mc";
+		reg = <0x7000f000 0x010
+		       0x7000f03c 0x1b4
+		       0x7000f200 0x028
+		       0x7000f284 0x17c>;
+		interrupts = <0 77 0x04>;
+	};
 };
-- 
1.7.5.4

