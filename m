Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab0KLVm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:42:59 -0500
Received: from kroah.org ([198.145.64.141]:41591 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024Ab0KLVlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/19] amiserial: Remove unused variable icount
Date: Fri, 12 Nov 2010 13:40:59 -0800
Message-Id: <1289598066-10112-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

drivers/char/amiserial.c: In function ?rs_ioctl?:
drivers/char/amiserial.c:1302: warning: unused variable ?icount?

commit 0587102cf9f427c185bfdeb2cef41e13ee0264b1 ("tty: icount changeover for
other main devices") removed the users, but not the actual variable.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.1

