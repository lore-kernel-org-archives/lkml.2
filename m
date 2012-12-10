Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2LJI5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:57:21 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43737 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2LJI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:56:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/12] ARM: ux500: Use the correct name when supplying a GPIO enable pin
Date: Mon, 10 Dec 2012 08:55:58 +0000
Message-Id: <1355129761-8088-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct a typo in the Device Tree source file, where instead of
specifying property 'enable-gpio', which the driver is expecting
we specified 'gpio-enable' instead.

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

