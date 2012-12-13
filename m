Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab2LMOuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:50:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab2LMOGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 091/241] USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
Date: Thu, 13 Dec 2012 11:57:36 -0200
Message-Id: <1355407206-17100-92-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit fcb21645f1bd86d2be29baf48aa1b298de52ccc7 upstream.

The Dell 5800 appears to be a simple rebrand of the Novatel E362.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/option.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index b473e958..0179d55 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -157,6 +157,7 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED	0x8001
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED	0x9000
 #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED	0x9001
+#define NOVATELWIRELESS_PRODUCT_E362		0x9010
 #define NOVATELWIRELESS_PRODUCT_G1		0xA001
 #define NOVATELWIRELESS_PRODUCT_G1_M		0xA002
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
@@ -192,6 +193,9 @@ static void option_instat_callback(struct urb *urb);
 #define DELL_PRODUCT_5730_MINICARD_TELUS	0x8181
 #define DELL_PRODUCT_5730_MINICARD_VZW		0x8182
 
+#define DELL_PRODUCT_5800_MINICARD_VZW		0x8195  /* Novatel E362 */
+#define DELL_PRODUCT_5800_V2_MINICARD_VZW	0x8196  /* Novatel E362 */
+
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
 #define KYOCERA_PRODUCT_KPC680			0x180a
@@ -705,6 +709,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) },
 	/* Novatel Ovation MC551 a.k.a. Verizon USB551L */
 	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC551, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_E362, 0xff, 0xff, 0xff) },
 
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
 	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },
@@ -727,6 +732,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_SPRINT) },	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_TELUS) },	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_MINICARD_VZW, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_V2_MINICARD_VZW, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
-- 
1.7.9.5

