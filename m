Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab2EJJPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:15:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37217 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab2EJJPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:15:48 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 07/21] USB: serial: Changes to conform with checkpatch.sh script. space before tabs.
Date: Thu, 10 May 2012 19:17:13 +1000
Message-Id: <1336641447-23194-8-git-send-email-puzzleduck@gmail.com>
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
index 40806d0..6d89779 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -617,11 +617,11 @@ static void	usa49_glocont_callback(struct urb *urb)
 static void	usa49_instat_callback(struct urb *urb)
 {
 	int					err;
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa49_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	int old_dcd_state;
 	int status = urb->status;
 
@@ -688,7 +688,7 @@ static void	usa49_indat_callback(struct urb *urb)
 	int			endpoint;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	dbg("%s", __func__);
@@ -739,7 +739,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	dbg("%s", __func__);
@@ -814,9 +814,9 @@ static void usa90_indat_callback(struct urb *urb)
 	int			i, err;
 	int			endpoint;
 	struct usb_serial_port	*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	dbg("%s", __func__);
-- 
1.7.2.5

