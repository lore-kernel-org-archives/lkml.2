Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2HGTGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:06:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab2HGTGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:06:14 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] arm/dts: max77686: Add DTS file for max77686 PMIC
Date: Wed,  8 Aug 2012 04:04:11 +0900
Message-Id: <1344366267-18971-1-git-send-email-dongjin.kim@agreeyamobility.net>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dedicated DTS file for max77686 PMIC.
This file is supposed to be included in a board DTS in order to control the
power for certain consumer devices or AP with 9 BUCKs and 26 LDOs

Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
---
 arch/arm/boot/dts/max77686.dtsi |  303 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 303 insertions(+)
 create mode 100644 arch/arm/boot/dts/max77686.dtsi

diff --git a/arch/arm/boot/dts/max77686.dtsi b/arch/arm/boot/dts/max77686.dtsi
new file mode 100644
index 0000000..4a46167
--- /dev/null
+++ b/arch/arm/boot/dts/max77686.dtsi
@@ -0,0 +1,303 @@
+/*
+ * arch/arm/boot/dts/max77686.dtsi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/ {
+	max77686@09 {
+		compatible = "maxim,max77686";
+
+		voltage-regulators {
+			buck1 {
+				regulator-compatible = "BUCK1";
+				regulator-name = "VDD_MIF_1.0V";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1050000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck2 {
+				regulator-compatible = "BUCK2";
+				regulator-name = "VDD_ARM_1.3V";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck3 {
+				regulator-compatible = "BUCK3";
+				regulator-name = "VDD_INT_1.0V";
+				regulator-min-microvolt = <800000>;
+				regulator-max-microvolt = <1150000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck4 {
+				regulator-compatible = "BUCK4";
+				regulator-name = "VDD_G3D_1.0V";
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-boot-on;
+			};
+
+			buck5 {
+				regulator-compatible = "BUCK5";
+				regulator-name = "VDDQ_CKEM1M2_1.2V";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck6 {
+				regulator-compatible = "BUCK6";
+				regulator-name = "VDD_INL_1.35V";
+				regulator-min-microvolt = <1350000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck7 {
+				regulator-compatible = "BUCK7";
+				regulator-name = "VDD_INL_2.0V";
+				regulator-min-microvolt = <2000000>;
+				regulator-max-microvolt = <2000000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck8 {
+				regulator-compatible = "BUCK8";
+				regulator-name = "VDD_BUCK8_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			buck9 {
+				regulator-compatible = "BUCK9";
+				regulator-name = "VDD_BUCK9_1.2V";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo1 {
+				regulator-compatible = "LDO1";
+				regulator-name = "VDD_ALIVE_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo2 {
+				regulator-compatible = "LDO2";
+				regulator-name = "VDDQ_M1M2_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo3 {
+				regulator-compatible = "LDO3";
+				regulator-name = "VDDQ_M0_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo4 {
+				regulator-compatible = "LDO4";
+				regulator-name = "VDDQ_MMC2_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+			};
+
+			ldo5 {
+				regulator-compatible = "LDO5";
+				regulator-name = "VDDQ_MMC13_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo6 {
+				regulator-compatible = "LDO6";
+				regulator-name = "VDD_MPLL_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo7 {
+				regulator-compatible = "LDO7";
+				regulator-name = "VDD_VPLL_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo8 {
+				regulator-compatible = "LDO8";
+				regulator-name = "VDD10_HDMI_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo9 {
+				regulator-compatible = "LDO9";
+				regulator-name = "VDD_VTCORE_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo10 {
+				regulator-compatible = "LDO10";
+				regulator-name = "VDDQ_MIPIHSI_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo11 {
+				regulator-compatible = "LDO11";
+				regulator-name = "VDD18_ABB1_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo12 {
+				regulator-compatible = "LDO12";
+				regulator-name = "VDD33_UOTG_3.3V";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+			};
+
+			ldo13 {
+				regulator-compatible = "LDO13";
+				regulator-name = "VDDQ_C2C_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo14 {
+				regulator-compatible = "LDO14";
+				regulator-name = "VDD18_ABB2_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo15 {
+				regulator-compatible = "LDO15";
+				regulator-name = "VDD10_HSIC_1.0V";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
+			};
+
+			ldo16 {
+				regulator-compatible = "LDO16";
+				regulator-name = "VDD18_HSIC_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo17 {
+				regulator-compatible = "LDO17";
+				regulator-name = "VDDQ_CAM_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo18 {
+				regulator-compatible = "LDO18";
+				regulator-name = "VDD_LDO18_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo19 {
+				regulator-compatible = "LDO19";
+				regulator-name = "VDD_VTCAM_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo20 {
+				regulator-compatible = "LDO20";
+				regulator-name = "VDD_LDO20_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo21 {
+				regulator-compatible = "LDO21";
+				regulator-name = "VDD_SDCARD_3.3V";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+			};
+
+			ldo22 {
+				regulator-compatible = "LDO22";
+				regulator-name = "VDD_LDO22_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+			};
+
+			ldo23 {
+				regulator-compatible = "LDO23";
+				regulator-name = "VDD_TOUCH_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+			};
+
+			ldo24 {
+				regulator-compatible = "LDO24";
+				regulator-name = "VDD_TOUCHLED_3.3V";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+			};
+
+			ldo25 {
+				regulator-compatible = "LDO25";
+				regulator-name = "VDDQ_LCD_1.8V";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+
+			ldo26 {
+				regulator-compatible = "LDO26";
+				regulator-name = "VDD_MOTOR_3.0V";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+				regulator-always-on;
+			};
+		};
+	};
+};
-- 
1.7.9.5

