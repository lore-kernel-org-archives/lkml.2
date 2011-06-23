Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab1FWWQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:16:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23976 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759791Ab1FWWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:16:08 -0400
Date: Fri, 24 Jun 2011 00:07:13 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 06/37] Remove unneeded version.h includes from arch/mips/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240006140.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in arch/mips/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/mips/include/asm/mach-powertv/dma-coherence.h |    1 -
 arch/mips/lantiq/xway/ebu.c                        |    1 -
 arch/mips/lantiq/xway/pmu.c                        |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/mach-powertv/dma-coherence.h b/arch/mips/include/asm/mach-powertv/dma-coherence.h
index a8e72cf..613baf1 100644
--- a/arch/mips/include/asm/mach-powertv/dma-coherence.h
+++ b/arch/mips/include/asm/mach-powertv/dma-coherence.h
@@ -13,7 +13,6 @@
 #define __ASM_MACH_POWERTV_DMA_COHERENCE_H
 
 #include <linux/sched.h>
-#include <linux/version.h>
 #include <linux/device.h>
 #include <asm/mach-powertv/asic.h>
 
diff --git a/arch/mips/lantiq/xway/ebu.c b/arch/mips/lantiq/xway/ebu.c
index 66eb52f..033b318 100644
--- a/arch/mips/lantiq/xway/ebu.c
+++ b/arch/mips/lantiq/xway/ebu.c
@@ -10,7 +10,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/ioport.h>
 
 #include <lantiq_soc.h>
diff --git a/arch/mips/lantiq/xway/pmu.c b/arch/mips/lantiq/xway/pmu.c
index 9d69f01e..39f0d26 100644
--- a/arch/mips/lantiq/xway/pmu.c
+++ b/arch/mips/lantiq/xway/pmu.c
@@ -8,7 +8,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/ioport.h>
 
 #include <lantiq_soc.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

