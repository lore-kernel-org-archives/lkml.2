Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3AGFRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:17:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39345 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3AGFRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:17:37 -0500
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
Subject: [PATCH 1/5] ARM: dts: AM33XX: Add lcdc node
Date: Mon, 7 Jan 2013 10:48:03 +0530
Message-ID: <f4d5d2174efb07e4b69eb1ba0990a8db3b077ade.1357304150.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357304150.git.afzal@ti.com>
References: <cover.1357304150.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lcdc node.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index c2f14e8..432d4bb8 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -385,5 +385,13 @@
 				mac-address = [ 00 00 00 00 00 00 ];
 			};
 		};
+
+		lcdc: lcdc@4830e000 {
+			compatible = "ti,am3352-lcdc", "ti,da830-lcdc";
+			reg = <0x4830e000 0x1000>;
+			interrupts = <36>;
+			status = "disabled";
+			ti,hwmods = "lcdc";
+		};
 	};
 };
-- 
1.7.9.5

