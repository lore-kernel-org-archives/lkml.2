Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3AGB5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:57:11 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:33737 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3AGB5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:57:07 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, linux@arm.linux.org.uk
Subject: [PATCH 12/12] ARM: dts: add spi nodes for the atmel boards
Date: Mon,  7 Jan 2013 09:50:13 +0800
Message-Id: <1357523413-27209-13-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 07 Jan 2013 01:56:53.0646 (UTC) FILETIME=[441BF2E0:01CDEC7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[wenyou.yang@atmel.com: added spi nodes for the sam9263ek, sam9g20ek, sam9m10g45ek and sam9n12ek boards]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
---
 arch/arm/boot/dts/at91sam9263ek.dts         |   14 ++++++++++++++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi |   14 ++++++++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts      |   14 ++++++++++++++
 arch/arm/boot/dts/at91sam9n12ek.dts         |   14 ++++++++++++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi         |   14 ++++++++++++++
 5 files changed, 70 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9263ek.dts b/arch/arm/boot/dts/at91sam9263ek.dts
index 1eb0872..63ba57b 100644
--- a/arch/arm/boot/dts/at91sam9263ek.dts
+++ b/arch/arm/boot/dts/at91sam9263ek.dts
@@ -79,6 +79,20 @@
 					};
 				};
 			};
+
+			spi0: spi@fffa4000 {
+				status = "okay";
+				cs-gpios = <&pioA 5 0
+					    &pioA 3 0
+					    &pioA 4 0
+					    &pioB 11 0
+					   >;
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index da15e83..49ad49e 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -96,6 +96,20 @@
 				status = "okay";
 				pinctrl-0 = <&pinctrl_ssc0_tx>;
 			};
+
+			spi0: spi@fffc8000 {
+				status = "okay";
+				cs-gpios = <&pioA 3 0
+					    &pioC 11 0
+					    &pioC 16 0
+					    &pioC 17 0
+					   >;
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <50000000>;
+					reg = <1>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index 20c3191..275f22d 100644
--- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -102,6 +102,20 @@
 					};
 				};
 			};
+
+			spi0: spi@fffa4000{
+				status = "okay";
+				cs-gpios = <&pioB 3 0
+					    &pioB 18 0
+					    &pioB 19 0
+					    &pioD 27 0
+					   >;
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <13000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 0376bf4..4eeca7b 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -67,6 +67,20 @@
 					};
 				};
 			};
+
+			spi0: spi@f0000000 {
+				status = "okay";
+				cs-gpios = <&pioA 14 0
+					    &pioA 7 0
+					    &pioA 1 0
+					    &pioB 3 0
+					   >;
+				m25p80@0 {
+					compatible = "atmel,at25df321a";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 8a7cf1d..ca0a056 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -84,6 +84,20 @@
 					};
 				};
 			};
+
+			spi0: spi@f0000000 {
+				status = "okay";
+				cs-gpios = <&pioA 14 0
+					    &pioA 7 0
+					    &pioA 1 0
+					    &pioB 3 0
+					   >;
+				m25p80@0 {
+					compatible = "atmel,at25df321a";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		usb0: ohci@00600000 {
-- 
1.7.9.5

