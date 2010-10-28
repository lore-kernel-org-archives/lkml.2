Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378Ab0J1Sb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:31:59 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:37697 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761286Ab0J1Sbz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:31:55 -0400
Date: Thu, 28 Oct 2010 20:31:53 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
cc: netdev@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] net: atarilance - flags should be unsigned long
Message-ID: <alpine.DEB.2.00.1010282030530.29788@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/atarilance.c: In function ¡addr_accessible¢:
drivers/net/atarilance.c:413: warning: comparison of distinct pointer types lacks a cast
drivers/net/atarilance.c:450: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/atarilance.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atarilance.c b/drivers/net/atarilance.c
index 3134e53..8cb27cb 100644
--- a/drivers/net/atarilance.c
+++ b/drivers/net/atarilance.c
@@ -407,7 +407,7 @@ static noinline int __init addr_accessible(volatile void *regp, int wordflag,
 					   int writeflag)
 {
 	int		ret;
-	long	flags;
+	unsigned long	flags;
 	long	*vbr, save_berr;
 
 	local_irq_save(flags);
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
