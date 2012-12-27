Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2L0WVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:21:34 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42242 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2L0WVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:21:33 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Dove: move CuBox led pinctrl to gpio-leds node
Date: Thu, 27 Dec 2012 23:21:10 +0100
Message-Id: <1356646870-2903-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio-leds has support for pinctrl allocation, make use of it.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove-cubox.dts |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index cdee96f..bed5b62 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -17,6 +17,9 @@
 
 	leds {
 		compatible = "gpio-leds";
+		pinctrl-0 = <&pmx_gpio_18>;
+		pinctrl-names = "default";
+
 		power {
 			label = "Power";
 			gpios = <&gpio0 18 1>;
@@ -47,7 +50,7 @@
 };
 
 &pinctrl {
-	pinctrl-0 = <&pmx_gpio_12 &pmx_gpio_18>;
+	pinctrl-0 = <&pmx_gpio_12>;
 	pinctrl-names = "default";
 
 	pmx_gpio_12: pmx-gpio-12 {
-- 
1.7.10.4

