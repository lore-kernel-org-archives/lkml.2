Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848Ab2FDU2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:28:04 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab2FDU1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:27:54 -0400
From: Richard Weinberger <richard@nod.at>
To: jslaby@suse.cz
Cc: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        alan@linux.intel.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/6] um: Remove dead code
Date: Mon,  4 Jun 2012 22:27:35 +0200
Message-Id: <1338841657-30358-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338841657-30358-1-git-send-email-richard@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/ssl.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index a39d53e..cba95d9 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -98,27 +98,6 @@ static int ssl_open(struct tty_struct *tty, struct file *filp)
 	return err;
 }
 
-#if 0
-static void ssl_flush_buffer(struct tty_struct *tty)
-{
-	return;
-}
-
-static void ssl_stop(struct tty_struct *tty)
-{
-	printk(KERN_ERR "Someone should implement ssl_stop\n");
-}
-
-static void ssl_start(struct tty_struct *tty)
-{
-	printk(KERN_ERR "Someone should implement ssl_start\n");
-}
-
-void ssl_hangup(struct tty_struct *tty)
-{
-}
-#endif
-
 static const struct tty_operations ssl_ops = {
 	.open 	 		= ssl_open,
 	.close 	 		= line_close,
@@ -131,11 +110,6 @@ static const struct tty_operations ssl_ops = {
 	.set_termios 		= line_set_termios,
 	.throttle 		= line_throttle,
 	.unthrottle 		= line_unthrottle,
-#if 0
-	.stop 	 		= ssl_stop,
-	.start 	 		= ssl_start,
-	.hangup 	 	= ssl_hangup,
-#endif
 };
 
 /* Changed by ssl_init and referenced by ssl_exit, which are both serialized
-- 
1.7.7.3

