Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1KREyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:54:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56167 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab1KREye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:54:34 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 7/7] Drivers: tty: synclink_gt: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 21:54:29 -0700
Message-Id: <1321592069-8734-1-git-send-email-zac.3.14159@gmail.com>
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
index 18b48cd..6ea8c93 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -675,7 +675,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 	DBGINFO(("%s open, old ref count = %d\n", info->device_name, info->port.count));
 
 	/* If port is closing, signal caller to try again */
-	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
+	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING) {
 		if (info->port.flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->port.close_wait);
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
-- 
1.7.7.3

