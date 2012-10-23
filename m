Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2JWIh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:37:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34019 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab2JWIhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:37:24 -0400
From: Sebastien Guiriec <s-guiriec@ti.com>
To: Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 1/4] ARM: dts: omap5: Update GPIO with address space and interrupts
Date: Tue, 23 Oct 2012 10:37:09 +0200
Message-ID: <1350981432-6750-2-git-send-email-s-guiriec@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350981432-6750-1-git-send-email-s-guiriec@ti.com>
References: <1350981432-6750-1-git-send-email-s-guiriec@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add base address and interrupt line inside Device Tree data for
OMAP5

Signed-off-by: Sebastien Guiriec <s-guiriec@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 42c78be..9e39f9f 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -104,6 +104,8 @@
 
 		gpio1: gpio@4ae10000 {
 			compatible = "ti,omap4-gpio";
+			reg = <0x4ae10000 0x200>;
+			interrupts = <0 29 0x4>;
 			ti,hwmods = "gpio1";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -113,6 +115,8 @@
 
 		gpio2: gpio@48055000 {
 			compatible = "ti,omap4-gpio";
+			reg = <0x48055000 0x200>;
+			interrupts = <0 30 0x4>;
 			ti,hwmods = "gpio2";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -122,6 +126,8 @@
 
 		gpio3: gpio@48057000 {
 			compatible = "ti,omap4-gpio";
+			reg = <0x48057000 0x200>;
+			interrupts = <0 31 0x4>;
 			ti,hwmods = "gpio3";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -131,6 +137,8 @@
 
 		gpio4: gpio@48059000 {
 			compatible = "ti,omap4-gpio";
+			reg = <0x48059000 0x200>;
+			interrupts = <0 32 0x4>;
 			ti,hwmods = "gpio4";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -140,6 +148,8 @@
 
 		gpio5: gpio@4805b000 {
 			compatible = "ti,omap4-gpio";
+			reg = <0x4805b000 0x200>;
+			interrupts = <0 33 0x4>;
 			ti,hwmods = "gpio5";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -149,6 +159,8 @@
 
 		gpio6: gpio@4805d000 {
 			compatible = "ti,omap4-gpio";
+			reg = <0x4805d000 0x200>;
+			interrupts = <0 34 0x4>;
 			ti,hwmods = "gpio6";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -158,6 +170,8 @@
 
 		gpio7: gpio@48051000 {
 			compatible = "ti,omap4-gpio";
+			reg = <0x48051000 0x200>;
+			interrupts = <0 35 0x4>;
 			ti,hwmods = "gpio7";
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -167,6 +181,8 @@
 
 		gpio8: gpio@48053000 {
 			compatible = "ti,omap4-gpio";
+			reg = <0x48053000 0x200>;
+			interrupts = <0 121 0x4>;
 			ti,hwmods = "gpio8";
 			gpio-controller;
 			#gpio-cells = <2>;
-- 
1.7.10.4

