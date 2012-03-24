Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2CXR2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 13:28:11 -0400
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:46540 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab2CXR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 13:28:09 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 3/3] USB: qmi_wwan: Add ZTE (Vodafone) K3570-Z and K3571-Z net interfaces
Date: Sat, 24 Mar 2012 17:27:08 +0000
Message-Id: <1332610028-23308-4-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1332610028-23308-1-git-send-email-ajb@spheresystems.co.uk>
References: <1332610028-23308-1-git-send-email-ajb@spheresystems.co.uk>
X-Originating-Smarthost04-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the beginnings of an OSS method to use the network
interfaces on these USB broadband modems, add the ZTE manufactured
Vodafone items to the whitelist

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
---
 drivers/net/usb/qmi_wwan.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 0f83899..552d24b 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -418,6 +418,24 @@ static const struct usb_device_id products[] = {
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
 	},
+	{	/* ZTE (Vodafone) K3570-Z */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x1008,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
+	},
+	{	/* ZTE (Vodafone) K3571-Z */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x1010,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
+	},
 	{	/* ZTE (Vodafone) K4505-Z */
 		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
 		.idVendor           = 0x19d2,
-- 
1.7.6.5

