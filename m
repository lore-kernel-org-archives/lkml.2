Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0IRTCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:13 -0400
Received: from kroah.org ([198.145.64.141]:51198 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab0IRTBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:24 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:54 2010
Message-Id: <20100918185954.880964786@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Blaise Gassend <blaise.gasend_linux@m4x.org>
Subject: [024/123] USB: serial: Extra device/vendor ID for mos7840 driver
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-serial-extra-device-vendor-id-for-mos7840-driver.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Blaise Gassend <blaise@willowgarage.com>

commit 27f1281d5f72e4f161e215ccad3d7d86b9e624a9 upstream.

Signed-off-by: Blaise Gassend <blaise.gasend_linux@m4x.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/mos7840.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -127,8 +127,9 @@
 #define BANDB_DEVICE_ID_US9ML2_4	0xAC30
 #define BANDB_DEVICE_ID_USPTL4_2	0xAC31
 #define BANDB_DEVICE_ID_USPTL4_4	0xAC32
-#define BANDB_DEVICE_ID_USOPTL4_2       0xAC42
-#define BANDB_DEVICE_ID_USOPTL4_4       0xAC44
+#define BANDB_DEVICE_ID_USOPTL4_2	0xAC42
+#define BANDB_DEVICE_ID_USOPTL4_4	0xAC44
+#define BANDB_DEVICE_ID_USOPTL2_4	0xAC24
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -191,6 +192,7 @@ static struct usb_device_id moschip_port
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */
@@ -207,6 +209,7 @@ static __devinitdata struct usb_device_i
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */


