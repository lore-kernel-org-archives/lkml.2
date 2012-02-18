Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2BRKuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 05:50:51 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:58827
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2BRKuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 05:50:50 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] serial: Fix typo in sn_console.c
Date: Sat, 18 Feb 2012 19:49:47 +0900
Message-Id: <1329562187-1597-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "receieve" to "receive" in
drivers/tty/serial/sn_console.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/tty/serial/sn_console.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sn_console.c b/drivers/tty/serial/sn_console.c
index 238c7df..4e1b551 100644
--- a/drivers/tty/serial/sn_console.c
+++ b/drivers/tty/serial/sn_console.c
@@ -461,12 +461,12 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 	struct tty_struct *tty;
 
 	if (!port) {
-		printk(KERN_ERR "sn_receive_chars - port NULL so can't receieve\n");
+		printk(KERN_ERR "sn_receive_chars - port NULL so can't receive\n");
 		return;
 	}
 
 	if (!port->sc_ops) {
-		printk(KERN_ERR "sn_receive_chars - port->sc_ops  NULL so can't receieve\n");
+		printk(KERN_ERR "sn_receive_chars - port->sc_ops  NULL so can't receive\n");
 		return;
 	}
 
-- 
1.7.1

