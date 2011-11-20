Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1KTU77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 15:59:59 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10779 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1KTU75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 15:59:57 -0500
Date: Sun, 20 Nov 2011 21:59:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-hexagon@vger.kernel.org
cc: Richard Kuo <rkuo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unneeded include of version.h from
 arch/hexagon/include/asm/spinlock_types.h
Message-ID: <alpine.LNX.2.00.1111202157170.17195@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make versioncheck" points out that arch/hexagon/include/asm/spinlock_types.h
does not need to include version.h .
A quick look at the file seems to confirm its findings, so here's a patch that
removes the include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/hexagon/include/asm/spinlock_types.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

 Please note: I've not done any compile tests or other tests to confirm 
              this patch since I have no way to build stuff for this 
              architecture, so please review carefully before applying.

diff --git a/arch/hexagon/include/asm/spinlock_types.h b/arch/hexagon/include/asm/spinlock_types.h
index 5e937af..99b5a75 100644
--- a/arch/hexagon/include/asm/spinlock_types.h
+++ b/arch/hexagon/include/asm/spinlock_types.h
@@ -21,8 +21,6 @@
 #ifndef _ASM_SPINLOCK_TYPES_H
 #define _ASM_SPINLOCK_TYPES_H
 
-#include <linux/version.h>
-
 #ifndef __LINUX_SPINLOCK_TYPES_H
 # error "please don't include this file directly"
 #endif
-- 
1.7.7.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

