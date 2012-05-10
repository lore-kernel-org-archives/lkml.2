Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab2EJJPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:15:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab2EJJPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:15:10 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 01/21] USB: serial: Changes to conform with checkpatch.sh script. space before tabs.
Date: Thu, 10 May 2012 19:17:07 +1000
Message-Id: <1336641447-23194-2-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 3 checkpatch.sh warnings.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index a39ddd1..e68a383 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -135,7 +135,7 @@ module_usb_serial_driver(keyspan_driver, serial_drivers);
 static void keyspan_break_ctl(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_port_private	*p_priv;
 
 	dbg("%s", __func__);
 
@@ -154,9 +154,9 @@ static void keyspan_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	int				baud_rate, device_port;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
-	unsigned int 			cflag;
+	unsigned int			cflag;
 
 	dbg("%s", __func__);
 
-- 
1.7.2.5

