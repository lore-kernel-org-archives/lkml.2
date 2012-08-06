Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2HFNXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:23:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44209 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab2HFNXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:23:37 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <tony@atomide.com>, <rnayak@ti.com>,
        <hvaibhav@ti.com>, <kishon@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [PATCH 3/4] arm/dts: Add twl4030-usb data
Date: Mon, 6 Aug 2012 18:53:14 +0530
Message-ID: <1344259395-4559-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344259395-4559-1-git-send-email-kishon@ti.com>
References: <1344259395-4559-1-git-send-email-kishon@ti.com>
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

