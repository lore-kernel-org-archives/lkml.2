Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab0KPUuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:50:14 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35172 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab0KPUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:50:07 -0500
Subject: [PATCH 2/5] powerpc/5200: dts: rename nodes to prepare for
	refactoring dts files
To: linux-kernel@vger.kernel.org
From: John Bonesio <bones@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, jdl@jdl.com, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Date: Tue, 16 Nov 2010 12:50:02 -0800
Message-ID: <20101116205002.12146.57002.stgit@riker>
In-Reply-To: <20101116204917.12146.39851.stgit@riker>
References: <20101116204917.12146.39851.stgit@riker>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames nodes in dts fils for MPC5200b files to prepare for
refactoring of these files later. When refactoring it will be easier to verify
the results if the node names aren't changing at the same time.

Signed-off-by: John Bonesio <bones@secretlab.ca>
---

 arch/powerpc/boot/dts/cm5200.dts    |    8 ++++----
 arch/powerpc/boot/dts/digsy_mtc.dts |    6 +++---
 arch/powerpc/boot/dts/lite5200b.dts |    2 +-
 arch/powerpc/boot/dts/media5200.dts |    2 +-
 arch/powerpc/boot/dts/motionpro.dts |   10 +++++-----
 arch/powerpc/boot/dts/mucmc52.dts   |    6 +++---
 arch/powerpc/boot/dts/pcm030.dts    |    6 +++---
 arch/powerpc/boot/dts/pcm032.dts    |    6 +++---
 arch/powerpc/boot/dts/uc101.dts     |    6 +++---
 9 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/boot/dts/cm5200.dts b/arch/powerpc/boot/dts/cm5200.dts
index dd38608..9369dcd 100644
--- a/arch/powerpc/boot/dts/cm5200.dts
+++ b/arch/powerpc/boot/dts/cm5200.dts
@@ -160,25 +160,25 @@
 			reg = <0x1f00 0x100>;
 		};
 
