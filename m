Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2DBMK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:10:56 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47939 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 09/69] TTY: isdn, remove unused members from modem_info
Date: Mon,  2 Apr 2012 13:53:53 +0200
Message-Id: <1333367693-3244-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

session and pgrp are unused. Prune them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 include/linux/isdn.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/isdn.h b/include/linux/isdn.h
index 66d9d71..63af320 100644
--- a/include/linux/isdn.h
+++ b/include/linux/isdn.h
@@ -443,8 +443,6 @@ typedef struct modem_info {
   int			line;
   int			count;		 /* # of fd on device              */
   int			blocked_open;	 /* # of blocked opens             */
-  long			session;	 /* Session of opening process     */
-  long			pgrp;		 /* pgrp of opening process        */
   int                   online;          /* 1 = B-Channel is up, drop data */
 					 /* 2 = B-Channel is up, deliver d.*/
   int                   dialing;         /* Dial in progress or ATA        */
-- 
1.7.9.2


