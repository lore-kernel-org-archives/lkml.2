Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1AJV3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:29:34 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15243 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab1AJV3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:29:33 -0500
Date: Mon, 10 Jan 2011 22:29:32 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, trivial@kernel.org
Subject: [PATCH] ARM AT91SAM9M10G45: Remove duplicate inclusion of
 mach/hardware.h
Message-ID: <alpine.LNX.2.00.1101102225550.32164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate inclusion of mach/hardware.h

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 board-sam9m10g45ek.c |    1 -
 1 file changed, 1 deletion(-)

  Completely untested. I don't have any way of even compiling this, but I 
  think it's fairly obviously correct.

diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 86ff4b5..6c999db 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -29,23 +29,22 @@
 #include <mach/hardware.h>
 #include <video/atmel_lcdc.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include <mach/hardware.h>
 #include <mach/board.h>
 #include <mach/gpio.h>
 #include <mach/at91sam9_smc.h>
 #include <mach/at91_shdwc.h>
 
 #include "sam9_smc.h"
 #include "generic.h"
 
 
 static void __init ek_map_io(void)
 {


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

