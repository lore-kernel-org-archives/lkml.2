Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2LaCld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 21:41:33 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61841 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2LaClc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 21:41:32 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: max77686: Add DTS file for max77686 PMIC
Date: Mon, 31 Dec 2012 11:39:45 +0900
Message-Id: <1356921589-12716-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a dedicated DTS file for max77686 PMIC, supposed to be included
in a board DTS to control the power for certain consumer devices or AP with 9 BUCKs
and 26 LDOs

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/max77686.dtsi |  156 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)
 create mode 100644 arch/arm/boot/dts/max77686.dtsi

diff --git a/arch/arm/boot/dts/max77686.dtsi b/arch/arm/boot/dts/max77686.dtsi
new file mode 100644
index 0000000..9484a0d
--- /dev/null
+++ b/arch/arm/boot/dts/max77686.dtsi
@@ -0,0 +1,156 @@
+/*
+ * Copyright (C) 2012 Dongjin Kim <tobetter@gmail.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ */
+
+&max77686 {
+	compatible = "maxim,max77686";
+
+	interrupt-controller;
+	#interrupt-cells = <1>;
+
+	voltage-regulators {
+		buck1: buck@10 {
+			regulator-compatible = "BUCK1";
+		};
+
+		buck2: buck@12 {
+			regulator-compatible = "BUCK2";
+		};
+
+		buck3: buck@1c {
+			regulator-compatible = "BUCK3";
+		};
+
+		buck4: buck@26 {
+			regulator-compatible = "BUCK4";
+		};
+
+		buck5: buck@30 {
+			regulator-compatible = "BUCK5";
+		};
+
+		buck6: buck@32 {
+			regulator-compatible = "BUCK6";
+		};
+
+		buck7: buck@34 {
+			regulator-compatible = "BUCK7";
+		};
+
+		buck8: buck@36 {
+			regulator-compatible = "BUCK8";
+		};
+
+		buck9: buck@38 {
+			regulator-compatible = "BUCK9";
+		};
+
+		ldo1: ldo@40 {
+			regulator-compatible = "LDO1";
+		};
+
+		ldo2: ldo@41 {
+			regulator-compatible = "LDO2";
+		};
+
+		ldo3: ldo@42 {
+			regulator-compatible = "LDO3";
+		};
+
+		ldo4: ldo@43 {
+			regulator-compatible = "LDO4";
+		};
+
+		ldo5: ldo@44 {
+			regulator-compatible = "LDO5";
+		};
+
+		ldo6: ldo@45 {
+			regulator-compatible = "LDO6";
+		};
+
+		ldo7: ldo@46 {
+			regulator-compatible = "LDO7";
+		};
+
+		ldo8: ldo@47 {
+			regulator-compatible = "LDO8";
+		};
+
+		ldo9: ldo@48 {
+			regulator-compatible = "LDO9";
+		};
+
+		ldo10: ldo@49 {
+			regulator-compatible = "LDO10";
+		};
+
+		ldo11: ldo@4a {
+			regulator-compatible = "LDO11";
+		};
+
+		ldo12: ldo@4b {
+			regulator-compatible = "LDO12";
+		};
+
+		ldo13: ldo@4c {
+			regulator-compatible = "LDO13";
+		};
+
+		ldo14: ldo@4d {
+			regulator-compatible = "LDO14";
+		};
+
+		ldo15: ldo@4e {
+			regulator-compatible = "LDO15";
+		};
+
+		ldo16: ldo@4f {
+			regulator-compatible = "LDO16";
+		};
+
+		ldo17: ldo@50 {
+			regulator-compatible = "LDO17";
+		};
+
+		ldo18: ldo@51 {
+			regulator-compatible = "LDO18";
+		};
+
+		ldo19: ldo@52 {
+			regulator-compatible = "LDO19";
+		};
+
+		ldo20: ldo@53 {
+			regulator-compatible = "LDO20";
+		};
+
+		ldo21: ldo@54 {
+			regulator-compatible = "LDO21";
+		};
+
+		ldo22: ldo@55 {
+			regulator-compatible = "LDO22";
+		};
+
+		ldo23: ldo@56 {
+			regulator-compatible = "LDO23";
+		};
+
+		ldo24: ldo@57 {
+			regulator-compatible = "LDO24";
+		};
+
+		ldo25: ldo@58 {
+			regulator-compatible = "LDO25";
+		};
+
+		ldo26: ldo@59 {
+			regulator-compatible = "LDO26";
+		};
+	};
+};
-- 
1.7.10.4

