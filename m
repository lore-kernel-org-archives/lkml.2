Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2FNQym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:54:42 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:29174 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756465Ab2FNQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:48 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 15/23] ARM: LPC32xx: Fix lpc32xx.dtsi status property: "disable" -> "disabled"
Date: Thu, 14 Jun 2012 18:51:05 +0200
Message-Id: <1339692673-7848-16-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes some status = "disable" strings to "disabled", the correct
way of disabling nodes in the devicetree.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/boot/dts/lpc32xx.dtsi |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -35,14 +35,14 @@
 		slc: flash@20020000 {
 			compatible = "nxp,lpc3220-slc";
 			reg = <0x20020000 0x1000>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		mlc: flash@200a8000 {
 			compatible = "nxp,lpc3220-mlc";
 			reg = <0x200a8000 0x11000>;
 			interrupts = <11 0>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		dma@31000000 {
@@ -58,21 +58,21 @@
 			compatible = "nxp,ohci-nxp", "usb-ohci";
 			reg = <0x31020000 0x300>;
 			interrupts = <0x3b 0>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		usbd@31020000 {
 			compatible = "nxp,lpc3220-udc";
 			reg = <0x31020000 0x300>;
 			interrupts = <0x3d 0>, <0x3e 0>, <0x3c 0>, <0x3a 0>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		clcd@31040000 {
 			compatible = "arm,pl110", "arm,primecell";
 			reg = <0x31040000 0x1000>;
 			interrupts = <0x0e 0>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		mac: ethernet@31060000 {
@@ -261,14 +261,14 @@
 				compatible = "nxp,lpc3220-adc";
 				reg = <0x40048000 0x1000>;
 				interrupts = <0x27 0>;
-				status = "disable";
+				status = "disabled";
 			};
 
 			tsc@40048000 {
 				compatible = "nxp,lpc3220-tsc";
 				reg = <0x40048000 0x1000>;
 				interrupts = <0x27 0>;
-				status = "disable";
+				status = "disabled";
 			};
 
 			key@40050000 {
