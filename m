Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab2INJ0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:26:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2719 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675Ab2INJ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:26:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 14 Sep 2012 02:18:02 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] arm: tegra: dt: Add pinmux entries for Vbus regulator controls
Date: Fri, 14 Sep 2012 14:55:54 +0530
Message-ID: <1347614754-26357-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding pinmux entries for PI4 and PH7 to enable Vbus for USB1
and USB3 controllers on Cardhu A02 board.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---

 arch/arm/boot/dts/tegra30-cardhu-a02.dts |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu-a02.dts b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
index dd4222f..b76ad31 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a02.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
@@ -8,6 +8,26 @@
 	model = "NVIDIA Tegra30 Cardhu A02 evaluation board";
 	compatible = "nvidia,cardhu-a02", "nvidia,cardhu", "nvidia,tegra30";
 
+	pinmux {
+		gmi_rst_n_pi4 {
+			nvidia,pins = "gmi_rst_n_pi4";
+			nvidia,function = "gmi";
+			nvidia,tristate = <0>;
+			nvidia,enable-input = <1>;
+			nvidia,open-drain = <1>;
+			nvidia,pull = <0>;
+		};
+
+		gmi_ad15_ph7 {
+			nvidia,pins = "gmi_ad15_ph7";
+			nvidia,function = "gmi";
+			nvidia,tristate = <0>;
+			nvidia,enable-input = <1>;
+			nvidia,open-drain = <1>;
+			nvidia,pull = <0>;
+		};
+	};
+
 	regulators {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
1.7.1.1

