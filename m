Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2ITMNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:13:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60100 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2ITMNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 27/32] ARM: ux500: Add all known I2C sub-device nodes to the HREF DT
Date: Thu, 20 Sep 2012 14:12:45 +0200
Message-Id: <1348143170-2130-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the skeleton nodes for each of the known I2C sub-devices
currently registered on ST-Ericsson's HREF Development Platform. We
will fill these nodes in turn as the drivers are enabled for Device
Tree.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 32cd7a0..1d2c642 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -32,5 +32,34 @@
 		uart@80007000 {
 			status = "okay";
 		};
+
+		i2c@80004000 {
+			tc3589x@42 {
+				compatible = "tc3589x";
+				reg = <0x42>;
+			};
+
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
+
+			lp5521@0x34 {
+				compatible = "lp5521";
+				reg = <0x34>;
+			};
+
+			bh1780@0x29 {
+				compatible = "rohm,bh1780gli";
+				reg = <0x33>;
+			};
+		};
 	};
 };
-- 
1.7.9.5

