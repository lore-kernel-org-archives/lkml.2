Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab2FMP2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:28:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45105 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab2FMP2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:28:36 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu,
        sshtylyov@mvista.com, bvanassche@acm.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4 3/3] usb: storage: update usb devices for write cache quirk in quirk list.
Date: Wed, 13 Jun 2012 11:28:27 -0400
Message-Id: <1339601307-3358-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Update information of Seagate Portable HDD and WD My Passport HDD in
quirk list.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/storage/unusual_devs.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 1719886..62a31be 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1267,6 +1267,12 @@ UNUSUAL_DEV( 0x0af0, 0xd357, 0x0000, 0x0000,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		0 ),
 
+/* Reported by Namjae Jeon <namjae.jeon@samsung.com> */
+UNUSUAL_DEV(0x0bc2, 0x2300, 0x0000, 0x9999,
+		"Seagate",
+		"Portable HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
+
 /* Reported by Ben Efros <ben@pc-doctor.com> */
 UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0000,
 		"Seagate",
@@ -1468,6 +1474,12 @@ UNUSUAL_DEV(  0x1058, 0x0704, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_SANE_SENSE),
 
+/* Reported by Namjae Jeon <namjae.jeon@samsung.com> */
+UNUSUAL_DEV(0x1058, 0x070a, 0x0000, 0x9999,
+		"Western Digital",
+		"My Passport HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
+
 /* Reported by Fabio Venturi <f.venturi@tdnet.it>
  * The device reports a vendor-specific bDeviceClass.
  */
-- 
1.7.9.5

