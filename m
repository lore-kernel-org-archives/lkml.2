Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1KRFqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:46:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55858 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab1KRFqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:46:51 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 23/23] Drivers: tty: synclinkmp: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:46:45 -0700
Message-Id: <1321595205-10431-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/synclinkmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 07fe625..f8c1b2e 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -3300,7 +3300,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		printk("%s(%d):%s block_til_ready()\n",
 			 __FILE__,__LINE__, tty->driver->name );
 
-	if (filp->f_flags & O_NONBLOCK || tty->flags & (1 << TTY_IO_ERROR)){
+	if (filp->f_flags & O_NONBLOCK || tty->flags & (1 << TTY_IO_ERROR)) {
 		/* nonblock mode is set or port is not enabled */
 		/* just verify that callout device is not active */
 		port->flags |= ASYNC_NORMAL_ACTIVE;
-- 
1.7.7.3

