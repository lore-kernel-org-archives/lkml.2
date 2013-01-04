Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3ADQpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:45:52 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:35447 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3ADQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:45:38 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 2/2] ARM: sunxi: Add the GPIOs node to the device tree
Date: Fri,  4 Jan 2013 17:45:09 +0100
Message-Id: <1357317909-12458-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1357317909-12458-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a13.dtsi |   51 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index e112189..dc650a6 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -14,6 +14,15 @@
 /include/ "sunxi.dtsi"
 
 / {
+	aliases {
+		gpio1 = &pb;
+		gpio2 = &pc;
+		gpio3 = &pd;
+		gpio4 = &pe;
+		gpio5 = &pf;
+		gpio6 = &pg;
+	};
+
 	memory {
 		reg = <0x40000000 0x20000000>;
 	};
@@ -39,5 +48,47 @@
 				allwinner,pull = <0>;
 			};
 		};
+
+		pb: gpio@01c20824 {
+			compatible = "allwinner,sunxi-gpio";
+			reg = <0x01c20824 0x24>;
+			gpio-controller;
+			#gpio-cells = <1>;
+		};
+
+		pc: gpio@01c20848 {
+			compatible = "allwinner,sunxi-gpio";
+			reg = <0x01c20848 0x24>;
+			gpio-controller;
+			#gpio-cells = <1>;
+		};
+
+		pd: gpio@01c2086c {
+			compatible = "allwinner,sunxi-gpio";
+			reg = <0x01c2086c 0x24>;
+			gpio-controller;
+			#gpio-cells = <1>;
+		};
+
+		pe: gpio@01c20890 {
+			compatible = "allwinner,sunxi-gpio";
+			reg = <0x01c20890 0x24>;
+			gpio-controller;
+			#gpio-cells = <1>;
+		};
+
+		pf: gpio@01c208b4 {
+			compatible = "allwinner,sunxi-gpio";
+			reg = <0x01c208b4 0x24>;
+			gpio-controller;
+			#gpio-cells = <1>;
+		};
+
+		pg: gpio@01c208d8 {
+			compatible = "allwinner,sunxi-gpio";
+			reg = <0x01c208d8 0x24>;
+			gpio-controller;
+			#gpio-cells = <1>;
+		};
 	};
 };
-- 
1.7.10.4

