Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0HIOBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:01:22 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:33122 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab0HIOBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:01:21 -0400
From: Jef Driesen <jefdriesen@telenet.be>
To: Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Frank Schaefer <schaefer.frank@gmx.net>,
        Alan Cox <alan@linux.intel.com>,
        Pawel Ludwikow <pludwiko@rab.ict.pwr.wroc.pl>,
        Manuel Jander <manuel.jander@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jef Driesen <jefdriesen@telenet.be>
Subject: [PATCH] USB: pl2303: New vendor and product id
Date: Mon,  9 Aug 2010 15:55:32 +0200
Message-Id: <1281362132-9106-1-git-send-email-jefdriesen@telenet.be>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Zeagle N2iTiON3 dive computer interface. Since
Zeagle devices are actually manufactured by Seiko, this patch will
support other Seiko based models as well.

Signed-off-by: Jef Driesen <jefdriesen@telenet.be>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 6b60018..c98f0fb 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -86,6 +86,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(SUPERIAL_VENDOR_ID, SUPERIAL_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LD220_PRODUCT_ID) },
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
+	{ USB_DEVICE(ZEAGLE_VENDOR_ID, ZEAGLE_N2ITION3_PRODUCT_ID) },
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_QN3USB_PRODUCT_ID) },
 	{ USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index a871645..43eb9bd 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -128,6 +128,10 @@
 #define CRESSI_VENDOR_ID	0x04b8
 #define CRESSI_EDY_PRODUCT_ID	0x0521
 
+/* Zeagle dive computer interface */
+#define ZEAGLE_VENDOR_ID	0x04b8
+#define ZEAGLE_N2ITION3_PRODUCT_ID	0x0522
+
 /* Sony, USB data cable for CMD-Jxx mobile phones */
 #define SONY_VENDOR_ID		0x054c
 #define SONY_QN3USB_PRODUCT_ID	0x0437
-- 
1.7.0.4

