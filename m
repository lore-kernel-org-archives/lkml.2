Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2E1OTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:19:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56860 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2E1OTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:19:39 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH 1/6] USB: serial: Changes to conform with checkpatch.sh script. - no space before tabs
Date: Tue, 29 May 2012 00:21:55 +1000
Message-Id: <1338214920-32708-2-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1338214920-32708-1-git-send-email-puzzleduck@gmail.com>
References: <1338214920-32708-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 52 checkpatch.sh warnings.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |  106 +++++++++++++++++++++---------------------
 1 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index a1b9924..23cc8ec 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -135,7 +135,7 @@ module_usb_serial_driver(serial_drivers, keyspan_ids_combined);
 static void keyspan_break_ctl(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_port_private	*p_priv;
 
 	p_priv = usb_get_serial_port_data(port);
 
@@ -152,9 +152,9 @@ static void keyspan_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	int				baud_rate, device_port;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
-	unsigned int 			cflag;
+	unsigned int			cflag;
 
 	p_priv = usb_get_serial_port_data(port);
 	d_details = p_priv->device_details;
@@ -223,12 +223,12 @@ static int keyspan_tiocmset(struct tty_struct *tty,
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
@@ -299,7 +299,7 @@ static void	usa26_indat_callback(struct urb *urb)
 	int			endpoint;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	endpoint = usb_pipeendpoint(urb->pipe);
@@ -382,11 +382,11 @@ static void	usa26_outcont_callback(struct urb *urb)
 
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
@@ -514,11 +514,11 @@ static void	usa28_outcont_callback(struct urb *urb)
 static void	usa28_instat_callback(struct urb *urb)
 {
 	int					err;
-	unsigned char 				*data = urb->transfer_buffer;
+	unsigned char				*data = urb->transfer_buffer;
 	struct keyspan_usa28_portStatusMessage	*msg;
 	struct usb_serial			*serial;
 	struct usb_serial_port			*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct			*tty;
 	int old_dcd_state;
 	int status = urb->status;
@@ -602,11 +602,11 @@ static void	usa49_glocont_callback(struct urb *urb)
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
 
@@ -670,7 +670,7 @@ static void	usa49_indat_callback(struct urb *urb)
 	int			endpoint;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	endpoint = usb_pipeendpoint(urb->pipe);
@@ -719,7 +719,7 @@ static void usa49wg_indat_callback(struct urb *urb)
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	serial = urb->context;
@@ -791,9 +791,9 @@ static void usa90_indat_callback(struct urb *urb)
 	int			i, err;
 	int			endpoint;
 	struct usb_serial_port	*port;
-	struct keyspan_port_private	 	*p_priv;
+	struct keyspan_port_private		*p_priv;
 	struct tty_struct	*tty;
-	unsigned char 		*data = urb->transfer_buffer;
+	unsigned char		*data = urb->transfer_buffer;
 	int status = urb->status;
 
 	endpoint = usb_pipeendpoint(urb->pipe);
@@ -856,11 +856,11 @@ static void usa90_indat_callback(struct urb *urb)
 
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
@@ -924,11 +924,11 @@ static void	usa90_outcont_callback(struct urb *urb)
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
 
@@ -1035,9 +1035,9 @@ static int keyspan_write_room(struct tty_struct *tty)
 
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
@@ -1130,8 +1130,8 @@ static void keyspan_close(struct usb_serial_port *port)
 {
 	int			i;
 	struct usb_serial	*serial = port->serial;
-	struct keyspan_serial_private 	*s_priv;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_serial_private	*s_priv;
+	struct keyspan_port_private	*p_priv;
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -1167,8 +1167,8 @@ static void keyspan_close(struct usb_serial_port *port)
 /* download the firmware to a pre-renumeration device */
 static int keyspan_fake_startup(struct usb_serial *serial)
 {
-	int 				response;
-	const struct ihex_binrec 	*record;
+	int				response;
+	const struct ihex_binrec	*record;
 	char				*fw_name;
 	const struct firmware		*fw;
 
@@ -1398,7 +1398,7 @@ static struct callbacks {
 static void keyspan_setup_urbs(struct usb_serial *serial)
 {
 	int				i, j;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	const struct keyspan_device_details	*d_details;
 	struct usb_serial_port		*port;
 	struct keyspan_port_private	*p_priv;
@@ -1472,7 +1472,7 @@ static void keyspan_setup_urbs(struct usb_serial *serial)
 static int keyspan_usa19_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				   u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		div,	/* divisor */
 		cnt;	/* inverse of divisor (programmed into 8051) */
 
@@ -1512,7 +1512,7 @@ static int keyspan_usa19_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa19hs_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				   u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 			div;	/* divisor */
 
 	dbg("%s - %d.", __func__, baud_rate);
@@ -1547,7 +1547,7 @@ static int keyspan_usa19hs_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa19w_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				    u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		clk,	/* clock with 13/8 prescaler */
 		div,	/* divisor using 13/8 prescaler */
 		res,	/* resulting baud rate using 13/8 prescaler */
@@ -1610,7 +1610,7 @@ static int keyspan_usa19w_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 static int keyspan_usa28_calc_baud(u32 baud_rate, u32 baudclk, u8 *rate_hi,
 				    u8 *rate_low, u8 *prescaler, int portnum)
 {
-	u32 	b16,	/* baud rate times 16 (actual rate used internally) */
+	u32	b16,	/* baud rate times 16 (actual rate used internally) */
 		div,	/* divisor */
 		cnt;	/* inverse of divisor (programmed into 8051) */
 
@@ -1656,12 +1656,12 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
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
 
@@ -1812,11 +1812,11 @@ static int keyspan_usa28_send_setup(struct usb_serial *serial,
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
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -1936,12 +1936,12 @@ static int keyspan_usa49_send_setup(struct usb_serial *serial,
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
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -2122,11 +2122,11 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa90_portControlMessage	msg;
-	struct keyspan_serial_private 		*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
-	int 					err;
+	int					err;
 	u8						prescaler;
 
 	s_priv = usb_get_serial_data(serial);
@@ -2253,11 +2253,11 @@ static int keyspan_usa67_send_setup(struct usb_serial *serial,
 				    int reset_port)
 {
 	struct keyspan_usa67_portControlMessage	msg;
-	struct keyspan_serial_private 		*s_priv;
-	struct keyspan_port_private 		*p_priv;
+	struct keyspan_serial_private		*s_priv;
+	struct keyspan_port_private		*p_priv;
 	const struct keyspan_device_details	*d_details;
 	struct urb				*this_urb;
-	int 					err, device_port;
+	int					err, device_port;
 
 	s_priv = usb_get_serial_data(serial);
 	p_priv = usb_get_serial_port_data(port);
@@ -2428,7 +2428,7 @@ static int keyspan_startup(struct usb_serial *serial)
 {
 	int				i, err;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
 
@@ -2488,7 +2488,7 @@ static void keyspan_disconnect(struct usb_serial *serial)
 {
 	int				i, j;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	struct keyspan_port_private	*p_priv;
 
 	s_priv = usb_get_serial_data(serial);
@@ -2528,7 +2528,7 @@ static void keyspan_release(struct usb_serial *serial)
 {
 	int				i;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 
 	s_priv = usb_get_serial_data(serial);
 
-- 
1.7.2.5

