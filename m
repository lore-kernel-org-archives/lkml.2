Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354Ab0J1SaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:30:00 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:35477 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0J1S3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:29:55 -0400
Date: Thu, 28 Oct 2010 20:29:53 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] amiserial: Remove unused variable icount
Message-ID: <alpine.DEB.2.00.1010282027480.29737@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/amiserial.c: In function ¡rs_ioctl¢:
drivers/char/amiserial.c:1302: warning: unused variable ¡icount¢

commit 0587102cf9f427c185bfdeb2cef41e13ee0264b1 ("tty: icount changeover for
other main devices") removed the users, but not the actual variable.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/amiserial.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index b0a7046..c0bd6f4 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1299,7 +1299,6 @@ static int rs_ioctl(struct tty_struct *tty, struct file * file,
 {
 	struct async_struct * info = tty->driver_data;
 	struct async_icount cprev, cnow;	/* kernel counter temps */
-	struct serial_icounter_struct icount;
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
 
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
