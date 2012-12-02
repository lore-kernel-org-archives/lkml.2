Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab2LBPcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 10:32:31 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36007 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2LBPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 10:32:30 -0500
Message-ID: <1354462339.24917.0.camel@phoenix>
Subject: [PATCH] ARM: sunxi: Include linux/delay.h
From: Axel Lin <axel.lin@ingics.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 02 Dec 2012 23:32:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error:

  CC      arch/arm/mach-sunxi/sunxi.o
arch/arm/mach-sunxi/sunxi.c: In function 'sunxi_restart':
arch/arm/mach-sunxi/sunxi.c:55:3: error: implicit declaration of function 'mdelay' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [arch/arm/mach-sunxi/sunxi.o] Error 1
make: *** [arch/arm/mach-sunxi] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 arch/arm/mach-sunxi/sunxi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index dc634ae..fba8d6e 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -12,6 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
-- 
1.7.9.5



