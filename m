Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab2KSF2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:28:47 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41432 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2KSF2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:28:46 -0500
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 01/58] pty: Mark pty_resize static
Date: Sun, 18 Nov 2012 21:27:40 -0800
Message-Id: <1353302917-13995-2-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of drivers/tty/pty.c references pty_resize.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/tty/pty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index a82b399..2fd1ae7 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -245,7 +245,7 @@ static void pty_set_termios(struct tty_struct *tty,
  *	peform a terminal resize correctly
  */
 
-int pty_resize(struct tty_struct *tty,  struct winsize *ws)
+static int pty_resize(struct tty_struct *tty,  struct winsize *ws)
 {
 	struct pid *pgrp, *rpgrp;
 	unsigned long flags;
-- 
1.7.10.4

