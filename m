Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab1KRFlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:41:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61883 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab1KRFlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:41:50 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 21/21] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:41:44 -0700
Message-Id: <1321594904-10245-1-git-send-email-zac.3.14159@gmail.com>
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
index 0f7dd54..30f1787 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -7295,7 +7295,7 @@ static bool mgsl_dma_test( struct mgsl_struct *info )
 	}
 
 
-	if ( rc ){
+	if ( rc ) {
 		/* CHECK FOR TRANSMIT ERRORS */
 		if ( status & (BIT5 + BIT1) ) 
 			rc = false;
-- 
1.7.7.3

