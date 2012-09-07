Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab2IGLTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:19:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41840 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760338Ab2IGLPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/19] ARM: ux500: Add skeleton Device Tree for the HREF reference board
Date: Fri,  7 Sep 2012 12:14:41 +0100
Message-Id: <1347016499-29354-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First commit applying the new Device Tree for ST-Ericsson's u8500
based hardware reference board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 arch/arm/boot/dts/hrefv60plus.dts

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
new file mode 100644
index 0000000..96bf8a3
--- /dev/null
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -0,0 +1,26 @@
+/*
+ * Copyright 2012 ST-Ericsson AB
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "dbx5x0.dtsi"
+
+/ {
+	model = "ST-Ericsson HREF platform with Device Tree";
+	compatible = "st-ericsson,hrefv60+";
+
+	memory {
+		reg = <0x00000000 0x20000000>;
+	};
+
+	soc-u9500 {
+
+	};
+};
-- 
1.7.9.5

