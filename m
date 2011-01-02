Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1ABHWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:34509 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1ABHWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dave Ludlow <dave.ludlow@bay.ws>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 050/260] usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
Date: Sun,  2 Jan 2011 02:15:46 -0500
Message-Id: <1293952756-15010-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:00.0601 (UTC) FILETIME=[9B5DCA90:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Ludlow <dave.ludlow@bay.ws>

commit caf3a636a9f809fdca5fa746e6687096457accb1 upstream.

Add the USB ID needed to support B&B Electronic's 2-port, optically-isolated,
powered, USB to RS485 converter.

Signed-off-by: Dave Ludlow <dave.ludlow@bay.ws>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/mos7840.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 68f6a1d..0fffcee 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -130,6 +130,7 @@
 #define BANDB_DEVICE_ID_USOPTL4_2	0xAC42
 #define BANDB_DEVICE_ID_USOPTL4_4	0xAC44
 #define BANDB_DEVICE_ID_USOPTL2_4	0xAC24
+#define BANDB_DEVICE_ID_USOPTL4_2P      0xBC02
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -193,6 +194,7 @@ static const struct usb_device_id moschip_port_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */
@@ -210,6 +212,7 @@ static const struct usb_device_id moschip_id_table_combined[] __devinitconst = {
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
+	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4P)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{}			/* terminating entry */
-- 
1.7.3.3

