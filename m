Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab1EZJmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:42:50 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26413 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab1EZJmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:42:49 -0400
Date: Thu, 26 May 2011 11:35:08 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: Andrew Lunn <andrew@lunn.ch>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH][Trivial] ARM: remove duplicate include from
 arch/arm/mach-dove/common.c
Message-ID: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate linux/serial_8250.h include from 
arch/arm/mach-dove/common.c that was introduced by commit 
5c60255149eece2a36ec9f5c99817b85f96fe8ec .

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 common.c |    1 -
 1 file changed, 1 deletion(-)

 note: untested patch since I have no way to really build arm stuff.
       patch is against Linus' tree.

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 5ed51b8..b6c3d6b 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -17,7 +17,6 @@
 #include <linux/clk.h>
 #include <linux/mbus.h>
 #include <linux/ata_platform.h>
-#include <linux/serial_8250.h>
 #include <linux/gpio.h>
 #include <asm/page.h>
 #include <asm/setup.h>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

