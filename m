Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2FKPLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:11:30 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:58562 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755282Ab2FKPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:11:28 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ARM: Fix dts files w/ status property: "disable" -> "disabled"
Date: Mon, 11 Jun 2012 17:11:00 +0200
Message-Id: <1339427460-23007-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes some status = "disable" strings to "disabled", the correct
way of disabling nodes in the devicetree.

lpc32xx.dtsi is fixed separately in the LPC32xx patch set due to the many
changes there.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.5-rc2

 arch/arm/boot/dts/omap3-beagle.dts |    4 +--
 arch/arm/boot/dts/omap4-panda.dts  |    6 ++---
 arch/arm/boot/dts/omap4-sdp.dts    |    4 +--
 arch/arm/boot/dts/tegra20.dtsi     |   36 +++++++++++++++++------------------
 arch/arm/boot/dts/tegra30.dtsi     |   38 ++++++++++++++++++-------------------
 5 files changed, 44 insertions(+), 44 deletions(-)

--- linux-2.6.orig/arch/arm/boot/dts/omap3-beagle.dts
+++ linux-2.6/arch/arm/boot/dts/omap3-beagle.dts
@@ -61,9 +61,9 @@
 };
 
 &mmc2 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc3 {
-	status = "disable";
+	status = "disabled";
 };
--- linux-2.6.orig/arch/arm/boot/dts/omap4-panda.dts
+++ linux-2.6/arch/arm/boot/dts/omap4-panda.dts
@@ -74,15 +74,15 @@
 };
 
 &mmc2 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc3 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc4 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc5 {
--- linux-2.6.orig/arch/arm/boot/dts/omap4-sdp.dts
+++ linux-2.6/arch/arm/boot/dts/omap4-sdp.dts
@@ -147,11 +147,11 @@
 };
 
 &mmc3 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc4 {
-	status = "disable";
+	status = "disabled";
 };
 
 &mmc5 {
--- linux-2.6.orig/arch/arm/boot/dts/tegra20.dtsi
+++ linux-2.6/arch/arm/boot/dts/tegra20.dtsi
@@ -72,7 +72,7 @@
 		reg = <0x70002800 0x200>;
 		interrupts = <0 13 0x04>;
 		nvidia,dma-request-selector = <&apbdma 2>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	tegra_i2s2: i2s@70002a00 {
@@ -80,7 +80,7 @@
 		reg = <0x70002a00 0x200>;
 		interrupts = <0 3 0x04>;
 		nvidia,dma-request-selector = <&apbdma 1>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006000 {
@@ -88,7 +88,7 @@
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 36 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006040 {
@@ -96,7 +96,7 @@
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 37 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006200 {
@@ -104,7 +104,7 @@
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 46 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006300 {
@@ -112,7 +112,7 @@
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 90 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006400 {
@@ -120,7 +120,7 @@
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 91 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000c000 {
@@ -129,7 +129,7 @@
 		interrupts = <0 38 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000c400 {
@@ -138,7 +138,7 @@
 		interrupts = <0 84 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000c500 {
@@ -147,7 +147,7 @@
 		interrupts = <0 92 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000d000 {
@@ -156,7 +156,7 @@
 		interrupts = <0 53 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	pmc {
@@ -190,7 +190,7 @@
 		interrupts = <0 20 0x04>;
 		phy_type = "utmi";
 		nvidia,has-legacy-mode;
-		status = "disable";
+		status = "disabled";
 	};
 
 	usb@c5004000 {
@@ -198,7 +198,7 @@
 		reg = <0xc5004000 0x4000>;
 		interrupts = <0 21 0x04>;
 		phy_type = "ulpi";
-		status = "disable";
+		status = "disabled";
 	};
 
 	usb@c5008000 {
@@ -206,35 +206,35 @@
 		reg = <0xc5008000 0x4000>;
 		interrupts = <0 97 0x04>;
 		phy_type = "utmi";
-		status = "disable";
+		status = "disabled";
 	};
 
 	sdhci@c8000000 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000000 0x200>;
 		interrupts = <0 14 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	sdhci@c8000200 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000200 0x200>;
 		interrupts = <0 15 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	sdhci@c8000400 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000400 0x200>;
 		interrupts = <0 19 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	sdhci@c8000600 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000600 0x200>;
 		interrupts = <0 31 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	pmu {
--- linux-2.6.orig/arch/arm/boot/dts/tegra30.dtsi
+++ linux-2.6/arch/arm/boot/dts/tegra30.dtsi
@@ -82,7 +82,7 @@
 		reg = <0x70006000 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 36 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006040 {
@@ -90,7 +90,7 @@
 		reg = <0x70006040 0x40>;
 		reg-shift = <2>;
 		interrupts = <0 37 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006200 {
@@ -98,7 +98,7 @@
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 46 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006300 {
@@ -106,7 +106,7 @@
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 90 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	serial@70006400 {
@@ -114,7 +114,7 @@
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
 		interrupts = <0 91 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000c000 {
@@ -123,7 +123,7 @@
 		interrupts = <0 38 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000c400 {
@@ -132,7 +132,7 @@
 		interrupts = <0 84 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000c500 {
@@ -141,7 +141,7 @@
 		interrupts = <0 92 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000c700 {
@@ -150,7 +150,7 @@
 		interrupts = <0 120 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	i2c@7000d000 {
@@ -159,7 +159,7 @@
 		interrupts = <0 53 0x04>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	pmc {
@@ -201,35 +201,35 @@
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080300 0x100>;
 			nvidia,ahub-cif-ids = <4 4>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		tegra_i2s1: i2s@70080400 {
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080400 0x100>;
 			nvidia,ahub-cif-ids = <5 5>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		tegra_i2s2: i2s@70080500 {
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080500 0x100>;
 			nvidia,ahub-cif-ids = <6 6>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		tegra_i2s3: i2s@70080600 {
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080600 0x100>;
 			nvidia,ahub-cif-ids = <7 7>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		tegra_i2s4: i2s@70080700 {
 			compatible = "nvidia,tegra30-i2s";
 			reg = <0x70080700 0x100>;
 			nvidia,ahub-cif-ids = <8 8>;
-			status = "disable";
+			status = "disabled";
 		};
 	};
 
@@ -237,28 +237,28 @@
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000000 0x200>;
 		interrupts = <0 14 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	sdhci@78000200 {
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000200 0x200>;
 		interrupts = <0 15 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	sdhci@78000400 {
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000400 0x200>;
 		interrupts = <0 19 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	sdhci@78000600 {
 		compatible = "nvidia,tegra30-sdhci", "nvidia,tegra20-sdhci";
 		reg = <0x78000600 0x200>;
 		interrupts = <0 31 0x04>;
-		status = "disable";
+		status = "disabled";
 	};
 
 	pmu {
