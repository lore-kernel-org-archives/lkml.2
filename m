Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2F1Lv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:51:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32919 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab2F1Lvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:51:46 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <hvaibhav@ti.com>
Subject: [PATCH v1 08/11] arm/dts: Add twl4030-usb data
Date: Thu, 28 Jun 2012 17:21:04 +0530
Message-ID: <1340884267-28908-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340884267-28908-1-git-send-email-kishon@ti.com>
References: <1340884267-28908-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add twl4030-usb data node in twl4030 device tree file.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/twl4030.dtsi |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/twl4030.dtsi b/arch/arm/boot/dts/twl4030.dtsi
index 22f4d13..66534a3 100644
--- a/arch/arm/boot/dts/twl4030.dtsi
+++ b/arch/arm/boot/dts/twl4030.dtsi
@@ -37,6 +37,18 @@
 		regulator-max-microvolt = <3150000>;
 	};
 
+	vusb1v5: regulator@3 {
+		compatible = "ti,twl4030-vusb1v5";
+	};
+
+	vusb1v8: regulator@4 {
+		compatible = "ti,twl4030-vusb1v8";
+	};
+
+	vusb3v1: regulator@5 {
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
1.7.5.4

