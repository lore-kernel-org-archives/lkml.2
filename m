Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2KFNwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:52:02 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2KFNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:52:00 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, Fabio Baltieri <fabio.baltieri@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: dts: add missing ux500 device trees
Date: Tue,  6 Nov 2012 14:51:11 +0100
Message-Id: <1352209871-25202-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds hrefprev60, hrefv60plus and ccu9540 to device trees compiled
during build.

Cc: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
Hi Lee,

this applies on top of your ste-dt-for-next and allows you to remove manual
device-tree building in your scripts.

Please let me know if you think these patches should be pushed somewhere in the
gerrit or in some list - this stacks on top of your so you I don't think it
makes sense for me to subit it directly to a public list.

Fabio

 arch/arm/boot/dts/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f37cf9f..01433b9 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -74,7 +74,10 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	am335x-evm.dtb \
 	am335x-bone.dtb
 dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
-dtb-$(CONFIG_ARCH_U8500) += snowball.dtb
+dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
+	hrefprev60.dtb \
+	hrefv60plus.dtb \
+	ccu9540.dtb
 dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
 	r8a7740-armadillo800eva.dtb \
 	sh73a0-kzm9g.dtb
-- 
1.7.12.1

