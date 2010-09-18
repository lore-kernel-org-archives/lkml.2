Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0IRTdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:33:07 -0400
Received: from kroah.org ([198.145.64.141]:43373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab0IRTPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:09 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:01 2010
Message-Id: <20100918191301.090110643@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Ludlow <dave.ludlow@bay.ws>
Subject: [044/129] usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -129,6 +129,7 @@
 #define BANDB_DEVICE_ID_USOPTL4_2	0xAC42
 #define BANDB_DEVICE_ID_USOPTL4_4	0xAC44
 #define BANDB_DEVICE_ID_USOPTL2_4	0xAC24
+#define BANDB_DEVICE_ID_USOPTL4_2P      0xBC02
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -192,6 +193,7 @@ static const struct usb_device_id moschi
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */
@@ -209,6 +211,7 @@ static const struct usb_device_id moschi
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */


