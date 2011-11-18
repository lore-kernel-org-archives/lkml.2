Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1KRFZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:25:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57608 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1KRFZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:25:27 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 15/15] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:25:20 -0700
Message-Id: <1321593920-9667-1-git-send-email-zac.3.14159@gmail.com>
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
index 31efa3c..4183441 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3402,7 +3402,7 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 			 __FILE__,__LINE__,tty->driver->name, info->port.count);
 
 	/* If port is closing, signal caller to try again */
-	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
+	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING) {
 		if (info->port.flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->port.close_wait);
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-- 
1.7.7.3

