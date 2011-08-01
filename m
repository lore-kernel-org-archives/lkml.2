Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1HAVN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:13:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14461 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1HAVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:13:49 -0400
Date: Mon, 1 Aug 2011 23:13:48 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Jiandong Zheng <jdzheng@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH][Resend] Remove unneeded version.h includes from arch/arm/
Message-ID: <alpine.LNX.2.00.1108012312350.31999@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in arch/arm/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/arm/mach-bcmring/irq.c   |    1 -
 arch/arm/mach-bcmring/timer.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-bcmring/irq.c b/arch/arm/mach-bcmring/irq.c
index c48feaf..437fa68 100644
--- a/arch/arm/mach-bcmring/irq.c
+++ b/arch/arm/mach-bcmring/irq.c
@@ -20,7 +20,6 @@
 #include <linux/stddef.h>
 #include <linux/list.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/io.h>
 
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-bcmring/timer.c b/arch/arm/mach-bcmring/timer.c
index 2d415d2..af9c3d7 100644
--- a/arch/arm/mach-bcmring/timer.c
+++ b/arch/arm/mach-bcmring/timer.c
@@ -12,7 +12,6 @@
 * consent.
 *****************************************************************************/
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <csp/tmrHw.h>
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

