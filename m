Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2FSOic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:38:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13317 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2FSOi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:38:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 19 Jun 2012 07:38:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <arnd@arndb.de>, <linus.walleij@linaro.org>,
        <lrg@ti.com>, <lee.jones@linaro.org>, <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 3/3] ARM: dts: db8500: add node property "regulator-compatible" regulator node
Date: Tue, 19 Jun 2012 19:58:19 +0530
Message-ID: <1340116099-17629-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device's regulator matches their hardware counterparts with the
property "regulator-compatible" of each child regulator node in
place of the child node.
Add the property "regulator-compatible" for each regulator with
their name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
 - This is new change in V2.

 arch/arm/boot/dts/db8500.dtsi |  128 +++++++++++++++++++++++++++++++----------
 1 files changed, 97 insertions(+), 31 deletions(-)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
index 4ad5160..9548f80 100644
--- a/arch/arm/boot/dts/db8500.dtsi
+++ b/arch/arm/boot/dts/db8500.dtsi
@@ -203,107 +203,149 @@
 
 			db8500-prcmu-regulators {
 				compatible = "stericsson,db8500-prcmu-regulator";
+				#address-cells = <1>;
+				#size-cells = <0>;
 
 				// DB8500_REGULATOR_VAPE
-				db8500_vape_reg: db8500_vape {
+				db8500_vape_reg: regulator@0 {
+					reg = <0>;
+					regulator-compatible = "db8500_vape";
 					regulator-name = "db8500-vape";
 					regulator-always-on;
 				};
 
 				// DB8500_REGULATOR_VARM
-				db8500_varm_reg: db8500_varm {
+				db8500_varm_reg: regulator@1 {
+					reg = <1>;
+					regulator-compatible = "db8500_varm";
 					regulator-name = "db8500-varm";
 				};
 
 				// DB8500_REGULATOR_VMODEM
-				db8500_vmodem_reg: db8500_vmodem {
+				db8500_vmodem_reg: regulator@2 {
+					reg = <2>;
+					regulator-compatible = "db8500_vmodem";
 					regulator-name = "db8500-vmodem";
 				};
 
 				// DB8500_REGULATOR_VPLL
-				db8500_vpll_reg: db8500_vpll {
+				db8500_vpll_reg: regulator@3 {
+					reg = <3>;
+					regulator-compatible = "db8500_vpll";
 					regulator-name = "db8500-vpll";
 				};
 
 				// DB8500_REGULATOR_VSMPS1
-				db8500_vsmps1_reg: db8500_vsmps1 {
+				db8500_vsmps1_reg: regulator@4 {
+					reg = <4>;
+					regulator-compatible = "db8500_vsmps1";
 					regulator-name = "db8500-vsmps1";
 				};
 
 				// DB8500_REGULATOR_VSMPS2
-				db8500_vsmps2_reg: db8500_vsmps2 {
+				db8500_vsmps2_reg: regulator@5 {
+					reg = <5>;
+					regulator-compatible = "db8500_vsmps2";
 					regulator-name = "db8500-vsmps2";
 				};
 
 				// DB8500_REGULATOR_VSMPS3
-				db8500_vsmps3_reg: db8500_vsmps3 {
+				db8500_vsmps3_reg: regulator@6 {
+					reg = <6>;
+					regulator-compatible = "db8500_vsmps3";
 					regulator-name = "db8500-vsmps3";
 				};
 
 				// DB8500_REGULATOR_VRF1
-				db8500_vrf1_reg: db8500_vrf1 {
+				db8500_vrf1_reg: regulator@7 {
+					reg = <7>;
+					regulator-compatible = "db8500_vrf1";
 					regulator-name = "db8500-vrf1";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAMMDSP
-				db8500_sva_mmdsp_reg: db8500_sva_mmdsp {
+				db8500_sva_mmdsp_reg: regulator@8 {
+					reg = <8>;
+					regulator-compatible = "db8500_sva_mmdsp";
 					regulator-name = "db8500-sva-mmdsp";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAMMDSPRET
-				db8500_sva_mmdsp_ret_reg: db8500_sva_mmdsp_ret {
+				db8500_sva_mmdsp_ret_reg: regulator@9 {
+					reg = <9>;
+					regulator-compatible = "db8500_sva_mmdsp_ret";
 					regulator-name = "db8500-sva-mmdsp-ret";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SVAPIPE
-				db8500_sva_pipe_reg: db8500_sva_pipe {
+				db8500_sva_pipe_reg: regulator@10 {
+					reg = <10>;
+					regulator-compatible = "db8500_sva_pipe";
 					regulator-name = "db8500_sva_pipe";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SIAMMDSP
-				db8500_sia_mmdsp_reg: db8500_sia_mmdsp {
+				db8500_sia_mmdsp_reg: regulator@11 {
+					reg = <11>;
+					regulator-compatible = "db8500_sia_mmdsp";
 					regulator-name = "db8500_sia_mmdsp";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SIAMMDSPRET
-				db8500_sia_mmdsp_ret_reg: db8500_sia_mmdsp_ret {
+				db8500_sia_mmdsp_ret_reg: regulator@12 {
+					reg = <12>;
+					regulator-compatible = "db8500_sia_mmdsp_ret";
 					regulator-name = "db8500-sia-mmdsp-ret";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SIAPIPE
-				db8500_sia_pipe_reg: db8500_sia_pipe {
+				db8500_sia_pipe_reg: regulator@13 {
+					reg = <13>;
+					regulator-compatible = "db8500_sia_pipe";
 					regulator-name = "db8500-sia-pipe";
 				};
 
 				// DB8500_REGULATOR_SWITCH_SGA
-				db8500_sga_reg: db8500_sga {
+				db8500_sga_reg: regulator@14 {
+					reg = <14>;
+					regulator-compatible = "db8500_sga";
 					regulator-name = "db8500-sga";
 					vin-supply = <&db8500_vape_reg>;
 				};
 
 				// DB8500_REGULATOR_SWITCH_B2R2_MCDE
-				db8500_b2r2_mcde_reg: db8500_b2r2_mcde {
+				db8500_b2r2_mcde_reg: regulator@15 {
+					reg = <15>;
+					regulator-compatible = "db8500_b2r2_mcde";
 					regulator-name = "db8500-b2r2-mcde";
 					vin-supply = <&db8500_vape_reg>;
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM12
-				db8500_esram12_reg: db8500_esram12 {
+				db8500_esram12_reg: regulator@16 {
+					reg = <16>;
+					regulator-compatible = "db8500_esram12";
 					regulator-name = "db8500-esram12";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM12RET
-				db8500_esram12_ret_reg: db8500_esram12_ret {
+				db8500_esram12_ret_reg: regulator@17 {
+					reg = <17>;
+					regulator-compatible = "db8500_esram12_ret";
 					regulator-name = "db8500-esram12-ret";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM34
-				db8500_esram34_reg: db8500_esram34 {
+				db8500_esram34_reg: regulator@18 {
+					reg = <18>;
+					regulator-compatible = "db8500_esram34";
 					regulator-name = "db8500-esram34";
 				};
 
 				// DB8500_REGULATOR_SWITCH_ESRAM34RET
-				db8500_esram34_ret_reg: db8500_esram34_ret {
+				db8500_esram34_ret_reg: regulator@19 {
+					reg = <19>;
+					regulator-compatible = "db8500_esram34_ret";
 					regulator-name = "db8500-esram34-ret";
 				};
 			};
@@ -315,9 +357,13 @@
 
 				ab8500-regulators {
 					compatible = "stericsson,ab8500-regulator";
+					#address-cells = <1>;
+					#size-cells = <0>;
 
 					// supplies to the display/camera
-					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
+					ab8500_ldo_aux1_reg: regulator@0 {
+						reg = <0>;
+						regulator-compatible = "ab8500_ldo_aux1";
 						regulator-name = "V-DISPLAY";
 						regulator-min-microvolt = <2500000>;
 						regulator-max-microvolt = <2900000>;
@@ -327,56 +373,76 @@
 					};
 
 					// supplies to the on-board eMMC
-					ab8500_ldo_aux2_reg: ab8500_ldo_aux2 {
+					ab8500_ldo_aux2_reg: regulator@1 {
+						reg = <1>;
+						regulator-compatible = "ab8500_ldo_aux2";
 						regulator-name = "V-eMMC1";
 						regulator-min-microvolt = <1100000>;
 						regulator-max-microvolt = <3300000>;
 					};
 
 					// supply for VAUX3; SDcard slots
-					ab8500_ldo_aux3_reg: ab8500_ldo_aux3 {
+					ab8500_ldo_aux3_reg: regulator@2 {
+						reg = <2>;
+						regulator-compatible = "ab8500_ldo_aux3";
 						regulator-name = "V-MMC-SD";
 						regulator-min-microvolt = <1100000>;
 						regulator-max-microvolt = <3300000>;
 					};
 
 					// supply for v-intcore12; VINTCORE12 LDO
-					ab8500_ldo_initcore_reg: ab8500_ldo_initcore {
+					ab8500_ldo_initcore_reg: regulator@3 {
+						reg = <3>;
+						regulator-compatible = "ab8500_ldo_initcore";
 						regulator-name = "V-INTCORE";
 					};
 
 					// supply for tvout; gpadc; TVOUT LDO
-					ab8500_ldo_tvout_reg: ab8500_ldo_tvout {
+					ab8500_ldo_tvout_reg: regulator@4 {
+						reg = <4>;
+						regulator-compatible = "ab8500_ldo_tvout";
 						regulator-name = "V-TVOUT";
 					};
 
 					// supply for ab8500-usb; USB LDO
-					ab8500_ldo_usb_reg: ab8500_ldo_usb {
+					ab8500_ldo_usb_reg: regulator@5 {
+						reg = <5>;
+						regulator-compatible = "ab8500_ldo_usb";
 						regulator-name = "dummy";
 					};
 
 					// supply for ab8500-vaudio; VAUDIO LDO
-					ab8500_ldo_audio_reg: ab8500_ldo_audio {
+					ab8500_ldo_audio_reg: regulator@6 {
+						reg = <6>;
+						regulator-compatible = "ab8500_ldo_audio";
 						regulator-name = "V-AUD";
 					};
 
 					// supply for v-anamic1 VAMic1-LDO
-					ab8500_ldo_anamic1_reg: ab8500_ldo_anamic1 {
+					ab8500_ldo_anamic1_reg: regulator@7 {
+						reg = <7>;
+						regulator-compatible = "ab8500_ldo_anamic1";
 						regulator-name = "V-AMIC1";
 					};
 
 					// supply for v-amic2; VAMIC2 LDO; reuse constants for AMIC1
-					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
+					ab8500_ldo_amamic2_reg: regulator@8 {
+						reg = <8>;
+						regulator-compatible = "ab8500_ldo_amamic2";
 						regulator-name = "V-AMIC2";
 					};
 
 					// supply for v-dmic; VDMIC LDO
-					ab8500_ldo_dmic_reg: ab8500_ldo_dmic {
+					ab8500_ldo_dmic_reg: regulator@9 {
+						reg = <9>;
+						regulator-compatible = "ab8500_ldo_dmic";
 						regulator-name = "V-DMIC";
 					};
 
 					// supply for U8500 CSI/DSI; VANA LDO
-					ab8500_ldo_ana_reg: ab8500_ldo_ana {
+					ab8500_ldo_ana_reg: regulator@10 {
+						reg = <10>;
+						regulator-compatible = "ab8500_ldo_ana";
 						regulator-name = "V-CSI/DSI";
 					};
 				};
-- 
1.7.1.1

