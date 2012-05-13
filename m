Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2EMNuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:50:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54517 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2EMNuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:50:19 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH 2/6] USB: serial: Changes to conform with checkpatch. - spaces around '?' and ':'.
Date: Sun, 13 May 2012 23:52:36 +1000
Message-Id: <1336917160-27059-2-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 14 checkpatch.sh errors.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index b689990..d029a04 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -180,7 +180,7 @@ static void keyspan_set_termios(struct tty_struct *tty,
 	tty_encode_baud_rate(tty, baud_rate, baud_rate);
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
-	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
+	p_priv->flow_control = (cflag & CRTSCTS) ? flow_cts : flow_none;
 
 	/* Mark/Space not supported */
 	tty->termios->c_cflag &= ~CMSPAR;
@@ -1134,7 +1134,7 @@ static int keyspan_open(struct tty_struct *tty, struct usb_serial_port *port)
 	}
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
-	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
+	p_priv->flow_control = (cflag & CRTSCTS) ? flow_cts : flow_none;
 
 	keyspan_send_setup(port, 1);
 	/* mdelay(100); */
@@ -1744,7 +1744,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 		msg.setPrescaler = 0xff;
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -1761,7 +1761,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
@@ -2033,7 +2033,7 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 		/* msg.setPrescaler = 0xff; */
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -2050,7 +2050,7 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
@@ -2219,7 +2219,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 		msg.txMode = TXMODE_BYHAND;
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -2236,7 +2236,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	if (p_priv->old_cflag != p_priv->cflag) {
@@ -2365,7 +2365,7 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 					USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
-- 
1.7.2.5

