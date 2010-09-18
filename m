Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0IRTCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:14 -0400
Received: from kroah.org ([198.145.64.141]:51203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab0IRTBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:25 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:55 2010
Message-Id: <20100918185954.970699363@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Ludlow <dave.ludlow@bay.ws>
Subject: [025/123] usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-serial-mos7840-add-usb-id-to-support-the-b-b-electronics-usoptl4-2p.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Ludlow <dave.ludlow@bay.ws>

commit caf3a636a9f809fdca5fa746e6687096457accb1 upstream.

Add the USB ID needed to support B&B Electronic's 2-port, optically-isolated,
powered, USB to RS485 converter.

Signed-off-by: Dave Ludlow <dave.ludlow@bay.ws>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/mos7840.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -130,6 +130,7 @@
 #define BANDB_DEVICE_ID_USOPTL4_2	0xAC42
 #define BANDB_DEVICE_ID_USOPTL4_4	0xAC44
 #define BANDB_DEVICE_ID_USOPTL2_4	0xAC24
+#define BANDB_DEVICE_ID_USOPTL4_2P      0xBC02
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -193,6 +194,7 @@ static struct usb_device_id moschip_port
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */
@@ -210,6 +212,7 @@ static __devinitdata struct usb_device_i
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */


