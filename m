Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1KVHL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:11:58 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:33377 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752401Ab1KVHL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:11:57 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: powerpc: dts: Fix canyonlands EMAC interrupt map
Date: Tue, 22 Nov 2011 12:41:17 +0530
Message-Id: <1321945877-22802-1-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing interrupt mapping of EMAC for canyonlands

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 arch/powerpc/boot/dts/canyonlands.dts |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
index 3dc75de..c76bbcd 100644
--- a/arch/powerpc/boot/dts/canyonlands.dts
+++ b/arch/powerpc/boot/dts/canyonlands.dts
@@ -360,13 +360,11 @@
 			EMAC0: ethernet@ef600e00 {
 				device_type = "network";
 				compatible = "ibm,emac-460ex", "ibm,emac4sync";
-				interrupt-parent = <&EMAC0>;
-				interrupts = <0x0 0x1>;
-				#interrupt-cells = <1>;
+				interrupt-parent = <&UIC2>;
 				#address-cells = <0>;
 				#size-cells = <0>;
-				interrupt-map = </*Status*/ 0x0 &UIC2 0x10 0x4
-						 /*Wake*/   0x1 &UIC2 0x14 0x4>;
+				interrupts = </*Status*/0x10 0x4
+						/*Wake*/0x14 0x4>;
 				reg = <0xef600e00 0x000000c4>;
 				local-mac-address = [000000000000]; /* Filled in by U-Boot */
 				mal-device = <&MAL0>;
@@ -390,13 +388,11 @@
 			EMAC1: ethernet@ef600f00 {
 				device_type = "network";
 				compatible = "ibm,emac-460ex", "ibm,emac4sync";
-				interrupt-parent = <&EMAC1>;
-				interrupts = <0x0 0x1>;
-				#interrupt-cells = <1>;
+				interrupt-parent = <&UIC2>;
 				#address-cells = <0>;
 				#size-cells = <0>;
-				interrupt-map = </*Status*/ 0x0 &UIC2 0x11 0x4
-						 /*Wake*/   0x1 &UIC2 0x15 0x4>;
+				interrupts = </*Status*/0x11 0x4
+						/*Wake*/0x15 0x4>;
 				reg = <0xef600f00 0x000000c4>;
 				local-mac-address = [000000000000]; /* Filled in by U-Boot */
 				mal-device = <&MAL0>;
-- 
1.6.1.rc3

