Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2HFNXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:23:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35874 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab2HFNXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:23:38 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <tony@atomide.com>, <rnayak@ti.com>,
        <hvaibhav@ti.com>, <kishon@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [PATCH 2/4] arm/dts: Add twl6030-usb data
Date: Mon, 6 Aug 2012 18:53:13 +0530
Message-ID: <1344259395-4559-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344259395-4559-1-git-send-email-kishon@ti.com>
References: <1344259395-4559-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add twl6030-usb data node in twl6030 device tree file

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap4-panda.dts |    4 ++++
 arch/arm/boot/dts/omap4-sdp.dts   |    4 ++++
 arch/arm/boot/dts/twl6030.dtsi    |    5 +++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 9880c12..2999eba 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -126,3 +126,7 @@
 	ti,non-removable;
 	bus-width = <4>;
 };
+
+&twlusb {
+	usb-supply = <&vusb>;
+};
diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
index 72216e9..d8290c0 100644
--- a/arch/arm/boot/dts/omap4-sdp.dts
+++ b/arch/arm/boot/dts/omap4-sdp.dts
@@ -226,3 +226,7 @@
 	bus-width = <4>;
 	ti,non-removable;
 };
+
+&twlusb {
+	usb-supply = <&vusb>;
+};
diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
index 3b2f351..8e3aac9 100644
--- a/arch/arm/boot/dts/twl6030.dtsi
+++ b/arch/arm/boot/dts/twl6030.dtsi
@@ -83,4 +83,9 @@
 	clk32kg: regulator@12 {
 		compatible = "ti,twl6030-clk32kg";
 	};
+
+	twlusb: twl6030-usb {
+		compatible = "ti,twl6030-usb";
+		interrupts = < 4 10 >;
+	};
 };
-- 
1.7.9.5

