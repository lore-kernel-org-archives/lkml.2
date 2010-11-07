Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0KGW1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:27:01 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22911 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0KGW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:27:00 -0500
Date: Sun, 7 Nov 2010 23:15:41 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH][trivial] ARM, mm: Don't include smp_plat.h twice in
 flush.c
Message-ID: <alpine.LNX.2.00.1011072312490.26247@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's enough to include the asm/smp_plat.h once in arch/arm/mm/flush.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 flush.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 391ffae..7d6e92b 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -17,7 +17,6 @@
 #include <asm/smp_plat.h>
 #include <asm/system.h>
 #include <asm/tlbflush.h>
-#include <asm/smp_plat.h>
 
 #include "mm.h"
 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

