Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab2IRPqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:46:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45547 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab2IRPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:45:54 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Remove redundant #gpio-cell properties from Snowball DT
Date: Tue, 18 Sep 2012 17:45:22 +0200
Message-Id: <1347983122-15174-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property has no place here as the populated node is not related
to a GPIO controller.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 2969997..702c0ba 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -127,7 +127,6 @@
 			mmc-cap-mmc-highspeed;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;
 
-			#gpio-cells = <1>;
 			cd-gpios  = <&gpio6 26 0x4>; // 218
 			cd-inverted;
 
-- 
1.7.9.5

