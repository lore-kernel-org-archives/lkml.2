Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1KRFK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:10:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36506 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1KRFK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:10:26 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 11/11] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:10:19 -0700
Message-Id: <1321593019-9266-1-git-send-email-zac.3.14159@gmail.com>
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
index e67fb20..4a457a3 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1194,7 +1194,7 @@ static void mgsl_isr_receive_status( struct mgsl_struct *info )
 		wake_up_interruptible(&info->event_wait_q);
 	}
 
-	if (status & RXSTATUS_OVERRUN){
+	if (status & RXSTATUS_OVERRUN) {
 		info->icount.rxover++;
 		usc_process_rxoverrun_sync( info );
 	}
-- 
1.7.7.3

