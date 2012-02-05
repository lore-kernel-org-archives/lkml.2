Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2BEAUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:20:10 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10618 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2BEAUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:20:09 -0500
Date: Sun, 5 Feb 2012 01:20:35 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Silverstone <dsilvers@simtec.co.uk>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM, KS8695: Only include linux/gpio.h once in
 arch/arm/mach-ks8695/leds.c
Message-ID: <alpine.LNX.2.00.1202050119020.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unneeded duplicate include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/arm/mach-ks8695/leds.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ks8695/leds.c b/arch/arm/mach-ks8695/leds.c
index d6f6502..4bd7075 100644
--- a/arch/arm/mach-ks8695/leds.c
+++ b/arch/arm/mach-ks8695/leds.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/gpio.h>
 
 #include <asm/leds.h>
 #include <mach/devices.h>
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

