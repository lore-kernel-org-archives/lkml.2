Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0EWJZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:25:12 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:56980 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab0EWJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:25:03 -0400
Date: Sun, 23 May 2010 11:25:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: Enable atomic64_t
Message-ID: <alpine.DEB.2.00.1005231124380.1975@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig              |    1 +
 arch/m68k/include/asm/atomic.h |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 2921c86..40c31fa 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -7,6 +7,7 @@ config M68K
 	default y
 	select HAVE_AOUT
 	select HAVE_IDE
+	select GENERIC_ATOMIC64
 
 config MMU
 	bool
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 8d29145..eab36dc 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -3,3 +3,5 @@
 #else
 #include "atomic_mm.h"
 #endif
+
+#include <asm-generic/atomic64.h>
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
