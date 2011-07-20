Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1GTTmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:42:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19240 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab1GTTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:41:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Jul 2011 12:41:35 -0700
From: <achew@nvidia.com>
To: <grant.likely@secretlab.ca>, <olof@lixom.net>, <swarren@nvidia.com>,
        <dwillemsen@nvidia.com>, <rklein@nvidia.com>, <mogantyv@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH 2/3 v2] dt: tegra20: Add ehci host controller nodes.
Date: Wed, 20 Jul 2011 12:38:09 -0700
Message-ID: <1311190690-18334-2-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311190690-18334-1-git-send-email-achew@nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Chew <achew@nvidia.com>

These values were derived from various headers in arch/arm/mach-tegra.

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 arch/arm/boot/dts/tegra20.dtsi |   43 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 83fedf3..d4ab1ab 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -160,5 +160,48 @@
 		interrupts = < 63 >;
 		status = "disabled";
 	};
+
+	ehci@c5000000 {
+		compatible = "nvidia,tegra20-ehci";
+		reg = <0xc5000000 0x4000>;
+		interrupts = < 52 >;
+		mode = "host";
+		power_down_on_bus_suspend = < 1 >;
+		type = "utmi";
+		hssync_start_delay = < 9 >;
+		idle_wait_delay = < 17 >;
+		elastic_limit = < 16 >;
+		term_range_adj = < 6 >;
+		xcvr_setup = < 9 >;
+		xcvr_lsfslew = < 1 >;
+		xcvr_lsrslew = < 1 >;
+	};
+
+	ehci@c5004000 {
+		compatible = "nvidia,tegra20-ehci";
+		reg = <0xc5004000 0x4000>;
+		interrupts = < 53 >;
+		mode = "host";
+		power_down_on_bus_suspend = < 1 >;
+		type = "ulpi";
+		reset_gpio = < 169 >;
+		clk = "cdev2";
+	};
+
+	ehci@c5008000 {
+		compatible = "nvidia,tegra20-ehci";
+		reg = <0xc5008000 0x4000>;
+		interrupts = < 129 >;
+		mode = "host";
+		power_down_on_bus_suspend = < 1 >;
+		type = "utmi";
+		hssync_start_delay = < 9 >;
+		idle_wait_delay = < 17 >;
+		elastic_limit = < 16 >;
+		term_range_adj = < 6 >;
+		xcvr_setup = < 9 >;
+		xcvr_lsfslew = < 2 >;
+		xcvr_lsrslew = < 2 >;
+	};
 };
 
-- 
1.7.6

