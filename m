Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2IJTov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:44:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47150 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab2IJToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:44:10 -0400
From: Matt Porter <mporter@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, AnilKumar <anilkumar@ti.com>
Subject: [PATCH v2 1/2] ARM: dts: AM33XX: fix gpio node numbering to match hardware
Date: Mon, 10 Sep 2012 15:45:11 -0400
Message-Id: <1347306312-31533-2-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347306312-31533-1-git-send-email-mporter@ti.com>
References: <1347306312-31533-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On AM33xx, the datasheet and TRM refer to four GPIO instances that
are 0-based, GPIO0-3.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index bb31bff..1369bfc 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -62,7 +62,7 @@
 			reg = <0x48200000 0x1000>;
 		};
 
-		gpio1: gpio@44e07000 {
+		gpio0: gpio@44e07000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio1";
 			gpio-controller;
@@ -74,7 +74,7 @@
 			interrupts = <96>;
 		};
 
-		gpio2: gpio@4804c000 {
+		gpio1: gpio@4804c000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio2";
 			gpio-controller;
@@ -86,7 +86,7 @@
 			interrupts = <98>;
 		};
 
-		gpio3: gpio@481ac000 {
+		gpio2: gpio@481ac000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio3";
 			gpio-controller;
@@ -98,7 +98,7 @@
 			interrupts = <32>;
 		};
 
-		gpio4: gpio@481ae000 {
+		gpio3: gpio@481ae000 {
 			compatible = "ti,omap4-gpio";
 			ti,hwmods = "gpio4";
 			gpio-controller;
-- 
1.7.9.5

