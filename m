Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3ADJrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:47:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3596 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3ADJrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:47:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 04 Jan 2013 01:44:19 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 2/7] ARM: dt: tegra30: Add clock information
Date: Fri, 4 Jan 2013 15:16:38 +0530
Message-ID: <1357292803-28604-2-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
References: <1357292803-28604-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock information to device nodes.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 arch/arm/boot/dts/tegra30.dtsi |   52 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index e254d59..758962e 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -17,6 +17,7 @@
 		reg = <0x50000000 0x00024000>;
 		interrupts = <0 65 0x04   /* mpcore syncpt */
 			      0 67 0x04>; /* mpcore general */
+		clocks = <&tegra_car 28>;
 
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -27,41 +28,48 @@
 			compatible = "nvidia,tegra30-mpe";
 			reg = <0x54040000 0x00040000>;
 			interrupts = <0 68 0x04>;
+			clocks = <&tegra_car 60>;
 		};
 
 		vi {
 			compatible = "nvidia,tegra30-vi";
 			reg = <0x54080000 0x00040000>;
 			interrupts = <0 69 0x04>;
+			clocks = <&tegra_car 164>;
 		};
 
 		epp {
 			compatible = "nvidia,tegra30-epp";
 			reg = <0x540c0000 0x00040000>;
 			interrupts = <0 70 0x04>;
+			clocks = <&tegra_car 19>;
 		};
 
 		isp {
 			compatible = "nvidia,tegra30-isp";
 			reg = <0x54100000 0x00040000>;
 			interrupts = <0 71 0x04>;
+			clocks = <&tegra_car 23>;
 		};
 
 		gr2d {
 			compatible = "nvidia,tegra30-gr2d";
 			reg = <0x54140000 0x00040000>;
 			interrupts = <0 72 0x04>;
+			clocks = <&tegra_car 21>;
 		};
 
 		gr3d {
 			compatible = "nvidia,tegra30-gr3d";
 			reg = <0x54180000 0x00040000>;
+			clocks = <&tegra_car 24>;
 		};
 
 		dc@54200000 {
 			compatible = "nvidia,tegra30-dc";
 			reg = <0x54200000 0x00040000>;
 			interrupts = <0 73 0x04>;
+			clocks = <&tegra_car 27>;
 
 			rgb {
 				status = "disabled";
@@ -72,6 +80,7 @@
 			compatible = "nvidia,tegra30-dc";
 			reg = <0x54240000 0x00040000>;
 			interrupts = <0 74 0x04>;
+			clocks = <&tegra_car 26>;
 
 			rgb {
 				status = "disabled";
@@ -83,6 +92,7 @@
 			reg = <0x54280000 0x00040000>;
 			interrupts = <0 75 0x04>;
 			status = "disabled";
+			clocks = <&tegra_car 51>;
 		};
 
 		tvo {
@@ -90,12 +100,14 @@
 			reg = <0x542c0000 0x00040000>;
 			interrupts = <0 76 0x04>;
 			status = "disabled";
+			clocks = <&tegra_car 169>;
 		};
 
 		dsi {
 			compatible = "nvidia,tegra30-dsi";
 			reg = <0x54300000 0x00040000>;
 			status = "disabled";
+			clocks = <&tegra_car 48>;
 		};
 	};
 
@@ -174,6 +186,7 @@
 			      0 141 0x04
 			      0 142 0x04
 			      0 143 0x04>;
+		clocks = <&tegra_car 34>;
 	};
 
 	ahb: ahb {
@@ -219,6 +232,7 @@
 		interrupts = <0 36 0x04>;
 		nvidia,dma-request-selector = <&apbdma 8>;
 		status = "disabled";
+		clocks = <&tegra_car 6>;
 	};
 
 	uartb: serial@70006040 {
@@ -228,6 +242,7 @@
 		interrupts = <0 37 0x04>;
 		nvidia,dma-request-selector = <&apbdma 9>;
 		status = "disabled";
+		clocks = <&tegra_car 160>;
 	};
 
 	uartc: serial@70006200 {
@@ -237,6 +252,7 @@
 		interrupts = <0 46 0x04>;
 		nvidia,dma-request-selector = <&apbdma 10>;
 		status = "disabled";
+		clocks = <&tegra_car 55>;
 	};
 
 	uartd: serial@70006300 {
@@ -246,6 +262,7 @@
 		interrupts = <0 90 0x04>;
 		nvidia,dma-request-selector = <&apbdma 19>;
 		status = "disabled";
+		clocks = <&tegra_car 65>;
 	};
 
 	uarte: serial@70006400 {
@@ -255,12 +272,14 @@
 		interrupts = <0 91 0x04>;
 		nvidia,dma-request-selector = <&apbdma 20>;
 		status = "disabled";
+		clocks = <&tegra_car 66>;
 	};
 
 	pwm: pwm {
 		compatible = "nvidia,tegra30-pwm", "nvidia,tegra20-pwm";
 		reg = <0x7000a000 0x100>;
 		#pwm-cells = <2>;
+		clocks = <&tegra_car 17>;
 	};
 
 	rtc {
@@ -276,6 +295,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 12>, <&tegra_car 182>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	i2c@7000c400 {
@@ -285,6 +306,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 54>, <&tegra_car 182>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	i2c@7000c500 {
@@ -294,6 +317,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 67>, <&tegra_car 182>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	i2c@7000c700 {
@@ -303,6 +328,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 103>, <&tegra_car 182>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	i2c@7000d000 {
@@ -312,6 +339,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 47>, <&tegra_car 182>;
+		clock-names = "div-clk", "fast-clk";
 	};
 
 	spi@7000d400 {
@@ -322,6 +351,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 41>;
 	};
 
 	spi@7000d600 {
@@ -332,6 +362,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 44>;
 	};
 
 	spi@7000d800 {
@@ -342,6 +373,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 46>;
 	};
 
 	spi@7000da00 {
@@ -352,6 +384,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 68>;
 	};
 
 	spi@7000dc00 {
@@ -362,6 +395,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 104>;
 	};
 
 	spi@7000de00 {
@@ -372,6 +406,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		status = "disabled";
+		clocks = <&tegra_car 105>;
 	};
 
 	pmc {
@@ -404,7 +439,13 @@
 		       0x70080200 0x100>;
 		interrupts = <0 103 0x04>;
 		nvidia,dma-request-selector = <&apbdma 1>;
-
+		clocks = <&tegra_car 106>, <&tegra_car 107>, <&tegra_car 30>,
+			 <&tegra_car 11>, <&tegra_car 18>, <&tegra_car 101>,
+			 <&tegra_car 102>, <&tegra_car 108>, <&tegra_car 109>,
+			 <&tegra_car 110>, <&tegra_car 162>;
+		clock-names = "d_audio", "apbif", "i2s0", "i2s1", "i2s2",
+			      "i2s3", "i2s4", "dam0", "dam1", "dam2",
+			      "spdif_in";
 		ranges;
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -414,6 +455,7 @@
 			reg = <0x70080300 0x100>;
 			nvidia,ahub-cif-ids = <4 4>;
 			status = "disabled";
+			clocks = <&tegra_car 30>;
 		};
 
 		tegra_i2s1: i2s@70080400 {
@@ -421,6 +463,7 @@
 			reg = <0x70080400 0x100>;
 			nvidia,ahub-cif-ids = <5 5>;
 			status = "disabled";
+			clocks = <&tegra_car 11>;
 		};
 
 		tegra_i2s2: i2s@70080500 {
@@ -428,6 +471,7 @@
 			reg = <0x70080500 0x100>;
 			nvidia,ahub-cif-ids = <6 6>;
 			status = "disabled";
+			clocks = <&tegra_car 18>;
 		};
 
 		tegra_i2s3: i2s@70080600 {
@@ -435,6 +479,7 @@
 			reg = <0x70080600 0x100>;
 			nvidia,ahub-cif-ids = <7 7>;
 			status = "disabled";
+			clocks = <&tegra_car 101>;
 		};
 
 		tegra_i2s4: i2s@70080700 {
@@ -442,6 +487,7 @@
 			reg = <0x70080700 0x100>;
 			nvidia,ahub-cif-ids = <8 8>;
 			status = "disabled";
+			clocks = <&tegra_car 102>;
 		};
 	};
 
@@ -450,6 +496,7 @@
 		reg = <0x78000000 0x200>;
 		interrupts = <0 14 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 14>;
 	};
 
 	sdhci@78000200 {
@@ -457,6 +504,7 @@
 		reg = <0x78000200 0x200>;
 		interrupts = <0 15 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 9>;
 	};
 
 	sdhci@78000400 {
@@ -464,6 +512,7 @@
 		reg = <0x78000400 0x200>;
 		interrupts = <0 19 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 69>;
 	};
 
 	sdhci@78000600 {
@@ -471,6 +520,7 @@
 		reg = <0x78000600 0x200>;
 		interrupts = <0 31 0x04>;
 		status = "disabled";
+		clocks = <&tegra_car 15>;
 	};
 
 	pmu {
-- 
1.7.4.1

