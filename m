Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3AGB5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:57:38 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:7347 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab3AGB5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:57:06 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, linux@arm.linux.org.uk
Subject: [v3 PATCH 11/12] ARM: dts: add spi nodes for atmel SoC
Date: Mon,  7 Jan 2013 09:50:12 +0800
Message-Id: <1357523413-27209-12-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 07 Jan 2013 01:56:48.0365 (UTC) FILETIME=[40F621D0:01CDEC7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[wenyou.yang@atmel.com: add spi nodes for sam9260, sam9263, sam9g45 and sam9n12]
[wenyou.yang@atmel.com: remove spi property "cs-gpios" to the board dts files]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
---
 arch/arm/boot/dts/at91sam9260.dtsi |   18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi |   18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi |   18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi |   18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |   18 ++++++++++++++++++
 5 files changed, 90 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 68bccf4..9586fe1 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -453,6 +453,24 @@
 				status = "disabled";
 			};
 
+			spi0: spi@fffc8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffc8000 0x200>;
+				interrupts = <12 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffcc000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffcc000 0x200>;
+				interrupts = <13 4 3>;
+				status = "disabled";
+			};
+
 			adc0: adc@fffe0000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffe0000 0x100>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 32ec62c..636b882 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -426,6 +426,24 @@
 				reg = <0xfffffd40 0x10>;
 				status = "disabled";
 			};
+
+			spi0: spi@fffa4000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffa4000 0x200>;
+				interrupts = <14 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffa8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffa8000 0x200>;
+				interrupts = <15 4 3>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 231858f..0100b80 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -495,6 +495,24 @@
 				reg = <0xfffffd40 0x10>;
 				status = "disabled";
 			};
+
+			spi0: spi@fffa4000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9g45-spi";
+				reg = <0xfffa4000 0x200>;
+				interrupts = <14 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffa8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9g45-spi";
+				reg = <0xfffa8000 0x200>;
+				interrupts = <15 4 3>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index e9efb34..86d5357 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -355,6 +355,24 @@
 				#size-cells = <0>;
 				status = "disabled";
 			};
+
+			spi0: spi@f0000000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9x5-spi";
+				reg = <0xf0000000 0x100>;
+				interrupts = <13 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@f0004000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9x5-spi";
+				reg = <0xf0004000 0x100>;
+				interrupts = <14 4 3>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 40ac3a4..8ea2f7d 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -473,6 +473,24 @@
 					trigger-value = <0x6>;
 				};
 			};
+
+			spi0: spi@f0000000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9x5-spi";
+				reg = <0xf0000000 0x100>;
+				interrupts = <13 4 3>;
+				status = "disabled";
+			};
+
+			spi1: spi@f0004000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9x5-spi";
+				reg = <0xf0004000 0x100>;
+				interrupts = <14 4 3>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.7.9.5

