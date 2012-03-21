Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab2CUJwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:52:08 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:54936 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab2CUJwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:52:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 01/11] m68k: Remove unused MAX_NOINT_IPL definition
Date: Wed, 21 Mar 2012 10:51:45 +0100
Message-Id: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/entry.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/entry.h b/arch/m68k/include/asm/entry.h
index 622138d..5d8b21c 100644
--- a/arch/m68k/include/asm/entry.h
+++ b/arch/m68k/include/asm/entry.h
@@ -35,11 +35,9 @@
 #if defined(MACH_ATARI_ONLY)
 	/* block out HSYNC on the atari */
 #define ALLOWINT	(~0x400)
-#define	MAX_NOINT_IPL	3
 #else
 	/* portable version */
 #define ALLOWINT	(~0x700)
-#define	MAX_NOINT_IPL	0
 #endif /* machine compilation types */
 
 #ifdef __ASSEMBLY__
-- 
1.7.0.4

