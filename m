Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318Ab2FVPUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:20:51 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40730 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762237Ab2FVPUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:20:49 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/12] f81232: correct stubbed termios handler
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:36:42 +0100
Message-ID: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/f81232.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 499b15f..acd3267 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -177,6 +177,7 @@ static void f81232_set_termios(struct tty_struct *tty,
 		return;
 
 	/* Do the real work here... */
+	tty_termios_copy_hw(&tty->termios, old_termios);
 }
 
 static int f81232_tiocmget(struct tty_struct *tty)

