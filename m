Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2EJJYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:24:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab2EJJPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:15:21 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 03/21] USB: serial: Changes to conform with checkpatch.sh script. space before tabs.
Date: Thu, 10 May 2012 19:17:09 +1000
Message-Id: <1336641447-23194-4-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 6 checkpatch.sh warnings.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 7cbc485..9dfd154 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -227,12 +227,12 @@ static int keyspan_tiocmset(struct tty_struct *tty,
 static int keyspan_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count)
 {
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
 	int				flip;
-	int 				left, todo;
+	int				left, todo;
 	struct urb			*this_urb;
-	int 				err, maxDataLen, dataOffset;
+	int				err, maxDataLen, dataOffset;
 
 	p_priv = usb_get_serial_port_data(port);
 	d_details = p_priv->device_details;
@@ -303,7 +303,7 @@ static void	usa26_indat_callback(struct urb *urb)
 	int			endpoint;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	dbg("%s", __func__);
@@ -390,11 +390,11 @@ static void	usa26_outcont_callback(struct urb *urb)
 
 static void	usa26_instat_callback(struct urb *urb)
 {
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa26_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct			*tty;
 	int old_dcd_state, err;
 	int status = urb->status;
-- 
1.7.2.5

