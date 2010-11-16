Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0KPUu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:50:56 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:60238 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab0KPUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:50:24 -0500
Subject: [PATCH 4/5] powerpc/5200: dts: Remove incorrect combatible strings
To: linux-kernel@vger.kernel.org
From: John Bonesio <bones@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, jdl@jdl.com, glikely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, david@gibson.dropbear.id.au
Date: Tue, 16 Nov 2010 12:50:19 -0800
Message-ID: <20101116205019.12146.79445.stgit@riker>
In-Reply-To: <20101116204917.12146.39851.stgit@riker>
References: <20101116204917.12146.39851.stgit@riker>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some incorrect compatible strings on the local plus bus node
in dts files for MPC5200b based systems.

Signed-off-by: John Bonesio <bones@secretlab.ca>
---

 arch/powerpc/boot/dts/lite5200b.dts |    2 +-
 arch/powerpc/boot/dts/mucmc52.dts   |    2 +-
 arch/powerpc/boot/dts/pcm032.dts    |    2 +-
 arch/powerpc/boot/dts/uc101.dts     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
index c0a4e45..ed8d7ae 100644
--- a/arch/powerpc/boot/dts/lite5200b.dts
+++ b/arch/powerpc/boot/dts/lite5200b.dts
@@ -295,7 +295,7 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
+		compatible = "fsl,mpc5200b-lpb","simple-bus";
 
 		#address-cells = <2>;
 		#size-cells = <1>;
diff --git a/arch/powerpc/boot/dts/mucmc52.dts b/arch/powerpc/boot/dts/mucmc52.dts
index 8dc212d..b9d3559 100644
--- a/arch/powerpc/boot/dts/mucmc52.dts
+++ b/arch/powerpc/boot/dts/mucmc52.dts
@@ -217,7 +217,7 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
+		compatible = "fsl,mpc5200b-lpb","simple-bus";
 
 		#address-cells = <2>;
 		#size-cells = <1>;
diff --git a/arch/powerpc/boot/dts/pcm032.dts b/arch/powerpc/boot/dts/pcm032.dts
index e0f2702..085a646 100644
--- a/arch/powerpc/boot/dts/pcm032.dts
+++ b/arch/powerpc/boot/dts/pcm032.dts
@@ -292,7 +292,7 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
+		compatible = "fsl,mpc5200b-lpb","simple-bus";
 
 		#address-cells = <2>;
 		#size-cells = <1>;
diff --git a/arch/powerpc/boot/dts/uc101.dts b/arch/powerpc/boot/dts/uc101.dts
index e00441a..70299a4 100644
--- a/arch/powerpc/boot/dts/uc101.dts
+++ b/arch/powerpc/boot/dts/uc101.dts
@@ -229,7 +229,7 @@
 	};
 
 	localbus {
-		compatible = "fsl,mpc5200b-lpb","fsl,mpc5200-lpb","simple-bus";
+		compatible = "fsl,mpc5200b-lpb","simple-bus";
 
 		#address-cells = <2>;
 		#size-cells = <1>;

