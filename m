Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2JBIQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:16:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47590 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2JBINo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:13:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/10] ARM: ux500: Create a new Device Tree include file for boards supporting STUIBs
Date: Tue,  2 Oct 2012 09:13:20 +0100
Message-Id: <1349165603-24401-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a skeleton creation which will be populated with the devices
found on one of ST-Ericsson's (UIB) User Interface Board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefprev60.dts  |    1 +
 arch/arm/boot/dts/hrefv60plus.dts |    1 +
 arch/arm/boot/dts/stuib.dtsi      |   15 +++++++++++++++
 3 files changed, 17 insertions(+)
 create mode 100644 arch/arm/boot/dts/stuib.dtsi

diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts
index 0756f97..e112cce 100644
--- a/arch/arm/boot/dts/hrefprev60.dts
+++ b/arch/arm/boot/dts/hrefprev60.dts
@@ -12,6 +12,7 @@
 /dts-v1/;
 /include/ "dbx5x0.dtsi"
 /include/ "href.dtsi"
+/include/ "stuib.dtsi"
 
 / {
 	model = "ST-Ericsson HREF (pre-v60) platform with Device Tree";
diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 4b867b2..b5fc355 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -12,6 +12,7 @@
 /dts-v1/;
 /include/ "dbx5x0.dtsi"
 /include/ "href.dtsi"
+/include/ "stuib.dtsi"
 
 / {
 	model = "ST-Ericsson HREF (v60+) platform with Device Tree";
diff --git a/arch/arm/boot/dts/stuib.dtsi b/arch/arm/boot/dts/stuib.dtsi
new file mode 100644
index 0000000..64ac327
--- /dev/null
+++ b/arch/arm/boot/dts/stuib.dtsi
@@ -0,0 +1,15 @@
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
+/ {
+	soc-u9500 {
+	};
+};
-- 
1.7.9.5

