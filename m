Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab0JPDJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 23:09:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59560 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0JPDJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 23:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xWGEmP0XBMhjyayE2jbK/0Oc1VpUscwH9YqWfYmSdOEXJB4YP7VfCUtM8ot9Eavfsa
         jVrlxD7yzaz7ohXF3/PN/jxDHdnSmPJatr/ih7BflTwSb6Xaw5bbBtGnPly7y0bG2j4B
         HuqdpSH063jPcdaG3SulqOXWayVZ8XAJh6ZYA=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 2/2] Staging: speakup: selection: Coding style fixes
Date: Fri, 15 Oct 2010 23:08:47 -0400
Message-Id: <1287198527-1696-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1287198527-1696-1-git-send-email-tdent48227@gmail.com>
References: <1287198527-1696-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/speakup/selection.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index 1b865ff..81cfc80 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -34,7 +34,7 @@ void speakup_clear_selection(void)
 /* does screen address p correspond to character at LH/RH edge of screen? */
 static int atedge(const int p, int size_row)
 {
-	return (!(p % size_row) || !((p + 2) % size_row));
+	return !(p % size_row) || !((p + 2) % size_row);
 }
 
 /* constrain v such that v <= u */
@@ -139,9 +139,9 @@ int speakup_paste_selection(struct tty_struct *tty)
 		}
 		count = sel_buffer_lth - pasted;
 		count = min_t(int, count, tty->receive_room);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 31)
 		tty->ldisc->ops->receive_buf(tty, sel_buffer + pasted, 0, count);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
 		tty->ldisc.ops->receive_buf(tty, sel_buffer + pasted, 0, count);
 #else
 		tty->ldisc.receive_buf(tty, sel_buffer + pasted, 0, count);
-- 
1.7.3.1.104.gc752e

