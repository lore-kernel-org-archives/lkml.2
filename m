Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030567Ab2HWPCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:02:13 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40163 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab2HWPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:01:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, w.sang@pengutronix.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/3] Documentation: Device Tree binding information for i2c-nomadik driver
Date: Thu, 23 Aug 2012 16:01:26 +0100
Message-Id: <1345734087-21803-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This document describes each of the non-standard Device Tree bindings
used in the Nomadik I2C driver.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/i2c/nomadik.txt |   23 +++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/nomadik.txt

diff --git a/Documentation/devicetree/bindings/i2c/nomadik.txt b/Documentation/devicetree/bindings/i2c/nomadik.txt
new file mode 100644
index 0000000..72065b0
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/nomadik.txt
@@ -0,0 +1,23 @@
+I2C for Nomadik based systems
+
+Required (non-standard) properties:
+ - Nil
+
+Recommended (non-standard) properties:
+ - clock-frequency : Maximum bus clock frequency for the device
+
+Optional (non-standard) properties:
+ - Nil
+
+Example :
+
+i2c@80004000 {
+        compatible = "stericsson,db8500-i2c", "st,nomadik-i2c";
+        reg = <0x80004000 0x1000>;
+        interrupts = <0 21 0x4>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+        v-i2c-supply = <&db8500_vape_reg>;
+
+        clock-frequency = <400000>;
+};
-- 
1.7.9.5

