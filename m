Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1BCV7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:59:19 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13081 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab1BCV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:59:15 -0500
Date: Thu, 3 Feb 2011 22:58:18 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, trivial@kernel.org
Subject: [PATCH][trivial] ARM, OMAP, timer: Remove duplicate inclusion of
 linux/sched.h from arch/arm/mach-omap1/time.c
Message-ID: <alpine.LNX.2.00.1102032255090.1369@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-omap1/time.c includes linux/sched.h twice - it's enough to 
do it once. This removes the duplicate.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 time.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index f83fc33..6885d2f 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -44,7 +44,6 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/io.h>
-#include <linux/sched.h>
 
 #include <asm/system.h>
 #include <mach/hardware.h>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

