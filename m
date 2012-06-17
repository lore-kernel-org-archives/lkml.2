Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab2FQSgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:36:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50217 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758119Ab2FQSWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:39 -0400
Message-Id: <20120617175948.674497410@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tom Cassidy <tomas.cassidy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 51/69] USB: serial: sierra: Add support for Sierra Wireless AirCard 320U
 modem
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Cassidy <tomas.cassidy@gmail.com>

commit 19a3dd1575e954e8c004413bee3e12d3962f2525 upstream.

Add support for Sierra Wireless AirCard 320U modem

Signed-off-by: Tomas Cassidy <tomas.cassidy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/sierra.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index ba54a0a..d423d36 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -294,6 +294,10 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
+	/* AT&T Direct IP LTE modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},


