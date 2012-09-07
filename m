Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464Ab2IGLPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:15:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50655 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760370Ab2IGLPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/19] ARM: ux500: Add all known I2C sub-device nodes to the HREF DT
Date: Fri,  7 Sep 2012 12:14:51 +0100
Message-Id: <1347016499-29354-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the skeleton nodes for each of the known I2C sub-devices
currently registered on ST-Ericsson's HREF Development Platform. We
will fill these nodes in turn as the drivers are enabled for Device
Tree.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 7f0dddb..ec9ec4f 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -95,5 +95,31 @@
 		ssp@80002000 {
 			status = "okay";
 		};
+
+		i2c@80004000 {
+			tc3589x@42 {
+				compatible = "tc3589x";
+				reg = <0x42>;
+			};
+			tps61052@33 {
+				compatible = "tps61052";
+				reg = <0x33>;
+			};
+		};
+
+		i2c@80128000 {
+			lp5521@0x33 {
+				compatible = "lp5521";
+				reg = <0x33>;
+			};
+			lp5521@0x34 {
+				compatible = "lp5521";
+				reg = <0x34>;
+			};
+			bh1780@0x29 {
+				compatible = "rohm,bh1780gli";
+				reg = <0x33>;
+			};
+		};
 	};
 };
-- 
1.7.9.5

