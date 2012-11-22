Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab2KVWjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:39:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:49016 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab2KVSdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dcbw@redhat.com>
Subject: [ 41/83] USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
Date: Wed, 21 Nov 2012 16:42:03 -0800
Message-Id: <20121122004217.187899511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit fcb21645f1bd86d2be29baf48aa1b298de52ccc7 upstream.

The Dell 5800 appears to be a simple rebrand of the Novatel E362.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -158,6 +158,7 @@ static void option_instat_callback(struc
 #define NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED	0x8001
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED	0x9000
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED	0x9001
+#define NOVATELWIRELESS_PRODUCT_E362		0x9010
 #define NOVATELWIRELESS_PRODUCT_G1		0xA001
 #define NOVATELWIRELESS_PRODUCT_G1_M		0xA002
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
@@ -193,6 +194,9 @@ static void option_instat_callback(struc
 #define DELL_PRODUCT_5730_MINICARD_TELUS	0x8181
 #define DELL_PRODUCT_5730_MINICARD_VZW		0x8182
 
+#define DELL_PRODUCT_5800_MINICARD_VZW		0x8195  /* Novatel E362 */
+#define DELL_PRODUCT_5800_V2_MINICARD_VZW	0x8196  /* Novatel E362 */
+
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
 #define KYOCERA_PRODUCT_KPC680			0x180a
@@ -706,6 +710,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) },
 	/* Novatel Ovation MC551 a.k.a. Verizon USB551L */
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC551, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_E362, 0xff, 0xff, 0xff) },
 
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },
@@ -728,6 +733,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_SPRINT) },	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_TELUS) },	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_MINICARD_VZW, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_V2_MINICARD_VZW, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },


