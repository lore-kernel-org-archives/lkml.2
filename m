Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2KHCb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:31:57 -0500
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:59668 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740Ab2KHCb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:31:56 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] mfd: max8925: update dt regulator binding doc
Date: Thu,  8 Nov 2012 10:31:32 +0800
Message-Id: <1352341892-27654-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 08 Nov 2012 02:30:41.0807 (UTC) FILETIME=[0C33C1F0:01CDBD59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

remove linux specific references, enumerates all supported
regulators

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 .../bindings/regulator/max8925-regulator.txt       |   51 ++++++++++++--------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/max8925-regulator.txt b/Documentation/devicetree/bindings/regulator/max8925-regulator.txt
index 073b41d..0057695 100644
--- a/Documentation/devicetree/bindings/regulator/max8925-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/max8925-regulator.txt
@@ -1,29 +1,40 @@
 Max8925 Voltage regulators
 
-max8925 regulator device register is still handled by mfd_add_devices, not by
-of_xxx, so, it is not necessary to add compatible name. Also, those reg
-offset and id info is stored in mfd_cell(see max8925-core.c), as a result
-there is not private properties in dts.
-
-node's name should match with the definition in max8925_regulator_matches
-(see max8925-regulator.c)
-
+Required nodes:
+-nodes:
+  - SDV1 for SDV SDV1
+  - SDV2 for SDV SDV2
+  - SDV3 for SDV SDV3
+  - LDO1 for LDO LDO1
+  - LDO2 for LDO LDO2
+  - LDO3 for LDO LDO3
+  - LDO4 for LDO LDO4
+  - LDO5 for LDO LDO5
+  - LDO6 for LDO LDO6
+  - LDO7 for LDO LDO7
+  - LDO8 for LDO LDO8
+  - LDO9 for LDO LDO9
+  - LDO10 for LDO LDO10
+  - LDO11 for LDO LDO11
+  - LDO12 for LDO LDO12
+  - LDO13 for LDO LDO13
+  - LDO14 for LDO LDO14
+  - LDO15 for LDO LDO15
+  - LDO16 for LDO LDO16
+  - LDO17 for LDO LDO17
+  - LDO18 for LDO LDO18
+  - LDO19 for LDO LDO19
+  - LDO20 for LDO LDO20
 
 Optional properties:
 - Any optional property defined in bindings/regulator/regulator.txt
 
-
 Example:
 
+	SDV1 {
+		regulator-min-microvolt = <637500>;
+		regulator-max-microvolt = <1425000>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
 
-	regulators {
-		SDV1 {
-			regulator-min-microvolt = <637500>;
-			regulator-max-microvolt = <1425000>;
-			regulator-boot-on;
-			regulator-always-on;
-		};
-
-		...
-		...
-	}
-- 
1.7.0.4

