Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0KPUuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:50:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32809 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab0KPUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:50:15 -0500
Subject: [PATCH 3/5] powerpc/5200: dts: remove unused properties
To: linux-kernel@vger.kernel.org
From: John Bonesio <bones@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, jdl@jdl.com, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Date: Tue, 16 Nov 2010 12:50:10 -0800
Message-ID: <20101116205010.12146.37154.stgit@riker>
In-Reply-To: <20101116204917.12146.39851.stgit@riker>
References: <20101116204917.12146.39851.stgit@riker>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unused properties in dts files in preparation of refactoring
the dts files for MPC5200b based boards.

Signed-off-by: John Bonesio <bones@secretlab.ca>
---

 arch/powerpc/boot/dts/cm5200.dts    |    2 --
 arch/powerpc/boot/dts/lite5200b.dts |    3 ---
 arch/powerpc/boot/dts/media5200.dts |    2 --
 arch/powerpc/boot/dts/motionpro.dts |    2 --
 arch/powerpc/boot/dts/pcm030.dts    |    2 --
 arch/powerpc/boot/dts/pcm032.dts    |    2 --
 6 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/boot/dts/cm5200.dts b/arch/powerpc/boot/dts/cm5200.dts
index 9369dcd..d549897 100644
--- a/arch/powerpc/boot/dts/cm5200.dts
+++ b/arch/powerpc/boot/dts/cm5200.dts
@@ -230,8 +230,6 @@
 			reg = <0 0 0x2000000>;
 			bank-width = <2>;
 			device-width = <2>;
-			#size-cells = <1>;
-			#address-cells = <1>;
 		};
 	};
 };
diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
index a74b790..c0a4e45 100644
--- a/arch/powerpc/boot/dts/lite5200b.dts
+++ b/arch/powerpc/boot/dts/lite5200b.dts
@@ -174,7 +174,6 @@
 
 		psc@2000 {		// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			cell-index = <0>;
 			reg = <0x2000 0x100>;
 			interrupts = <2 1 0>;
 		};
@@ -198,7 +197,6 @@
 		// PSC4 in uart mode example
 		//serial@2600 {		// PSC4
 		//	compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-		//	cell-index = <3>;
 		//	reg = <0x2600 0x100>;
 		//	interrupts = <2 11 0>;
 		//};
@@ -206,7 +204,6 @@
 		// PSC5 in uart mode example
 		//serial@2800 {		// PSC5
 		//	compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-		//	cell-index = <4>;
 		//	reg = <0x2800 0x100>;
 		//	interrupts = <2 12 0>;
 		//};
diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
index a70ef68..e027f45 100644
--- a/arch/powerpc/boot/dts/media5200.dts
+++ b/arch/powerpc/boot/dts/media5200.dts
@@ -185,8 +185,6 @@
 		// PSC6 in uart mode
 		console: psc@2c00 {		// PSC6
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			cell-index = <5>;
-			port-number = <0>;  // Logical port assignment
 			reg = <0x2c00 0x100>;
 			interrupts = <2 4 0>;
 		};
diff --git a/arch/powerpc/boot/dts/motionpro.dts b/arch/powerpc/boot/dts/motionpro.dts
index f6261ea..3ab4666 100644
--- a/arch/powerpc/boot/dts/motionpro.dts
+++ b/arch/powerpc/boot/dts/motionpro.dts
@@ -277,8 +277,6 @@
 			reg = <0 0 0x01000000>;
 			bank-width = <2>;
 			device-width = <2>;
-			#size-cells = <1>;
-			#address-cells = <1>;
 		};
 	};
 };
diff --git a/arch/powerpc/boot/dts/pcm030.dts b/arch/powerpc/boot/dts/pcm030.dts
index 3a4f554..f3e30bb 100644
--- a/arch/powerpc/boot/dts/pcm030.dts
+++ b/arch/powerpc/boot/dts/pcm030.dts
@@ -196,7 +196,6 @@
 
 		psc@2400 { /* PSC3 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			cell-index = <2>;
 			reg = <0x2400 0x100>;
 			interrupts = <2 3 0>;
 		};
@@ -207,7 +206,6 @@
 
 		psc@2c00 { /* PSC6 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			cell-index = <5>;
 			reg = <0x2c00 0x100>;
 			interrupts = <2 4 0>;
 		};
diff --git a/arch/powerpc/boot/dts/pcm032.dts b/arch/powerpc/boot/dts/pcm032.dts
index 17596c7..e0f2702 100644
--- a/arch/powerpc/boot/dts/pcm032.dts
+++ b/arch/powerpc/boot/dts/pcm032.dts
@@ -196,7 +196,6 @@
 
 		psc@2400 { /* PSC3 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			cell-index = <2>;
 			reg = <0x2400 0x100>;
 			interrupts = <2 3 0>;
 		};
@@ -207,7 +206,6 @@
 
 		psc@2c00 { /* PSC6 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
-			cell-index = <5>;
 			reg = <0x2c00 0x100>;
 			interrupts = <2 4 0>;
 		};

