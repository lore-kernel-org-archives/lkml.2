Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab2EJJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:16:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab2EJJQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:16:49 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 20/21] USB: serial: Changes to conform with checkpatch.sh script. space before tabs.
Date: Thu, 10 May 2012 19:17:26 +1000
Message-Id: <1336641447-23194-21-git-send-email-puzzleduck@gmail.com>
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
index 123fdc5..001e11f 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2473,7 +2473,7 @@ static int keyspan_startup(struct usb_serial *serial)
 {
 	int				i, err;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	struct keyspan_port_private	*p_priv;
 	const struct keyspan_device_details	*d_details;
 
@@ -2535,7 +2535,7 @@ static void keyspan_disconnect(struct usb_serial *serial)
 {
 	int				i, j;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 	struct keyspan_port_private	*p_priv;
 
 	dbg("%s", __func__);
@@ -2577,7 +2577,7 @@ static void keyspan_release(struct usb_serial *serial)
 {
 	int				i;
 	struct usb_serial_port		*port;
-	struct keyspan_serial_private 	*s_priv;
+	struct keyspan_serial_private	*s_priv;
 
 	dbg("%s", __func__);
 
-- 
1.7.2.5

