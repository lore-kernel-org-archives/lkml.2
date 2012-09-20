Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2ITMWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:22:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49890 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2ITMNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/32] ARM: ux500: Rename db8500.dtsi to dbx5x0.dtsi to encompass the u9500, u8540 and u9540
Date: Thu, 20 Sep 2012 14:12:19 +0200
Message-Id: <1348143170-2130-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/{db8500.dtsi => dbx5x0.dtsi} |    0
 arch/arm/boot/dts/snowball.dts                 |    2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/arm/boot/dts/{db8500.dtsi => dbx5x0.dtsi} (100%)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
similarity index 100%
rename from arch/arm/boot/dts/db8500.dtsi
rename to arch/arm/boot/dts/dbx5x0.dtsi
diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 7e334d4..df6fc57 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -10,7 +10,7 @@
  */
 
 /dts-v1/;
-/include/ "db8500.dtsi"
+/include/ "dbx5x0.dtsi"
 
 / {
 	model = "Calao Systems Snowball platform with device tree";
-- 
1.7.9.5

