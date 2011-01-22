Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1AVW0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:26:03 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:34781 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1AVW0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:26:01 -0500
Date: Sat, 22 Jan 2011 23:25:59 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: Kconfig - Remove unneeded "default n"
Message-ID: <alpine.DEB.2.00.1101222325290.28325@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 0911d7c..ab91cf0 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -18,11 +18,9 @@ config RWSEM_XCHGADD_ALGORITHM
 
 config ARCH_HAS_ILOG2_U32
 	bool
-	default n
 
 config ARCH_HAS_ILOG2_U64
 	bool
-	default n
 
 config GENERIC_HWEIGHT
 	bool
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
