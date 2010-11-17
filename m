Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0KQX2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:28:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62933 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0KQX2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:28:51 -0500
Subject: [PATCH 4/5] powerpc/5200: dts: Change combatible strings on localbus
To: linux-kernel@vger.kernel.org
From: John Bonesio <bones@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, jdl@jdl.com, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Date: Wed, 17 Nov 2010 15:28:47 -0800
Message-ID: <20101117232847.25947.60171.stgit@riker>
In-Reply-To: <20101117232520.25947.37475.stgit@riker>
References: <20101117232520.25947.37475.stgit@riker>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes some incorrect compatible strings on the local plus bus node
in dts files for MPC5200b based systems.

Signed-off-by: John Bonesio <bones@secretlab.ca>
---

 arch/powerpc/boot/dts/cm5200.dts    |    2 +-
 arch/powerpc/boot/dts/digsy_mtc.dts |    2 +-
 arch/powerpc/boot/dts/media5200.dts |    2 +-
 arch/powerpc/boot/dts/motionpro.dts |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/boot/dts/cm5200.dts b/arch/powerpc/boot/dts/cm5200.dts
index d549897..22f7233 100644
--- a/arch/powerpc/boot/dts/cm5200.dts
+++ b/arch/powerpc/boot/dts/cm5200.dts
@@ -219,7 +219,7 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
+		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
 		#address-cells = <2>;
 		#size-cells = <1>;
 		ranges = <0 0 0xfc000000 0x2000000>;
diff --git a/arch/powerpc/boot/dts/digsy_mtc.dts b/arch/powerpc/boot/dts/digsy_mtc.dts
index f0592de..3147b98 100644
--- a/arch/powerpc/boot/dts/digsy_mtc.dts
+++ b/arch/powerpc/boot/dts/digsy_mtc.dts
@@ -218,7 +218,7 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
+		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
 		#address-cells = <2>;
 		#size-cells = <1>;
 		ranges = <0 0 0xff000000 0x1000000>;
diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
index e027f45..861f09f 100644
--- a/arch/powerpc/boot/dts/media5200.dts
+++ b/arch/powerpc/boot/dts/media5200.dts
@@ -270,7 +270,7 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
+		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
 		#address-cells = <2>;
 		#size-cells = <1>;
 
diff --git a/arch/powerpc/boot/dts/motionpro.dts b/arch/powerpc/boot/dts/motionpro.dts
index 3ab4666..97cb085 100644
--- a/arch/powerpc/boot/dts/motionpro.dts
+++ b/arch/powerpc/boot/dts/motionpro.dts
@@ -236,7 +236,7 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","simple-bus";
+		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
 		#address-cells = <2>;
 		#size-cells = <1>;
 		ranges = <0 0 0xff000000 0x01000000

