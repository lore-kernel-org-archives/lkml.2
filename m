Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1KRE6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:58:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45877 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab1KRE6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:58:31 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 8/8] Drivers: tty: synclink_gt: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 21:58:26 -0700
Message-Id: <1321592306-8881-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/synclink_gt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 6ea8c93..6faa2de 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -3287,7 +3287,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 
 	DBGINFO(("%s block_til_ready\n", tty->driver->name));
 
-	if (filp->f_flags & O_NONBLOCK || tty->flags & (1 << TTY_IO_ERROR)){
+	if (filp->f_flags & O_NONBLOCK || tty->flags & (1 << TTY_IO_ERROR)) {
 		/* nonblock mode is set or port is not enabled */
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
-- 
1.7.7.3

