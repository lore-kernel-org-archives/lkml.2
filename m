Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0FEThT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:37:19 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:56688 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab0FEThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:37:17 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jun 2010 15:37:17 EDT
Date: Sat, 5 Jun 2010 21:32:15 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/range: Remove unused definition of ARRAY_SIZE()
Message-ID: <alpine.DEB.2.00.1006052131230.15241@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate definition of ARRAY_SIZE(), which was never used anyway.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/range.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/range.c b/kernel/range.c
index 74e2e61..471b66a 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -7,10 +7,6 @@
 
 #include <linux/range.h>
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
-
 int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
 {
 	if (start >= end)
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
