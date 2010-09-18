Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0IRTcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:32:50 -0400
Received: from kroah.org ([198.145.64.141]:43377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab0IRTPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:10 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:01 2010
Message-Id: <20100918191301.181132573@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Ludlow <dave.ludlow@bay.ws>
Subject: [045/129] usb: serial: mos7840: Add USB IDs to support more B&B USB/RS485 converters.
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Ludlow <dave.ludlow@bay.ws>

commit 870408c8291015872a7a0b583673a9e56b3e73f4 upstream.

Add the USB IDs needed to support the B&B USOPTL4-4P, USO9ML2-2P, and
USO9ML2-4P.  This patch expands and corrects a typo in the patch sent
on 08-31-2010.

Signed-off-by: Dave Ludlow <dave.ludlow@bay.ws>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/mos7840.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -119,17 +119,20 @@
  * by making a change here, in moschip_port_id_table, and in
  * moschip_id_table_combined
  */
-#define USB_VENDOR_ID_BANDB             0x0856
-#define BANDB_DEVICE_ID_USO9ML2_2	0xAC22
-#define BANDB_DEVICE_ID_USO9ML2_4	0xAC24
-#define BANDB_DEVICE_ID_US9ML2_2	0xAC29
-#define BANDB_DEVICE_ID_US9ML2_4	0xAC30
-#define BANDB_DEVICE_ID_USPTL4_2	0xAC31
-#define BANDB_DEVICE_ID_USPTL4_4	0xAC32
-#define BANDB_DEVICE_ID_USOPTL4_2	0xAC42
-#define BANDB_DEVICE_ID_USOPTL4_4	0xAC44
-#define BANDB_DEVICE_ID_USOPTL2_4	0xAC24
-#define BANDB_DEVICE_ID_USOPTL4_2P      0xBC02
+#define USB_VENDOR_ID_BANDB              0x0856
+#define BANDB_DEVICE_ID_USO9ML2_2        0xAC22
+#define BANDB_DEVICE_ID_USO9ML2_2P       0xBC00
+#define BANDB_DEVICE_ID_USO9ML2_4        0xAC24
+#define BANDB_DEVICE_ID_USO9ML2_4P       0xBC01
+#define BANDB_DEVICE_ID_US9ML2_2         0xAC29
+#define BANDB_DEVICE_ID_US9ML2_4         0xAC30
+#define BANDB_DEVICE_ID_USPTL4_2         0xAC31
+#define BANDB_DEVICE_ID_USPTL4_4         0xAC32
+#define BANDB_DEVICE_ID_USOPTL4_2        0xAC42
+#define BANDB_DEVICE_ID_USOPTL4_2P       0xBC02
+#define BANDB_DEVICE_ID_USOPTL4_4        0xAC44
+#define BANDB_DEVICE_ID_USOPTL4_4P       0xBC03
+#define BANDB_DEVICE_ID_USOPTL2_4        0xAC24
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -185,15 +188,18 @@ static const struct usb_device_id moschi
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_US9ML2_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_US9ML2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
-	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */
@@ -203,15 +209,18 @@ static const struct usb_device_id moschi
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USO9ML2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_US9ML2_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_US9ML2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
-	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */


