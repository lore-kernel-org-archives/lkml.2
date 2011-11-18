Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1KRFf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:35:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52771 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1KRFfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:35:55 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 19/19] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:35:50 -0700
Message-Id: <1321594550-10058-1-git-send-email-zac.3.14159@gmail.com>
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
index 3d56804..82b5684 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -6555,7 +6555,7 @@ static bool mgsl_get_rx_frame(struct mgsl_struct *info)
 			 * the end of a frame. Reset buffers and receiver.
 			 */
 
-			if ( info->rx_enabled ){
+			if ( info->rx_enabled ) {
 				spin_lock_irqsave(&info->irq_spinlock,flags);
 				usc_start_receiver(info);
 				spin_unlock_irqrestore(&info->irq_spinlock,flags);
-- 
1.7.7.3

