Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab0GAV5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:57:55 -0400
Received: from kroah.org ([198.145.64.141]:60754 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758897Ab0GAVNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:19 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:50 2010
Message-Id: <20100701174250.138307269@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dcbw@redhat.com>
Subject: [044/200] USB: qcaux: add Samsung U520 device ID
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit f5cddcd0995366f15d2b6b0df556a2cd99fa806e upstream.

Another CDC-ACM + vendor specific interface layout.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcaux.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/qcaux.c
+++ b/drivers/usb/serial/qcaux.c
@@ -50,6 +50,10 @@
 #define SANYO_VENDOR_ID				0x0474
 #define SANYO_PRODUCT_KATANA_LX			0x0754 /* SCP-3800 (Katana LX) */
 
+/* Samsung devices */
+#define SAMSUNG_VENDOR_ID			0x04e8
+#define SAMSUNG_PRODUCT_U520			0x6640 /* SCH-U520 */
+
 static struct usb_device_id id_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, UTSTARCOM_PRODUCT_PC5740, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, UTSTARCOM_PRODUCT_PC5750, 0xff, 0x00, 0x00) },
@@ -61,6 +65,7 @@ static struct usb_device_id id_table[] =
 	{ USB_DEVICE_AND_INTERFACE_INFO(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CDX650, 0xff, 0xff, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(LG_VENDOR_ID, LG_PRODUCT_VX4400_6000, 0xff, 0xff, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(SANYO_VENDOR_ID, SANYO_PRODUCT_KATANA_LX, 0xff, 0xff, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_U520, 0xff, 0x00, 0x00) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


