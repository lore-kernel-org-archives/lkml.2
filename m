Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2FTS0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:26:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2FTSY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:59 -0400
Message-Id: <20120620173041.116611988@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomas Cassidy <tomas.cassidy@gmail.com>
Subject: [ 18/20] USB: serial: sierra: Add support for Sierra Wireless AirCard 320U modem
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Cassidy <tomas.cassidy@gmail.com>

commit 19a3dd1575e954e8c004413bee3e12d3962f2525 upstream.

Add support for Sierra Wireless AirCard 320U modem

Signed-off-by: Tomas Cassidy <tomas.cassidy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/sierra.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -304,6 +304,10 @@ static const struct usb_device_id id_tab
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


