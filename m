Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2EVNLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:11:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14157 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2EVNLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:11:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 May 2012 06:10:54 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@nvidia.com>, <olof@lixom.net>, <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
Date: Tue, 22 May 2012 18:35:17 +0530
Message-ID: <1337691917-15040-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com>
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device info for the PMIC device tps65911 in tegra-cardhu
dts file. This device supports the multiple regulator rails,
gpio, interrupts.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---

 arch/arm/boot/dts/tegra-cardhu.dts |   94 ++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
index 36321bc..093dde8 100644
--- a/arch/arm/boot/dts/tegra-cardhu.dts
+++ b/arch/arm/boot/dts/tegra-cardhu.dts
@@ -126,6 +126,100 @@
 			ti,vsel0-state-high;
 			ti,vsel1-state-high;
 		};
+
+		tps65911: tps65911@2d {
+			compatible = "ti,tps65911";
+			reg = <0x2d>;
+
+			#gpio-cells = <2>;
+			gpio-controller;
+
+			regulators {
+				vdd1_reg: vdd1 {
+					regulator-name = "vdd1";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				vdd2_reg: vdd2 {
+					regulator-name = "vdd2";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				vddctrl_reg: vddctrl {
+					regulator-name = "vddctrl";
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				vio_reg: vio {
+					regulator-name = "vio";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo1_reg: ldo1 {
+					regulator-name = "ldo1";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo2_reg: ldo2 {
+					regulator-name = "ldo2";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+				};
+
+				ldo3_reg: ldo3 {
+					regulator-name = "ldo3";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo4_reg: ldo4 {
+					regulator-name = "ldo4";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo5_reg: ldo5 {
+					regulator-name = "ldo5";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo6_reg: ldo6 {
+					regulator-name = "ldo6";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				ldo7_reg: ldo7 {
+					regulator-name = "ldo7";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				ldo8_reg: ldo8 {
+					regulator-name = "ldo8";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+			};
+		};
 	};
 
 	ahub {
-- 
1.7.1.1

