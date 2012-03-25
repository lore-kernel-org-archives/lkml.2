Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2CYKKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 06:10:42 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:51786 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496Ab2CYKKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 06:10:40 -0400
From: Andrew Bird <ajb@spheresystems.co.uk>
To: gregkh@linuxfoundation.org
Cc: smurf@smurf.noris.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Bird <ajb@spheresystems.co.uk>
Subject: [PATCH 1/3] USB: qmi_wwan: Add ZTE (Vodafone) K3565-Z and K4505-Z net interfaces
Date: Sun, 25 Mar 2012 11:10:27 +0100
Message-Id: <1332670229-2045-2-git-send-email-ajb@spheresystems.co.uk>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1332670229-2045-1-git-send-email-ajb@spheresystems.co.uk>
References: <1332670229-2045-1-git-send-email-ajb@spheresystems.co.uk>
X-Originating-Smarthost03-IP: [82.71.70.22]
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
index aac68f5..0f83899 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -409,6 +409,24 @@ static const struct usb_device_id products[] = {
 		.bInterfaceProtocol = 0xff,
 		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
 	},
+	{	/* ZTE (Vodafone) K3565-Z */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x0063,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
+	},
+	{	/* ZTE (Vodafone) K4505-Z */
+		.match_flags	    = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,
+		.idVendor           = 0x19d2,
+		.idProduct          = 0x0104,
+		.bInterfaceClass    = 0xff,
+		.bInterfaceSubClass = 0xff,
+		.bInterfaceProtocol = 0xff,
+		.driver_info        = (unsigned long)&qmi_wwan_force_int4,
+	},
 	{QMI_GOBI_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
 	{QMI_GOBI_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
 	{QMI_GOBI_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Mobile Broadband Module */
-- 
1.7.6.5

