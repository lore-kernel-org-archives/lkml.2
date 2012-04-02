Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2DBLzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:55:45 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48046 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 04/69] ISDN: i4l, remove cvs crap
Date: Mon,  2 Apr 2012 13:53:48 +0200
Message-Id: <1333367693-3244-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CVS $Id$ is unused and makes no sense in our tree. Get rid of that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 3831abd..1d701cd 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1,5 +1,4 @@
-/* $Id: isdn_tty.c,v 1.1.2.3 2004/02/10 01:07:13 keil Exp $
- *
+/*
  * Linux ISDN subsystem, tty functions and AT-command emulator (linklevel).
  *
  * Copyright 1994-1999  by Fritz Elfert (fritz@isdn4linux.de)
@@ -48,9 +47,6 @@ static int bit2si[8] =
 static int si2bit[8] =
 {4, 1, 4, 4, 4, 4, 4, 4};
 
-char *isdn_tty_revision = "$Revision: 1.1.2.3 $";
-
-
 /* isdn_tty_try_read() is called from within isdn_tty_rcv_skb()
  * to stuff incoming data directly into a tty's flip-buffer. This
  * is done to speed up tty-receiving if the receive-queue is empty.
-- 
1.7.9.2


