Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab2HMKEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:04:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53386 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2HMKEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:04:15 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Sourav Poddar <sourav.poddar@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCHv2 1/4] arm/dts: omap5-evm: Add I2C support
Date: Mon, 13 Aug 2012 15:35:10 +0530
Message-ID: <1344852313-30484-2-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
References: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C data node in omap5 device tree file.

Tested on omap5430 evm.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 57e5270..6b68dfe 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -145,6 +145,41 @@
 			#interrupt-cells = <1>;
 		};
 
+		i2c1: i2c@48070000 {
+			compatible = "ti,omap4-i2c";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "i2c1";
+		};
+
+		i2c2: i2c@48072000 {
+			compatible = "ti,omap4-i2c";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "i2c2";
+		};
+
+		i2c3: i2c@48060000 {
+			compatible = "ti,omap4-i2c";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "i2c3";
+		};
+
+		i2c4: i2c@4807A000 {
+			compatible = "ti,omap4-i2c";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "i2c4";
+		};
+
+		i2c5: i2c@4807C000 {
+			compatible = "ti,omap4-i2c";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			ti,hwmods = "i2c5";
+		};
+
 		uart1: serial@4806a000 {
 			compatible = "ti,omap4-uart";
 			ti,hwmods = "uart1";
-- 
1.7.1

