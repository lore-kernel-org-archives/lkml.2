Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2E1OTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:19:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39662 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2E1OTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:19:43 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH 2/6] USB: serial: Changes to conform with checkpatch.sh script. - spaces around '?' and ':'.
Date: Tue, 29 May 2012 00:21:56 +1000
Message-Id: <1338214920-32708-3-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1338214920-32708-1-git-send-email-puzzleduck@gmail.com>
References: <1338214920-32708-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 14 checkpatch.sh errors.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 23cc8ec..4389736 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -176,7 +176,7 @@ static void keyspan_set_termios(struct tty_struct *tty,
 	tty_encode_baud_rate(tty, baud_rate, baud_rate);
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
-	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
+	p_priv->flow_control = (cflag & CRTSCTS) ? flow_cts : flow_none;
 
 	/* Mark/Space not supported */
 	tty->termios->c_cflag &= ~CMSPAR;
@@ -1102,7 +1102,7 @@ static int keyspan_open(struct tty_struct *tty, struct usb_serial_port *port)
 	}
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
-	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
+	p_priv->flow_control = (cflag & CRTSCTS) ? flow_cts : flow_none;
 
 	keyspan_send_setup(port, 1);
 	/* mdelay(100); */
@@ -1709,7 +1709,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 		msg.setPrescaler = 0xff;
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -1726,7 +1726,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
@@ -1994,7 +1994,7 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 		/* msg.setPrescaler = 0xff; */
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -2011,7 +2011,7 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	msg.setLcr = 0xff;
@@ -2178,7 +2178,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 		msg.txMode = TXMODE_BYHAND;
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -2195,7 +2195,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	if (p_priv->old_cflag != p_priv->cflag) {
@@ -2322,7 +2322,7 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
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

