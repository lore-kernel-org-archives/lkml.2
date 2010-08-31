Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab0HaSmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:42:47 -0400
Received: from cblmdm72-240-119-60.buckeyecom.net ([72.240.119.60]:60940 "EHLO
	holly2.adsllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751790Ab0HaSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:42:45 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Aug 2010 14:42:45 EDT
From: Dave Ludlow <dave.ludlow@bay.ws>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Ludlow <dave.ludlow@bay.ws>
Subject: [PATCH] usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
Date: Tue, 31 Aug 2010 14:26:17 -0400
Message-Id: <1283279177-14379-1-git-send-email-dave.ludlow@bay.ws>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the USB ID needed to support B&B Electronic's 2-port, optically-isolated,
powered, USB to RS485 converter.

Signed-off-by: Dave Ludlow <dave.ludlow@bay.ws>
---
 drivers/usb/serial/mos7840.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 585b7e6..9a5ea9d 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -129,6 +129,7 @@
 #define BANDB_DEVICE_ID_USOPTL4_2	0xAC42
 #define BANDB_DEVICE_ID_USOPTL4_4	0xAC44
 #define BANDB_DEVICE_ID_USOPTL2_4	0xAC24
+#define BANDB_DEVICE_ID_USOPTL4_2P      0xBC02
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -192,6 +193,7 @@ static const struct usb_device_id moschip_port_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */
@@ -209,6 +211,7 @@ static const struct usb_device_id moschip_id_table_combined[] __devinitconst = {
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */
-- 
1.7.2.2

