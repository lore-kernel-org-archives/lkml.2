Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2FTMXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:23:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2255 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab2FTMXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:23:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Jun 2012 05:23:24 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <arnd@arndb.de>, <linus.walleij@linaro.org>, <lee.jones@linaro.org>,
        <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 1/3] ARM: dts: db8500: add property "regulator-compatible" regulator node
Date: Wed, 20 Jun 2012 17:53:05 +0530
Message-ID: <1340194987-23654-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device's regulator matches their hardware counterparts with the
property "regulator-compatible" of each child regulator node in
place of the child node name.
Add the property "regulator-compatible" for each regulator with
their hardware counterpart's name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V2:
- Adding the regulator-compatible for each regulator child node.
- Remove the renaming of the child node.

 arch/arm/boot/dts/db8500.dtsi |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
index 4ad5160..ec2be92 100644
--- a/arch/arm/boot/dts/db8500.dtsi
+++ b/arch/arm/boot/dts/db8500.dtsi
@@ -206,62 +206,74 @@
 
 				// DB8500_REGULATOR_VAPE
 				db8500_vape_reg: db8500_vape {
+					regulator-compatible = "db8500_vape";
 					regulator-name = "db8500-vape";
 					regulator-always-on;
 				};
 
 				// DB8500_REGULATOR_VARM
 				db8500_varm_reg: db8500_varm {
+					regulator-compatible = "db8500_varm";
 					regulator-name = "db8500-varm";
 				};
 
 				// DB8500_REGULATOR_VMODEM
 				db8500_vmodem_reg: db8500_vmodem {
+					regulator-compatible = "db8500_vmodem";
 					regulator-name = "db8500-vmodem";
 				};
 
 				// DB8500_REGULATOR_VPLL
 				db8500_vpll_reg: db8500_vpll {
+					regulator-compatible = "db8500_vpll";
 					regulator-name = "db8500-vpll";
 				};
 
 				// DB8500_REGULATOR_VSMPS1
 				db8500_vsmps1_reg: db8500_vsmps1 {
+					regulator-compatible = "db8500_vsmps1";
 					regulator-name = "db8500-vsmps1";
 				};
 
 				// DB8500_REGULATOR_VSMPS2
 				db8500_vsmps2_reg: db8500_vsmps2 {
+					regulator-compatible = "db8500_vsmps2";
 					regulator-name = "db8500-vsmps2";
 				};
 
 				// DB8500_REGULATOR_VSMPS3
 				db8500_vsmps3_reg: db8500_vsmps3 {
+					regulator-compatible = "db8500_vsmps3";
 					regulator-name = "db8500-vsmps3";
 				};
 
 				// DB8500_REGULATOR_VRF1
 				db8500_vrf1_reg: db8500_vrf1 {
+					regulator-compatible = "db8500_vrf1";
 					regulator-name = "db8500-vrf1";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAMMDSP
 				db8500_sva_mmdsp_reg: db8500_sva_mmdsp {
+					regulator-compatible = "db8500_sva_mmdsp";
 					regulator-name = "db8500-sva-mmdsp";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAMMDSPRET
 				db8500_sva_mmdsp_ret_reg: db8500_sva_mmdsp_ret {
+					regulator-compatible = "db8500_sva_mmdsp_ret";
 					regulator-name = "db8500-sva-mmdsp-ret";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAPIPE
 				db8500_sva_pipe_reg: db8500_sva_pipe {
+					regulator-compatible = "db8500_sva_pipe";
 					regulator-name = "db8500_sva_pipe";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SIAMMDSP
 				db8500_sia_mmdsp_reg: db8500_sia_mmdsp {
+					regulator-compatible = "db8500_sia_mmdsp";
 					regulator-name = "db8500_sia_mmdsp";
 				};
 
@@ -272,38 +284,45 @@
 
 				// DB8500_REGULATOR_SWITCH_SIAPIPE
 				db8500_sia_pipe_reg: db8500_sia_pipe {
+					regulator-compatible = "db8500_sia_pipe";
 					regulator-name = "db8500-sia-pipe";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SGA
 				db8500_sga_reg: db8500_sga {
+					regulator-compatible = "db8500_sga";
 					regulator-name = "db8500-sga";
 					vin-supply = <&db8500_vape_reg>;
 				};
 
 				// DB8500_REGULATOR_SWITCH_B2R2_MCDE
 				db8500_b2r2_mcde_reg: db8500_b2r2_mcde {
+					regulator-compatible = "db8500_b2r2_mcde";
 					regulator-name = "db8500-b2r2-mcde";
 					vin-supply = <&db8500_vape_reg>;
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM12
 				db8500_esram12_reg: db8500_esram12 {
+					regulator-compatible = "db8500_esram12";
 					regulator-name = "db8500-esram12";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM12RET
 				db8500_esram12_ret_reg: db8500_esram12_ret {
+					regulator-compatible = "db8500_esram12_ret";
 					regulator-name = "db8500-esram12-ret";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM34
 				db8500_esram34_reg: db8500_esram34 {
+					regulator-compatible = "db8500_esram34";
 					regulator-name = "db8500-esram34";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM34RET
 				db8500_esram34_ret_reg: db8500_esram34_ret {
+					regulator-compatible = "db8500_esram34_ret";
 					regulator-name = "db8500-esram34-ret";
 				};
 			};
@@ -318,6 +337,7 @@
 
 					// supplies to the display/camera
 					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
+						regulator-compatible = "ab8500_ldo_aux1";
 						regulator-name = "V-DISPLAY";
 						regulator-min-microvolt = <2500000>;
 						regulator-max-microvolt = <2900000>;
@@ -328,6 +348,7 @@
 
 					// supplies to the on-board eMMC
 					ab8500_ldo_aux2_reg: ab8500_ldo_aux2 {
+						regulator-compatible = "ab8500_ldo_aux2";
 						regulator-name = "V-eMMC1";
 						regulator-min-microvolt = <1100000>;
 						regulator-max-microvolt = <3300000>;
@@ -335,6 +356,7 @@
 
 					// supply for VAUX3; SDcard slots
 					ab8500_ldo_aux3_reg: ab8500_ldo_aux3 {
+						regulator-compatible = "ab8500_ldo_aux3";
 						regulator-name = "V-MMC-SD";
 						regulator-min-microvolt = <1100000>;
 						regulator-max-microvolt = <3300000>;
@@ -342,41 +364,49 @@
 
 					// supply for v-intcore12; VINTCORE12 LDO
 					ab8500_ldo_initcore_reg: ab8500_ldo_initcore {
+						regulator-compatible = "ab8500_ldo_initcore";
 						regulator-name = "V-INTCORE";
 					};
 
 					// supply for tvout; gpadc; TVOUT LDO
 					ab8500_ldo_tvout_reg: ab8500_ldo_tvout {
+						regulator-compatible = "ab8500_ldo_tvout";
 						regulator-name = "V-TVOUT";
 					};
 
 					// supply for ab8500-usb; USB LDO
 					ab8500_ldo_usb_reg: ab8500_ldo_usb {
+						regulator-compatible = "ab8500_ldo_usb";
 						regulator-name = "dummy";
 					};
 
 					// supply for ab8500-vaudio; VAUDIO LDO
 					ab8500_ldo_audio_reg: ab8500_ldo_audio {
+						regulator-compatible = "ab8500_ldo_audio";
 						regulator-name = "V-AUD";
 					};
 
 					// supply for v-anamic1 VAMic1-LDO
 					ab8500_ldo_anamic1_reg: ab8500_ldo_anamic1 {
+						regulator-compatible = "ab8500_ldo_anamic1";
 						regulator-name = "V-AMIC1";
 					};
 
 					// supply for v-amic2; VAMIC2 LDO; reuse constants for AMIC1
 					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
+						regulator-compatible = "ab8500_ldo_amamic2";
 						regulator-name = "V-AMIC2";
 					};
 
 					// supply for v-dmic; VDMIC LDO
 					ab8500_ldo_dmic_reg: ab8500_ldo_dmic {
+						regulator-compatible = "ab8500_ldo_dmic";
 						regulator-name = "V-DMIC";
 					};
 
 					// supply for U8500 CSI/DSI; VANA LDO
 					ab8500_ldo_ana_reg: ab8500_ldo_ana {
+						regulator-compatible = "ab8500_ldo_ana";
 						regulator-name = "V-CSI/DSI";
 					};
 				};
-- 
1.7.1.1

