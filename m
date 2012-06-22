Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab2FVNgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:36:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33236 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924Ab2FVNcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:32:46 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [RFC PATCH 05/10] arm/dts: Add twl6030-usb data
Date: Fri, 22 Jun 2012 19:02:14 +0530
Message-ID: <1340371939-23572-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340371939-23572-1-git-send-email-kishon@ti.com>
References: <1340371939-23572-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add twl6030-usb data node in twl6030 device tree file

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/twl6030.dtsi |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
index 3b2f351..6526366 100644
--- a/arch/arm/boot/dts/twl6030.dtsi
+++ b/arch/arm/boot/dts/twl6030.dtsi
@@ -83,4 +83,11 @@
 	clk32kg: regulator@12 {
 		compatible = "ti,twl6030-clk32kg";
 	};
+
+	twl6030-usb {
+		compatible = "ti,twl6030-usb";
+		interrupts = < 4 10 >;
+		regulator = "vusb";
+		vusb-supply = <&vusb>;
+	};
 };
-- 
1.7.5.4

