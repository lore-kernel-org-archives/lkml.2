Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab2C2N27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:28:59 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:23894 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2C2N1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:27:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 04/12] ARM: at91/dts: USB host vbus is active low
Date: Thu, 29 Mar 2012 15:27:15 +0200
Message-Id: <44829c6b9071853311b87eaf3b8952fd6c5b8d82.1333026637.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change vbus gpio configuration in .dts files to switch to
active low configuration.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: stable <stable@vger.kernel.org>
---
 arch/arm/boot/dts/at91sam9g25ek.dts    |    4 ++--
 arch/arm/boot/dts/at91sam9m10g45ek.dts |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g25ek.dts b/arch/arm/boot/dts/at91sam9g25ek.dts
index ac0dc00..7829a4d 100644
--- a/arch/arm/boot/dts/at91sam9g25ek.dts
+++ b/arch/arm/boot/dts/at91sam9g25ek.dts
@@ -37,8 +37,8 @@
 		usb0: ohci@00600000 {
 			status = "okay";
 			num-ports = <2>;
-			atmel,vbus-gpio = <&pioD 19 0
-					   &pioD 20 0
+			atmel,vbus-gpio = <&pioD 19 1
+					   &pioD 20 1
 					  >;
 		};
 
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index c4c8ae4..6abb571 100644
--- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -73,8 +73,8 @@
 		usb0: ohci@00700000 {
 			status = "okay";
 			num-ports = <2>;
-			atmel,vbus-gpio = <&pioD 1 0
-					   &pioD 3 0>;
+			atmel,vbus-gpio = <&pioD 1 1
+					   &pioD 3 1>;
 		};
 
 		usb1: ehci@00800000 {
-- 
1.7.9.4

