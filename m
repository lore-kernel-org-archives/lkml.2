Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab2GENGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:06:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63940 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab2GENGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/9] ARM: ux500: Ensure vendor specific properties have the vendor's identifier
Date: Thu,  5 Jul 2012 14:06:07 +0100
Message-Id: <1341493572-29735-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any non-standard property should contain the vendor's identifier which
should be perpended onto the property name followed by a comma. This
aids in name-space collision prevention.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/db8500.dtsi |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
index d89b88d..7279165 100644
--- a/arch/arm/boot/dts/db8500.dtsi
+++ b/arch/arm/boot/dts/db8500.dtsi
@@ -60,7 +60,7 @@
 			interrupts = <0 119 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <0>;
@@ -73,7 +73,7 @@
 			interrupts = <0 120 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <1>;
@@ -86,7 +86,7 @@
 			interrupts = <0 121 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <2>;
@@ -99,7 +99,7 @@
 			interrupts = <0 122 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <3>;
@@ -112,7 +112,7 @@
 			interrupts = <0 123 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <4>;
@@ -125,7 +125,7 @@
 			interrupts = <0 124 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <5>;
@@ -138,7 +138,7 @@
 			interrupts = <0 125 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <6>;
@@ -151,7 +151,7 @@
 			interrupts = <0 126 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <7>;
@@ -164,7 +164,7 @@
 			interrupts = <0 127 0x4>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-			supports-sleepmode;
+			st,supports-sleepmode;
 			gpio-controller;
 			#gpio-cells = <2>;
 			gpio-bank = <8>;
-- 
1.7.9.5