-		serial@2000 {		// PSC1
+		psc@2000 {		// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2000 0x100>;
 			interrupts = <2 1 0>;
 		};
 
-		serial@2200 {		// PSC2
+		psc@2200 {		// PSC2
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2200 0x100>;
 			interrupts = <2 2 0>;
 		};
 
-		serial@2400 {		// PSC3
+		psc@2400 {		// PSC3
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2400 0x100>;
 			interrupts = <2 3 0>;
 		};
 
-		serial@2c00 {		// PSC6
+		psc@2c00 {		// PSC6
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2c00 0x100>;
 			interrupts = <2 4 0>;
diff --git a/arch/powerpc/boot/dts/digsy_mtc.dts b/arch/powerpc/boot/dts/digsy_mtc.dts
index 8e9be6b..f0592de 100644
--- a/arch/powerpc/boot/dts/digsy_mtc.dts
+++ b/arch/powerpc/boot/dts/digsy_mtc.dts
@@ -155,13 +155,13 @@
 			reg = <0x1f00 0x100>;
 		};
 
-		serial@2600 {		// PSC4
+		psc@2600 {		// PSC4
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2600 0x100>;
 			interrupts = <2 11 0>;
 		};
 
-		serial@2800 {		// PSC5
+		psc@2800 {		// PSC5
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2800 0x100>;
 			interrupts = <2 12 0>;
@@ -217,7 +217,7 @@
 		};
 	};
 
-	lpb {
+	localbus {
 		compatible = "fsl,mpc5200b-lpb","simple-bus";
 		#address-cells = <2>;
 		#size-cells = <1>;
diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
index 59702ac..a74b790 100644
--- a/arch/powerpc/boot/dts/lite5200b.dts
+++ b/arch/powerpc/boot/dts/lite5200b.dts
@@ -172,7 +172,7 @@
 			reg = <0x1f00 0x100>;
 		};
 
-		serial@2000 {		// PSC1
+		psc@2000 {		// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			cell-index = <0>;
 			reg = <0x2000 0x100>;
diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
index 0c3902b..a70ef68 100644
--- a/arch/powerpc/boot/dts/media5200.dts
+++ b/arch/powerpc/boot/dts/media5200.dts
@@ -183,7 +183,7 @@
 		};
 
 		// PSC6 in uart mode
-		console: serial@2c00 {		// PSC6
+		console: psc@2c00 {		// PSC6
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			cell-index = <5>;
 			port-number = <0>;  // Logical port assignment
diff --git a/arch/powerpc/boot/dts/motionpro.dts b/arch/powerpc/boot/dts/motionpro.dts
index 6ca4fc1..f6261ea 100644
--- a/arch/powerpc/boot/dts/motionpro.dts
+++ b/arch/powerpc/boot/dts/motionpro.dts
@@ -100,7 +100,7 @@
 			interrupts = <1 14 0>;
 		};
 
-		motionpro-led@660 {	// Motion-PRO status LED
+		timer@660 {	// Motion-PRO status LED
 			compatible = "promess,motionpro-led";
 			label = "motionpro-statusled";
 			reg = <0x660 0x10>;
@@ -108,7 +108,7 @@
 			blink-delay = <100>; // 100 msec
 		};
 
-		motionpro-led@670 {	// Motion-PRO ready LED
+		timer@670 {	// Motion-PRO ready LED
 			compatible = "promess,motionpro-led";
 			label = "motionpro-readyled";
 			reg = <0x670 0x10>;
@@ -169,14 +169,14 @@
 			reg = <0x1f00 0x100>;
 		};
 
-		serial@2000 {		// PSC1
+		psc@2000 {		// PSC1
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2000 0x100>;
 			interrupts = <2 1 0>;
 		};
 
 		// PSC2 in spi master mode 
-		spi@2200 {		// PSC2
+		psc@2200 {		// PSC2
 			compatible = "fsl,mpc5200b-psc-spi","fsl,mpc5200-psc-spi";
 			cell-index = <1>;
 			reg = <0x2200 0x100>;
@@ -184,7 +184,7 @@
 		};
 
 		// PSC5 in uart mode
-		serial@2800 {		// PSC5
+		psc@2800 {		// PSC5
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2800 0x100>;
 			interrupts = <2 12 0>;
diff --git a/arch/powerpc/boot/dts/mucmc52.dts b/arch/powerpc/boot/dts/mucmc52.dts
index b72a758..8dc212d 100644
--- a/arch/powerpc/boot/dts/mucmc52.dts
+++ b/arch/powerpc/boot/dts/mucmc52.dts
@@ -126,19 +126,19 @@
 			reg = <0x1f00 0x100>;
 		};
 
-		serial@2000 { /* PSC1 in UART mode */
+		psc@2000 { /* PSC1 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2000 0x100>;
 			interrupts = <2 1 0>;
 		};
 
-		serial@2200 { /* PSC2 in UART mode */
+		psc@2200 { /* PSC2 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2200 0x100>;
 			interrupts = <2 2 0>;
 		};
 
-		serial@2c00 { /* PSC6 in UART mode */
+		psc@2c00 { /* PSC6 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2c00 0x100>;
 			interrupts = <2 4 0>;
diff --git a/arch/powerpc/boot/dts/pcm030.dts b/arch/powerpc/boot/dts/pcm030.dts
index 8a4ec30..3a4f554 100644
--- a/arch/powerpc/boot/dts/pcm030.dts
+++ b/arch/powerpc/boot/dts/pcm030.dts
@@ -185,7 +185,7 @@
 			reg = <0x1f00 0x100>;
 		};
 
-		ac97@2000 { /* PSC1 in ac97 mode */
+		psc@2000 { /* PSC1 in ac97 mode */
 			compatible = "mpc5200b-psc-ac97","fsl,mpc5200b-psc-ac97";
 			cell-index = <0>;
 			reg = <0x2000 0x100>;
@@ -194,7 +194,7 @@
 
 		/* PSC2 port is used by CAN1/2 */
 
-		serial@2400 { /* PSC3 in UART mode */
+		psc@2400 { /* PSC3 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			cell-index = <2>;
 			reg = <0x2400 0x100>;
@@ -205,7 +205,7 @@
 
 		/* PSC5 is ??? */
 
-		serial@2c00 { /* PSC6 in UART mode */
+		psc@2c00 { /* PSC6 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			cell-index = <5>;
 			reg = <0x2c00 0x100>;
diff --git a/arch/powerpc/boot/dts/pcm032.dts b/arch/powerpc/boot/dts/pcm032.dts
index 85d857a..17596c7 100644
--- a/arch/powerpc/boot/dts/pcm032.dts
+++ b/arch/powerpc/boot/dts/pcm032.dts
@@ -185,7 +185,7 @@
 			reg = <0x1f00 0x100>;
 		};
 
-		ac97@2000 {	/* PSC1 is ac97 */
+		psc@2000 {	/* PSC1 is ac97 */
 			compatible = "fsl,mpc5200b-psc-ac97","fsl,mpc5200-psc-ac97";
 			cell-index = <0>;
 			reg = <0x2000 0x100>;
@@ -194,7 +194,7 @@
 
 		/* PSC2 port is used by CAN1/2 */
 
-		serial@2400 { /* PSC3 in UART mode */
+		psc@2400 { /* PSC3 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			cell-index = <2>;
 			reg = <0x2400 0x100>;
@@ -205,7 +205,7 @@
 
 		/* PSC5 is ??? */
 
-		serial@2c00 { /* PSC6 in UART mode */
+		psc@2c00 { /* PSC6 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			cell-index = <5>;
 			reg = <0x2c00 0x100>;
diff --git a/arch/powerpc/boot/dts/uc101.dts b/arch/powerpc/boot/dts/uc101.dts
index 019264c..e00441a 100644
--- a/arch/powerpc/boot/dts/uc101.dts
+++ b/arch/powerpc/boot/dts/uc101.dts
@@ -158,19 +158,19 @@
 			reg = <0x1f00 0x100>;
 		};
 
-		serial@2000 { /* PSC1 in UART mode */
+		psc@2000 { /* PSC1 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2000 0x100>;
 			interrupts = <2 1 0>;
 		};
 
-		serial@2200 { /* PSC2 in UART mode */
+		psc@2200 { /* PSC2 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2200 0x100>;
 			interrupts = <2 2 0>;
 		};
 
-		serial@2c00 {		/* PSC6 in UART mode */
+		psc@2c00 {		/* PSC6 in UART mode */
 			compatible = "fsl,mpc5200b-psc-uart","fsl,mpc5200-psc-uart";
 			reg = <0x2c00 0x100>;
 			interrupts = <2 4 0>;

