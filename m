Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422862Ab2JYJ5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:57:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57035 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422723Ab2JYJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:57:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/8] ARM: ux500: Change the type of interrupt to something compatible
Date: Thu, 25 Oct 2012 10:57:09 +0100
Message-Id: <1351159031-25391-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
References: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On boot the Nomadik GPIO controller complains that an IRQ can't be
configured as active high level-sensitive, so this patch converts
it to be low-to-high edge triggered instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stuib.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stuib.dtsi b/arch/arm/boot/dts/stuib.dtsi
index 6c7e492..39446a2 100644
--- a/arch/arm/boot/dts/stuib.dtsi
+++ b/arch/arm/boot/dts/stuib.dtsi
@@ -15,7 +15,7 @@
 			stmpe1601: stmpe1601@40 {
 				compatible = "st,stmpe1601";
 				reg = <0x40>;
-				interrupts = <26 0x4>;
+				interrupts = <26 0x1>;
 				interrupt-parent = <&gpio6>;
 				interrupt-controller;
 
-- 
1.7.9.5

