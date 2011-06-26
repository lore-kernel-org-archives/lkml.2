Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab1FZITv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 04:19:51 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:47113 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1FZITq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 04:19:46 -0400
Date: Sun, 26 Jun 2011 10:19:44 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
Message-ID: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k allmodconfig:

drivers/bcma/main.c: In function ¡bcma_release_core_dev¢:
drivers/bcma/main.c:68: error: implicit declaration of function ¡kfree¢

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
--
http://kisskb.ellerman.id.au/kisskb/buildresult/4243344/

 drivers/bcma/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index ba15105..08a14a3 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -7,6 +7,7 @@
 
 #include "bcma_private.h"
 #include <linux/bcma/bcma.h>
+#include <linux/slab.h>
 
 MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
 MODULE_LICENSE("GPL");
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
