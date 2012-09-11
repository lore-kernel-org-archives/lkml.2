Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab2IKGgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:36:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49088 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab2IKGgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:36:41 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <tony@atomide.com>, <rnayak@ti.com>, <hvaibhav@ti.com>,
        <kishon@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] arm/dts: Add twl4030-usb data
Date: Tue, 11 Sep 2012 12:06:20 +0530
Message-ID: <1347345381-4390-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347345381-4390-1-git-send-email-kishon@ti.com>
References: <1347345381-4390-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add twl4030-usb data node in twl4030 device tree file.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/twl4030.dtsi |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index 22f4d13..761a5a5 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -37,6 +37,18 @@
 		regulator-max-microvolt = <3150000>;
 	};
 
+	vusb1v5: regulator-vusb1v5 {
+		compatible = "ti,twl4030-vusb1v5";
+	};
+
+	vusb1v8: regulator-vusb1v8 {
+		compatible = "ti,twl4030-vusb1v8";
+	};
+
+	vusb3v1: regulator-vusb3v1 {
+		compatible = "ti,twl4030-vusb3v1";
+	};
+
 	twl_gpio: gpio {
 		compatible = "ti,twl4030-gpio";
 		gpio-controller;
@@ -44,4 +56,13 @@
 		interrupt-controller;
 		#interrupt-cells = <1>;
 	};
+
+	twl4030-usb {
+		compatible = "ti,twl4030-usb";
+		interrupts = < 10 4 >;
+		usb1v5-supply = <&vusb1v5>;
+		usb1v8-supply = <&vusb1v8>;
+		usb3v1-supply = <&vusb3v1>;
+		usb_mode = <1>;
+	};
 };
-- 
1.7.9.5

