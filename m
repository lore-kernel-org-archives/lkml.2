Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab2EJJQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:16:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37217 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab2EJJQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:16:05 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 10/21] USB: serial: Changes to conform with checkpatch.sh script. space before tabs.
Date: Thu, 10 May 2012 19:17:16 +1000
Message-Id: <1336641447-23194-11-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 4 checkpatch.sh warnings.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 0c952eb..f590bfa 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1162,8 +1162,8 @@ static void keyspan_close(struct usb_serial_port *port)
 {
 	int			i;
 	struct usb_serial	*serial = port->serial;
-	struct keyspan_serial_private 	*s_priv;
-	struct keyspan_port_private 	*p_priv;
+	struct keyspan_serial_private	*s_priv;
+	struct keyspan_port_private	*p_priv;
 
 	dbg("%s", __func__);
 	s_priv = usb_get_serial_data(serial);
@@ -1200,8 +1200,8 @@ static void keyspan_close(struct usb_serial_port *port)
 /* download the firmware to a pre-renumeration device */
 static int keyspan_fake_startup(struct usb_serial *serial)
 {
-	int 				response;
-	const struct ihex_binrec 	*record;
+	int				response;
+	const struct ihex_binrec	*record;
 	char				*fw_name;
 	const struct firmware		*fw;
 
-- 
1.7.2.5

