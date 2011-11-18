Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1KRFQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:16:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55725 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1KRFQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:16:23 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 12/12] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:16:17 -0700
Message-Id: <1321593377-9361-1-git-send-email-zac.3.14159@gmail.com>
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
index 4a457a3..0a9dfeb 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1387,7 +1387,7 @@ static void mgsl_isr_io_pin( struct mgsl_struct *info )
 	info->pending_bh |= BH_STATUS;
 	
 	/* for diagnostics set IRQ flag */
-	if ( status & MISCSTATUS_TXC_LATCHED ){
+	if ( status & MISCSTATUS_TXC_LATCHED ) {
 		usc_OutReg( info, SICR,
 			(unsigned short)(usc_InReg(info,SICR) & ~(SICR_TXC_ACTIVE+SICR_TXC_INACTIVE)) );
 		usc_UnlatchIostatusBits( info, MISCSTATUS_TXC_LATCHED );
-- 
1.7.7.3

