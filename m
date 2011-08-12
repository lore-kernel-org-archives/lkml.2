Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab1HLI0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:26:10 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:41639 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1HLI0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:26:07 -0400
Subject: [PATCH] [ARM] Orion: gpio: add missing include of linux/types.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 16:25:56 +0800
Message-ID: <1313137556.24918.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing include of linux/types.h to fix below build error.

  CC      arch/arm/mach-mv78xx0/mpp.o
In file included from arch/arm/mach-mv78xx0/include/mach/gpio.h:9,
                 from /home/axel/repos/git/linux-2.6/arch/arm/include/asm/gpio.h:5,
                 from include/linux/gpio.h:18,
                 from arch/arm/mach-mv78xx0/mpp.c:10:
arch/arm/plat-orion/include/plat/gpio.h:28: error: expected declaration specifiers or '...' before 'u32'
make[1]: *** [arch/arm/mach-mv78xx0/mpp.o] Error 1
make: *** [arch/arm/mach-mv78xx0] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next tree ( next-20110811 ).

 arch/arm/plat-orion/include/plat/gpio.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-orion/include/plat/gpio.h b/arch/arm/plat-orion/include/plat/gpio.h
index f7d76308..3abf304 100644
--- a/arch/arm/plat-orion/include/plat/gpio.h
+++ b/arch/arm/plat-orion/include/plat/gpio.h
@@ -12,6 +12,7 @@
 #define __PLAT_GPIO_H
 
 #include <linux/init.h>
+#include <linux/types.h>
 
 /*
  * Orion-specific GPIO API extensions.
-- 
1.7.4.1



