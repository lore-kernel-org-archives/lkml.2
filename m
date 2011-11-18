Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab1KRFoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:44:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab1KRFoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:44:24 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 22/22] Drivers: tty: synclinkmp: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:44:19 -0700
Message-Id: <1321595059-10339-1-git-send-email-zac.3.14159@gmail.com>
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
index 0f6b796..07fe625 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -746,7 +746,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 			 __FILE__,__LINE__,tty->driver->name, info->port.count);
 
 	/* If port is closing, signal caller to try again */
-	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
+	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING) {
 		if (info->port.flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->port.close_wait);
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-- 
1.7.7.3

