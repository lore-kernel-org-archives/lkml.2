Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2IXTZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:25:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60437 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab2IXTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:25:14 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/4] regulator: tps65217.txt: remove regulator-compatible from DT docs
Date: Mon, 24 Sep 2012 13:25:01 -0600
Message-Id: <1348514703-10152-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348514703-10152-1-git-send-email-swarren@wwwdotorg.org>
References: <1348514703-10152-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit "regulator: deprecate regulator-compatible DT property" deprecated
the use of the regulator-compatible DT property. Update the DT example in
the TPS65217 binding documentation to reflect this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This commit is based on regulator's topic/drivers branch.
---
 .../devicetree/bindings/regulator/tps65217.txt     |   31 ++++---------------
 1 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps65217.txt b/Documentation/devicetree/bindings/regulator/tps65217.txt
index 0487e96..d316fb8 100644
--- a/Documentation/devicetree/bindings/regulator/tps65217.txt
+++ b/Documentation/devicetree/bindings/regulator/tps65217.txt
@@ -22,66 +22,49 @@ Example:
 		compatible = "ti,tps65217";
 
 		regulators {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			dcdc1_reg: regulator@0 {
-				reg = <0>;
-				regulator-compatible = "dcdc1";
+			dcdc1_reg: dcdc1 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			dcdc2_reg: regulator@1 {
-				reg = <1>;
-				regulator-compatible = "dcdc2";
+			dcdc2_reg: dcdc2 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			dcdc3_reg: regulator@2 {
-				reg = <2>;
-				regulator-compatible = "dcdc3";
+			dcdc3_reg: dcc3 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo1_reg: regulator@3 {
-				reg = <3>;
-				regulator-compatible = "ldo1";
+			ldo1_reg: ldo1 {
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo2_reg: regulator@4 {
-				reg = <4>;
-				regulator-compatible = "ldo2";
+			ldo2_reg: ldo2 {
 				regulator-min-microvolt = <900000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo3_reg: regulator@5 {
-				reg = <5>;
-				regulator-compatible = "ldo3";
+			ldo3_reg: ldo3 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo4_reg: regulator@6 {
-				reg = <6>;
-				regulator-compatible = "ldo4";
+			ldo4_reg: ldo4 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
-- 
1.7.0.4

