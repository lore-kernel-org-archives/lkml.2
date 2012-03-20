Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab2CTD3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:29:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54550 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2CTD3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:29:12 -0400
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] ARM: dts: imx6q: add anatop regulators
Date: Tue, 20 Mar 2012 11:28:59 +0800
Message-Id: <1332214139-6833-1-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

Add anatop regulators to imx6q.dtsi for all imx6q platforms.

Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
Signed-off-by: Richard Zhao <richard.zhao@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/boot/dts/imx6q.dtsi |   86 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index 263e8f3..dd41514 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -346,6 +346,92 @@
 				compatible = "fsl,imx6q-anatop";
 				reg = <0x020c8000 0x1000>;
 				interrupts = <0 49 0x04 0 54 0x04 0 127 0x04>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				regulator-vddpu@140 {
+					compatible = "fsl,anatop-regulator";
+					regulator-name = "vddpu";
+					regulator-min-microvolt = <725000>;
+					regulator-max-microvolt = <1300000>;
+					regulator-always-on;
+					reg = <0x140>;
+					anatop-vol-bit-shift = <9>;
+					anatop-vol-bit-width = <5>;
+					anatop-min-bit-val = <1>;
+					anatop-min-voltage = <725000>;
+					anatop-max-voltage = <1300000>;
+				};
+
+				regulator-vddcore@140 {
+					compatible = "fsl,anatop-regulator";
+					regulator-name = "cpu";
+					regulator-min-microvolt = <725000>;
+					regulator-max-microvolt = <1300000>;
+					regulator-always-on;
+					reg = <0x140>;
+					anatop-vol-bit-shift = <0>;
+					anatop-vol-bit-width = <5>;
+					anatop-min-bit-val = <1>;
+					anatop-min-voltage = <725000>;
+					anatop-max-voltage = <1300000>;
+				};
+
+				regulator-vddsoc@140 {
+					compatible = "fsl,anatop-regulator";
+					regulator-name = "vddsoc";
+					regulator-min-microvolt = <725000>;
+					regulator-max-microvolt = <1300000>;
+					regulator-always-on;
+					reg = <0x140>;
+					anatop-vol-bit-shift = <18>;
+					anatop-vol-bit-width = <5>;
+					anatop-min-bit-val = <1>;
+					anatop-min-voltage = <725000>;
+					anatop-max-voltage = <1300000>;
+				};
+
+				regulator-2p5@130 {
+					compatible = "fsl,anatop-regulator";
+					regulator-name = "vdd2p5";
+					regulator-min-microvolt = <2000000>;
+					regulator-max-microvolt = <2775000>;
+					regulator-always-on;
+					reg = <0x130>;
+					anatop-vol-bit-shift = <8>;
+					anatop-vol-bit-width = <5>;
+					anatop-min-bit-val = <0>;
+					anatop-min-voltage = <2000000>;
+					anatop-max-voltage = <2775000>;
+				};
+
+				regulator-1p1@110 {
+					compatible = "fsl,anatop-regulator";
+					regulator-name = "vdd1p1";
+					regulator-min-microvolt = <800000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-always-on;
+					reg = <0x110>;
+					anatop-vol-bit-shift = <8>;
+					anatop-vol-bit-width = <5>;
+					anatop-min-bit-val = <4>;
+					anatop-min-voltage = <800000>;
+					anatop-max-voltage = <1400000>;
+				};
+
+				regulator-3p0@120 {
+					compatible = "fsl,anatop-regulator";
+					regulator-name = "vdd3p0";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <3150000>;
+					regulator-always-on;
+					reg = <0x120>;
+					anatop-vol-bit-shift = <8>;
+					anatop-vol-bit-width = <5>;
+					anatop-min-bit-val = <7>;
+					anatop-min-voltage = <2800000>;
+					anatop-max-voltage = <3150000>;
+				};
 			};
 
 			usbphy@020c9000 { /* USBPHY1 */
-- 
1.7.9.1

