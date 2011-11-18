Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1KRFXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:23:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45767 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1KRFXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:23:24 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 14/14] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:23:17 -0700
Message-Id: <1321593797-9571-1-git-send-email-zac.3.14159@gmail.com>
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
index 92d3250..31efa3c 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3319,7 +3319,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		
 		set_current_state(TASK_INTERRUPTIBLE);
 		
-		if (tty_hung_up_p(filp) || !(port->flags & ASYNC_INITIALIZED)){
+		if (tty_hung_up_p(filp) || !(port->flags & ASYNC_INITIALIZED)) {
 			retval = (port->flags & ASYNC_HUP_NOTIFY) ?
 					-EAGAIN : -ERESTARTSYS;
 			break;
-- 
1.7.7.3

