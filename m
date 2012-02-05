Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2BEASG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:18:06 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10549 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab2BEASE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:18:04 -0500
Date: Sun, 5 Feb 2012 01:18:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>,
        Jiandong Zheng <jdzheng@broadcom.com>
Subject: [PATCH] Only include linux/sched.h once in
 arch/arm/mach-bcmring/dma.c
Message-ID: <alpine.LNX.2.00.1202050116190.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to include the header twice.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/arm/mach-bcmring/dma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
index 1024396..e5fd241 100644
--- a/arch/arm/mach-bcmring/dma.c
+++ b/arch/arm/mach-bcmring/dma.c
@@ -35,7 +35,6 @@
 
 #include <linux/pfn.h>
 #include <linux/atomic.h>
-#include <linux/sched.h>
 #include <mach/dma.h>
 
 /* ---- Public Variables ------------------------------------------------- */
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

