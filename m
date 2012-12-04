Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2LDIAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:00:07 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:14196 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab2LDIAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:00:04 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, linux@arm.linux.org.uk
Subject: [v2 PATCH 13/14] ARM: dts: add spi nodes for atmel SoC
Date: Tue,  4 Dec 2012 15:53:59 +0800
Message-Id: <1354607640-13229-14-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 04 Dec 2012 07:59:42.0483 (UTC) FILETIME=[514D5E30:01CDD1F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[wenyou.yang@atmel.com: add spi nodes for other atmel SOC]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
---
 arch/arm/boot/dts/at91sam9260.dtsi |   30 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi |   30 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi |   30 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi |   30 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |   30 ++++++++++++++++++++++++++++++
 5 files changed, 150 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index d410581..87254aa 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -212,6 +212,36 @@
 				status = "disabled";
 			};
 
+			spi0: spi@fffc8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffc8000 0x200>;
+				interrupts = <12 4 3>;
+				cs-gpios = <&pioA 3 0
+					    &pioC 11 0
+					    &pioC 16 0
+					    &pioC 17 0
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffcc000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffcc000 0x200>;
+				interrupts = <13 4 3>;
+				cs-gpios = <&pioB 3 0
+					    &pioC 5 0
+					    &pioC 4 0
+					    &pioC 3 0
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
+
 			adc0: adc@fffe0000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffe0000 0x100>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 3e6e5c1..528395d 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -195,6 +195,36 @@
 				#size-cells = <0>;
 				status = "disabled";
 			};
+
+			spi0: spi@fffa4000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffa4000 0x200>;
+				interrupts = <14 4 3>;
+				cs-gpios = <&pioA 5 0
+					    &pioA 3 0
+					    &pioA 4 0
+					    &pioB 11 0
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffa8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffa8000 0x200>;
+				interrupts = <15 4 3>;
+				cs-gpios = <&pioB 15 0
+					    &pioB 16 0
+					    &pioB 17 0
+					    &pioB 18 0
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 3add030..8a6aae92 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -262,6 +262,36 @@
 					trigger-value = <0x6>;
 				};
 			};
+
+			spi0: spi@fffa4000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffa4000 0x200>;
+				interrupts = <14 4 3>;
+				cs-gpios = <&pioB 3 0
+					    &pioB 18 0
+					    &pioB 19 0
+					    &pioD 27 0
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
+
+			spi1: spi@fffa8000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9260-spi";
+				reg = <0xfffa8000 0x200>;
+				interrupts = <15 4 3>;
+				cs-gpios = <&pioB 17 0
+					    &pioD 28 0
+					    &pioD 18 0
+					    &pioD 19 0
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 82508d6..183cacf 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -202,6 +202,36 @@
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
+				cs-gpios = <&pioA 14 0
+					    &pioA 7 0
+					    &pioA 1 0
+					    &pioB 3 0
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
+
+			spi1: spi@f0004000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9x5-spi";
+				reg = <0xf0004000 0x100>;
+				interrupts = <14 4 3>;
+				cs-gpios = <&pioA 8 0
+					    &pioA 0 0
+					    &pioA 31 0
+					    &pioA 30 0
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 03fc136..95b55fd 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -263,6 +263,36 @@
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
+				cs-gpios = <&pioA 14 0
+					    &pioA 7 0 /* conflicts with TXD2 */
+					    &pioA 1 0 /* conflicts with RXD0 */
+					    &pioB 3 0 /* conflicts with ERXDV */
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
+
+			spi1: spi@f0004000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9x5-spi";
+				reg = <0xf0004000 0x100>;
+				interrupts = <14 4 3>;
+				cs-gpios = <&pioA 8 0 /* conflitcs with RXD2 */
+					    &pioA 0 0 /* conflitcs with TXD0 */
+					    &pioA 31 0 /* conflitcs with TWCK0 */
+					    &pioA 30 0 /* conflitcs with TWD0 */
+					   >;
+				dma-mask = <0xffffffff>;
+				status = "disabled";
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.7.9.5

