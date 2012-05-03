Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab2ECQGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:06:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3284 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2ECQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:06:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 May 2012 09:06:35 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Glass <sjg@chromium.org>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 4/4] ARM: dt: tegra: Add device tree support for AHB
Date: Thu,  3 May 2012 19:05:45 +0300
Message-Id: <1336061147-10245-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com>
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AHB entry for tegra20/30.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi |    5 +++++
 arch/arm/boot/dts/tegra30.dtsi |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 52cab08..ea6de57 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -212,5 +212,10 @@
 		reg = < 0x7000f000 0x00000100    /* controller registers */
 		        0x58000000 0x02000000 >; /* GART aperture */
 	};
+
+	ahb: ahb@6000c004 {
+		compatible = "nvidia,tegra20-ahb";
+		reg = <0x6000c004 0x10c>; /* AHB Arbitration + Gizmo Controller */
+	};
 };
 
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 15200a9..9d650fb 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -224,4 +224,9 @@
 			nvidia,ahub-cif-ids = <8 8>;
 		};
 	};
+
+	ahb: ahb@6000c004 {
+		compatible = "nvidia,tegra30-ahb";
+		reg = <0x6000c004 0x14c>; /* AHB Arbitration + Gizmo Controller */
+	};
 };
-- 
1.7.5.4

