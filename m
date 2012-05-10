Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab2EJJQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:16:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab2EJJQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:16:14 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 12/21] USB: serial: Changes to conform with checkpatch.sh script. space before tabs.
Date: Thu, 10 May 2012 19:17:18 +1000
Message-Id: <1336641447-23194-13-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 9 checkpatch.sh warnings.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 8259bfe..9b18357 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1431,7 +1431,7 @@ static struct callbacks {
 static void keyspan_setup_urbs(struct usb_serial *serial)
 {
 	int				i, j;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	const struct keyspan_device_details	*d_details;
 	struct usb_serial_port		*port;
 	struct keyspan_port_private	*p_priv;
@@ -1507,7 +1507,7 @@ static void keyspan_setup_urbs(struct usb_serial *serial)
 static int keyspan_usa19_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				   u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		div,	/* divisor */
 		cnt;	/* inverse of divisor (programmed into 8051) */
 
@@ -1547,7 +1547,7 @@ static int keyspan_usa19_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa19hs_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				   u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 			div;	/* divisor */
 
 	dbg("%s - %d.", __func__, baud_rate);
@@ -1582,7 +1582,7 @@ static int keyspan_usa19hs_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa19w_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				    u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		clk,	/* clock with 13/8 prescaler */
 		div,	/* divisor using 13/8 prescaler */
 		res,	/* resulting baud rate using 13/8 prescaler */
@@ -1645,7 +1645,7 @@ static int keyspan_usa19w_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa28_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				    u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		div,	/* divisor */
 		cnt;	/* inverse of divisor (programmed into 8051) */
 
@@ -1691,12 +1691,12 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa26_portControlMessage	msg;
-	struct keyspan_serial_private 		*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
-	int 					outcont_urb;
+	int					outcont_urb;
 	struct urb				*this_urb;
-	int 					device_port, err;
+	int					device_port, err;
 
 	dbg("%s reset=%d", __func__, reset_port);
 
-- 
1.7.2.5

