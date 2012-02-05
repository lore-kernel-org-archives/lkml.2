Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2BEAWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:22:05 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10686 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2BEAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:22:03 -0500
Date: Sun, 5 Feb 2012 01:22:29 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: Remove duplicate asm/memblock.h include from
 arch/arm/mm/init.c
Message-ID: <alpine.LNX.2.00.1202050121060.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to include the header twice, so get rid of the
duplicate.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/arm/mm/init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 5dc7d12..245a55a 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -32,7 +32,6 @@
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <asm/memblock.h>
 
 #include "mm.h"
 
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

