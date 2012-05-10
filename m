Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2EJJT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:19:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab2EJJQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:16:25 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 14/21] USB: serial: Changes to conform with checkpatch.sh script. space before tabs.
Date: Thu, 10 May 2012 19:17:20 +1000
Message-Id: <1336641447-23194-15-git-send-email-puzzleduck@gmail.com>
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
index 6bb61b6..61ed0e2 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1847,11 +1847,11 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa28_portControlMessage	msg;
-	struct keyspan_serial_private	 	*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
-	int 					device_port, err;
+	int					device_port, err;
 
 	dbg("%s", __func__);
 
@@ -1973,12 +1973,12 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa49_portControlMessage	msg;
-	struct usb_ctrlrequest 			*dr = NULL;
-	struct keyspan_serial_private 		*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct usb_ctrlrequest			*dr = NULL;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
-	int 					err, device_port;
+	int					err, device_port;
 
 	dbg("%s", __func__);
 
-- 
1.7.2.5

