Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab2K1CIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:08:30 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:35462 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab2K1CI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:08:29 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, linux@arm.linux.org.uk, sameo@linux.intel.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v3 7/7] mfd: max8925: add dts
Date: Wed, 28 Nov 2012 10:09:51 +0800
Message-Id: <1354068591-10234-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 28 Nov 2012 02:08:18.0230 (UTC) FILETIME=[3BA12D60:01CDCD0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

add max8925 dts support into mmp2 brownstone platform

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 arch/arm/boot/dts/mmp2-brownstone.dts |  158 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/mmp2.dtsi           |    4 +-
 2 files changed, 161 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
index c9b4f27..d94210b 100644
--- a/arch/arm/boot/dts/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/mmp2-brownstone.dts
@@ -29,6 +29,164 @@
 			};
 			twsi1: i2c@d4011000 {
 				status = "okay";
+				pmic: max8925@3c {
+					compatible = "maxium,max8925";
+					reg = <0x3c>;
+					interrupts = <1>;
+					interrupt-parent = <&intcmux4>;
+					interrupt-controller;
+					#interrupt-cells = <1>;
+					tsc-irq = <0>;
+
+					regulators {
+						SDV1 {
+							regulator-min-microvolt = <637500>;
+							regulator-max-microvolt = <1425000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						SDV2 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2225000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						SDV3 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO1 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO2 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2250000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO3 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2250000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO4 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO5 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO6 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO7 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO8 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO9 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO10 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+						};
+						LDO11 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO12 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO13 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO14 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO15 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO16 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO17 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2250000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO18 {
+							regulator-min-microvolt = <650000>;
+							regulator-max-microvolt = <2250000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO19 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO20 {
+							regulator-min-microvolt = <750000>;
+							regulator-max-microvolt = <3900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+					};
+					backlight {
+						max8925-dual-string = <0>;
+					};
+					charger {
+						batt-detect = <0>;
+						topoff-threshold = <1>;
+						fast-charge = <7>;
+						no-temp-support = <0>;
+						no-insert-detect = <0>;
+					};
+				};
 			};
 			rtc: rtc@d4010000 {
 				status = "okay";
diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
index 80f74e2..76f9cc7 100644
--- a/arch/arm/boot/dts/mmp2.dtsi
+++ b/arch/arm/boot/dts/mmp2.dtsi
@@ -41,7 +41,7 @@
 				mrvl,intc-nr-irqs = <64>;
 			};
 
-			intcmux4@d4282150 {
+			intcmux4: interrupt-controller@d4282150 {
 				compatible = "mrvl,mmp2-mux-intc";
 				interrupts = <4>;
 				interrupt-controller;
@@ -196,6 +196,8 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
+				#address-cells = <1>;
+				#size-cells = <0>;
 				mrvl,i2c-fast-mode;
 				status = "disabled";
 			};
-- 
1.7.0.4

