Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1KRFTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:19:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61637 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1KRFTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:19:09 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 13/13] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:19:04 -0700
Message-Id: <1321593544-9460-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/synclink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 0a9dfeb..92d3250 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3282,7 +3282,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		printk("%s(%d):block_til_ready on %s\n",
 			 __FILE__,__LINE__, tty->driver->name );
 
-	if (filp->f_flags & O_NONBLOCK || tty->flags & (1 << TTY_IO_ERROR)){
+	if (filp->f_flags & O_NONBLOCK || tty->flags & (1 << TTY_IO_ERROR)) {
 		/* nonblock mode is set or port is not enabled */
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
-- 
1.7.7.3

