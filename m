Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2JAKoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:44:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46134 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2JAKoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:44:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/7] ARM: ux500: Correct Snowball's external SD/MMC slot's bus width
Date: Mon,  1 Oct 2012 11:43:44 +0100
Message-Id: <1349088228-8582-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349088228-8582-1-git-send-email-lee.jones@linaro.org>
References: <1349088228-8582-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Snowball's external SD/MMC slot is only capable of 4 bit data
transfer, not 8 bits as previously thought. This is a simple
fixup moving to the correct settings.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 9a37244..6a2b58b 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -123,7 +123,7 @@
 		sdi0_per1@80126000 {
 			arm,primecell-periphid = <0x10480180>;
 			max-frequency = <50000000>;
-			bus-width = <8>;
+			bus-width = <4>;
 			mmc-cap-mmc-highspeed;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;
 
-- 
1.7.9.5

