Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0FHUMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:12:39 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:52873 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0FHUMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:12:38 -0400
Date: Tue, 8 Jun 2010 22:12:35 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] alpha/h8300/m68k: Remove obsolete <asm/md.h> files
Message-ID: <alpine.DEB.2.00.1006082208410.23689@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of these started in 2.3.43pre3, ca. 10 years ago.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Arnd: Took me 9 months, but here it is ;-)

 arch/alpha/include/asm/md.h |   13 -------------
 arch/h8300/include/asm/md.h |   13 -------------
 arch/m68k/include/asm/md.h  |   13 -------------
 3 files changed, 0 insertions(+), 39 deletions(-)
 delete mode 100644 arch/alpha/include/asm/md.h
 delete mode 100644 arch/h8300/include/asm/md.h
 delete mode 100644 arch/m68k/include/asm/md.h

diff --git a/arch/alpha/include/asm/md.h b/arch/alpha/include/asm/md.h
deleted file mode 100644
index 6c9b822..0000000
--- a/arch/alpha/include/asm/md.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* $Id: md.h,v 1.1 1997/12/15 15:11:48 jj Exp $
- * md.h: High speed xor_block operation for RAID4/5 
- *
- */
- 
-#ifndef __ASM_MD_H
-#define __ASM_MD_H
-
-/* #define HAVE_ARCH_XORBLOCK */
-
-#define MD_XORBLOCK_ALIGNMENT	sizeof(long)
-
-#endif /* __ASM_MD_H */
diff --git a/arch/h8300/include/asm/md.h b/arch/h8300/include/asm/md.h
deleted file mode 100644
index 1b7300e..0000000
--- a/arch/h8300/include/asm/md.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * md.h: High speed xor_block operation for RAID4/5 
- *
- */
- 
-#ifndef __ASM_MD_H
-#define __ASM_MD_H
-
-/* #define HAVE_ARCH_XORBLOCK */
-
-#define MD_XORBLOCK_ALIGNMENT	sizeof(long)
-
-#endif /* __ASM_MD_H */
diff --git a/arch/m68k/include/asm/md.h b/arch/m68k/include/asm/md.h
deleted file mode 100644
index d2f78f2..0000000
--- a/arch/m68k/include/asm/md.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * md.h: High speed xor_block operation for RAID4/5
- *
- */
-
-#ifndef __ASM_MD_H
-#define __ASM_MD_H
-
-/* #define HAVE_ARCH_XORBLOCK */
-
-#define MD_XORBLOCK_ALIGNMENT	sizeof(long)
-
-#endif /* __ASM_MD_H */
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
