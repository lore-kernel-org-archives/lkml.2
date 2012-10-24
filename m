Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078Ab2JXHH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:07:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57404 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934391Ab2JXHHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:07:32 -0400
From: Sebastien Guiriec <s-guiriec@ti.com>
To: Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v3 2/4] ARM: dts: omap5: Update I2C with address space and interrupts
Date: Wed, 24 Oct 2012 09:07:12 +0200
Message-ID: <1351062434-22514-3-git-send-email-s-guiriec@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351062434-22514-1-git-send-email-s-guiriec@ti.com>
References: <1351062434-22514-1-git-send-email-s-guiriec@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add base address and interrupt line inside Device Tree data for
OMAP5

Signed-off-by: Sebastien Guiriec <s-guiriec@ti.com>
Reviewed-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 737a536..07d2607 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -200,6 +200,9 @@
 
 		i2c1: i2c@48070000 {
 			compatible = "ti,omap4-i2c";
+			reg = <0x48070000 0x100>;
+			interrupts = <0 56 0x4>;
+			interrupt-parent = <&gic>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c1";
@@ -207,6 +210,9 @@
 
 		i2c2: i2c@48072000 {
 			compatible = "ti,omap4-i2c";
+			reg = <0x48072000 0x100>;
+			interrupts = <0 57 0x4>;
+			interrupt-parent = <&gic>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c2";
@@ -214,20 +220,29 @@
 
 		i2c3: i2c@48060000 {
 			compatible = "ti,omap4-i2c";
+			reg = <0x48060000 0x100>;
+			interrupts = <0 61 0x4>;
+			interrupt-parent = <&gic>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c3";
 		};
 
-		i2c4: i2c@4807A000 {
+		i2c4: i2c@4807a000 {
 			compatible = "ti,omap4-i2c";
+			reg = <0x4807a000 0x100>;
+			interrupts = <0 62 0x4>;
+			interrupt-parent = <&gic>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c4";
 		};
 
-		i2c5: i2c@4807C000 {
+		i2c5: i2c@4807c000 {
 			compatible = "ti,omap4-i2c";
+			reg = <0x4807c000 0x100>;
+			interrupts = <0 60 0x4>;
+			interrupt-parent = <&gic>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c5";
-- 
1.7.10.4

