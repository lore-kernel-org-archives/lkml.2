Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2I0PMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:12:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55885 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2I0PMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:12:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/7] ARM: ux500: Elaborate on SDI device node names in Device Tree
Date: Thu, 27 Sep 2012 16:12:00 +0100
Message-Id: <1348758726-25336-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348758726-25336-1-git-send-email-lee.jones@linaro.org>
References: <1348758726-25336-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the DB8500 Reference Manual SDI devices are described as being
part of peripheral blocks. This is more in line with how these devices
are actually represented in hardware, so here we detail which
peripheral block each of the SDI devices belong in the node name.

Requested-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi  |   12 ++++++------
 arch/arm/boot/dts/snowball.dts |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index c8c39dd..07a085b 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -536,37 +536,37 @@
 			status = "disabled";
 		};
 
-		sdi@80126000 {
+		sdi0_per1@80126000 {
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80126000 0x1000>;
 			interrupts = <0 60 0x4>;
 			status = "disabled";
 		};
-		sdi@80118000 {
+		sdi1_per2@80118000 {
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80118000 0x1000>;
 			interrupts = <0 50 0x4>;
 			status = "disabled";
 		};
-		sdi@80005000 {
+		sdi2_per3@80005000 {
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80005000 0x1000>;
 			interrupts = <0 41 0x4>;
 			status = "disabled";
 		};
-		sdi@80119000 {
+		sdi3_per2@80119000 {
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80119000 0x1000>;
 			interrupts = <0 59 0x4>;
 			status = "disabled";
 		};
-		sdi@80114000 {
+		sdi4_per2@80114000 {
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80114000 0x1000>;
 			interrupts = <0 99 0x4>;
 			status = "disabled";
 		};
-		sdi@80008000 {
+		sdi5_per3@80008000 {
 			compatible = "arm,pl18x", "arm,primecell";
 			reg = <0x80114000 0x1000>;
 			interrupts = <0 100 0x4>;
diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 639b8e9..9a37244 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -120,7 +120,7 @@
 		};
 
 		// External Micro SD slot
-		sdi@80126000 {
+		sdi0_per1@80126000 {
 			arm,primecell-periphid = <0x10480180>;
 			max-frequency = <50000000>;
 			bus-width = <8>;
@@ -134,7 +134,7 @@
 		};
 
 		// On-board eMMC
-		sdi@80114000 {
+		sdi4_per2@80114000 {
 			arm,primecell-periphid = <0x10480180>;
 		        max-frequency = <50000000>;
 			bus-width = <8>;
-- 
1.7.9.5

