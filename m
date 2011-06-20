Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1FTItS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:49:18 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12011 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1FTItR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:49:17 -0400
Date: Mon, 20 Jun 2011 10:40:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate linux/leds.h
 include
Message-ID: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the duplicate inclusion of linux/leds.h from 
arch/arm/mach-s3c2410/h1940-bluetooth.c that was added by commit 50e2d10d.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 h1940-bluetooth.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-s3c2410/h1940-bluetooth.c b/arch/arm/mach-s3c2410/h1940-bluetooth.c
index 2c126bb..a5eeb62 100644
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -18,7 +18,6 @@
 #include <linux/leds.h>
 #include <linux/gpio.h>
 #include <linux/rfkill.h>
-#include <linux/leds.h>
 
 #include <mach/regs-gpio.h>
 #include <mach/hardware.h>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

