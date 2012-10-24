Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036Ab2JXHHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:07:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57405 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934394Ab2JXHHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:07:32 -0400
From: Sebastien Guiriec <s-guiriec@ti.com>
To: Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v3 4/4] ARM: dts: omap5: Update MMC with address space and interrupts
Date: Wed, 24 Oct 2012 09:07:14 +0200
Message-ID: <1351062434-22514-5-git-send-email-s-guiriec@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351062434-22514-1-git-send-email-s-guiriec@ti.com>
References: <1351062434-22514-1-git-send-email-s-guiriec@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add base address and interrupt line inside Device Tree data for
OMAP5.

Signed-off-by: Sebastien Guiriec <s-guiriec@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index b535d8e..304dd8d 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -304,6 +304,9 @@
 
 		mmc1: mmc@4809c000 {
 			compatible = "ti,omap4-hsmmc";
+			reg = <0x4809c000 0x400>;
+			interrupts = <0 83 0x4>;
+			interrupt-parent = <&gic>;
 			ti,hwmods = "mmc1";
 			ti,dual-volt;
 			ti,needs-special-reset;
@@ -311,24 +314,36 @@
 
 		mmc2: mmc@480b4000 {
 			compatible = "ti,omap4-hsmmc";
+			reg = <0x480b4000 0x400>;
+			interrupts = <0 86 0x4>;
+			interrupt-parent = <&gic>;
 			ti,hwmods = "mmc2";
 			ti,needs-special-reset;
 		};
 
 		mmc3: mmc@480ad000 {
 			compatible = "ti,omap4-hsmmc";
+			reg = <0x480ad000 0x400>;
+			interrupts = <0 94 0x4>;
+			interrupt-parent = <&gic>;
 			ti,hwmods = "mmc3";
 			ti,needs-special-reset;
 		};
 
 		mmc4: mmc@480d1000 {
 			compatible = "ti,omap4-hsmmc";
+			reg = <0x480d1000 0x400>;
+			interrupts = <0 96 0x4>;
+			interrupt-parent = <&gic>;
 			ti,hwmods = "mmc4";
 			ti,needs-special-reset;
 		};
 
 		mmc5: mmc@480d5000 {
 			compatible = "ti,omap4-hsmmc";
+			reg = <0x480d5000 0x400>;
+			interrupts = <0 59 0x4>;
+			interrupt-parent = <&gic>;
 			ti,hwmods = "mmc5";
 			ti,needs-special-reset;
 		};
-- 
1.7.10.4

