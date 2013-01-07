Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3AGFSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:18:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39362 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3AGFSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:18:05 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sekhar Nori <nsekhar@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 5/5] ARM: dts: AM33XX: Add am335x-evmsk lcdc pincontrol info
Date: Mon, 7 Jan 2013 10:48:41 +0530
Message-ID: <eba71d3baa6a851ba3618ee0be80c0c2fabb1934.1357304151.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357304150.git.afzal@ti.com>
References: <cover.1357304150.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update pin mux information for lcd panel on AM335X-EVMSK.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/boot/dts/am335x-evmsk.dts |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index a7e017b..6275a50 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -32,7 +32,7 @@
 
 	am33xx_pinmux: pinmux@44e10800 {
 		pinctrl-names = "default";
-		pinctrl-0 = <&user_leds_s0 &gpio_keys_s0>;
+		pinctrl-0 = <&user_leds_s0 &gpio_keys_s0 &lcd_pins_s0>;
 
 		user_leds_s0: user_leds_s0 {
 			pinctrl-single,pins = <
@@ -51,6 +51,39 @@
 				0x9c 0x27	/* gpmc_ben0_cle.gpio2_5, INPUT | MODE7 */
 			>;
 		};
+
+		lcd_pins_s0: lcd_pins_s0 {
+			pinctrl-single,pins = <
+				0x20 0x01
+				0x24 0x01
+				0x28 0x01
+				0x2c 0x01
+				0x30 0x01
+				0x34 0x01
+				0x38 0x01
+				0x3c 0x01
+				0xa0 0x08
+				0xa4 0x08
+				0xa8 0x08
+				0xac 0x08
+				0xb0 0x08
+				0xb4 0x08
+				0xb8 0x08
+				0xbc 0x08
+				0xc0 0x08
+				0xc4 0x08
+				0xc8 0x08
+				0xcc 0x08
+				0xd0 0x08
+				0xd4 0x08
+				0xd8 0x08
+				0xdc 0x08
+				0xe0 0x00
+				0xe4 0x00
+				0xe8 0x00
+				0xec 0x00
+			>;
+		};
 	};
 
 	ocp {
-- 
1.7.9.5

