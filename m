Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2L1TTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55435 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932277Ab2L1TTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:02 -0500
Message-Id: <20121228190345.694248782@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "li.rui27@zte.com.cn" <li.rui27@zte.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 074/173] USB: add new zte 3g-dongles pid to option.c
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "li.rui27@zte.com.cn" <li.rui27@zte.com.cn>

commit 31b6a1048b7292efff8b5b53ae3d9d29adde385e upstream.

Signed-off-by: Rui li <li.rui27@zte.com.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ed66056..15365f9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -883,6 +883,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0126, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0128, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0135, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0136, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0137, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0139, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0142, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0143, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0144, 0xff, 0xff, 0xff) },
@@ -903,20 +907,34 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0165, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0167, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0189, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0191, 0xff, 0xff, 0xff), /* ZTE EuFi890 */
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0196, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0197, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0199, 0xff, 0xff, 0xff), /* ZTE MF820S */
 	  .driver_info = (kernel_ulong_t)&net_intf1_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0200, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0201, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0254, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0257, 0xff, 0xff, 0xff), /* ZTE MF821 */
 	  .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0265, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0284, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0317, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0326, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0330, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0395, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0414, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0417, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1012, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1018, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1021, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1057, 0xff, 0xff, 0xff) },
@@ -1096,6 +1114,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1298, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1299, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1300, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1301, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1302, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1303, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1333, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1401, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1402, 0xff, 0xff, 0xff),


