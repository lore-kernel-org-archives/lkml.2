Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab2EJJVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:21:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab2EJJPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:15:53 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 08/21] USB: serial: Changes to conform with checkpatch.sh script. space before tabs.
Date: Thu, 10 May 2012 19:17:14 +1000
Message-Id: <1336641447-23194-9-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 7 checkpatch.sh warnings.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 6d89779..6e9d8a6 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -881,11 +881,11 @@ static void usa90_indat_callback(struct urb *urb)
 
 static void	usa90_instat_callback(struct urb *urb)
 {
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa90_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct			*tty;
 	int old_dcd_state, err;
 	int status = urb->status;
@@ -949,11 +949,11 @@ static void	usa90_outcont_callback(struct urb *urb)
 static void	usa67_instat_callback(struct urb *urb)
 {
 	int					err;
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa67_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	int old_dcd_state;
 	int status = urb->status;
 
@@ -1065,9 +1065,9 @@ static int keyspan_write_room(struct tty_struct *tty)
 
 static int keyspan_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct keyspan_port_private 	*p_priv;
-	struct keyspan_serial_private 	*s_priv;
-	struct usb_serial 		*serial = port->serial;
+	struct keyspan_port_private	*p_priv;
+	struct keyspan_serial_private	*s_priv;
+	struct usb_serial		*serial = port->serial;
 	const struct keyspan_device_details	*d_details;
 	int				i, err;
 	int				baud_rate, device_port;
-- 
1.7.2.5

