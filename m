Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab2LMNWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:22:34 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55258 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2LMNWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:22:32 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/8] ARM: ux500: Use the correct name when supplying a GPIO enable pin
Date: Thu, 13 Dec 2012 13:22:07 +0000
Message-Id: <1355404930-5691-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct a typo in the Device Tree source file, where instead of
specifying property 'enable-gpio', which the driver is expecting
we specified 'gpio-enable' instead.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefprev60.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts
index eec29c4..9194fb6 100644
--- a/arch/arm/boot/dts/hrefprev60.dts
+++ b/arch/arm/boot/dts/hrefprev60.dts
@@ -40,7 +40,7 @@
 
 		vmmci: regulator-gpio {
 			gpios = <&tc3589x_gpio 18 0x4>;
-			gpio-enable = <&tc3589x_gpio 17 0x4>;
+			enable-gpio = <&tc3589x_gpio 17 0x4>;
 
 			status = "okay";
 		};
-- 
1.7.9.5

