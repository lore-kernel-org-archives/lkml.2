Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2IJToX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:44:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40378 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2IJToM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:44:12 -0400
From: Matt Porter <mporter@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, AnilKumar <anilkumar@ti.com>
Subject: [PATCH v2 2/2] ARM: dts: AM33XX: adjust leds to use the corrected gpio label
Date: Mon, 10 Sep 2012 15:45:12 -0400
Message-Id: <1347306312-31533-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347306312-31533-1-git-send-email-mporter@ti.com>
References: <1347306312-31533-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the am33xx.dtsi now using gpio labels that match the AM33xx
documentation, we need to refer to GPIO1 by the "gpio1" label.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/boot/dts/am335x-bone.dts |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index b0a7409..fa0c9d5 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -41,27 +41,27 @@
 
 			heartbeat {
 				label = "beaglebone:green:usr0";
-				gpios = <&gpio2 21 0>;
+				gpios = <&gpio1 21 0>;
 				linux,default-trigger = "heartbeat";
 				default-state = "off";
 			};
 
 			mmc {
 				label = "beaglebone:green:usr1";
-				gpios = <&gpio2 22 0>;
+				gpios = <&gpio1 22 0>;
 				linux,default-trigger = "mmc0";
 				default-state = "off";
 			};
 
 			led2 {
 				label = "beaglebone:green:usr2";
-				gpios = <&gpio2 23 0>;
+				gpios = <&gpio1 23 0>;
 				default-state = "off";
 			};
 
 			led3 {
 				label = "beaglebone:green:usr3";
-				gpios = <&gpio2 24 0>;
+				gpios = <&gpio1 24 0>;
 				default-state = "off";
 			};
 		};
-- 
1.7.9.5

