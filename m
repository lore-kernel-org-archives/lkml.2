Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab0KSVtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:49:42 -0500
Received: from kroah.org ([198.145.64.141]:51813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab0KSVpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:33 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:11 2010
Message-Id: <20101119214411.477972371@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [25/45] p54usb: add five more USBIDs
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 1a92795dac419128eb511dce30a6aad672064b88 upstream.

Source:
http://www.wikidevi.com/wiki/Intersil/p54/usb/windows

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -32,8 +32,17 @@ MODULE_ALIAS("prism54usb");
 MODULE_FIRMWARE("isl3886usb");
 MODULE_FIRMWARE("isl3887usb");
 
+/*
+ * Note:
+ *
+ * Always update our wiki's device list (located at:
+ * http://wireless.kernel.org/en/users/Drivers/p54/devices ),
+ * whenever you add a new device.
+ */
+
 static struct usb_device_id p54u_table[] __devinitdata = {
 	/* Version 1 devices (pci chip + net2280) */
+	{USB_DEVICE(0x045e, 0x00c2)},	/* Microsoft MN-710 */
 	{USB_DEVICE(0x0506, 0x0a11)},	/* 3COM 3CRWE254G72 */
 	{USB_DEVICE(0x0707, 0xee06)},	/* SMC 2862W-G */
 	{USB_DEVICE(0x07aa, 0x001c)},	/* Corega CG-WLUSB2GT */
@@ -45,7 +54,9 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
 	{USB_DEVICE(0x0cde, 0x0006)},	/* Medion 40900, Roper Europe */
+	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
+	{USB_DEVICE(0x1630, 0x0005)},	/* 2Wire 802.11g USB (v1) / Z-Com */
 	{USB_DEVICE(0x1915, 0x2234)},	/* Linksys WUSB54G OEM */
 	{USB_DEVICE(0x1915, 0x2235)},	/* Linksys WUSB54G Portable OEM */
 	{USB_DEVICE(0x2001, 0x3701)},	/* DLink DWL-G120 Spinnaker */
@@ -58,6 +69,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x050d, 0x7050)},	/* Belkin F5D7050 ver 1000 */
 	{USB_DEVICE(0x0572, 0x2000)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0572, 0x2002)},	/* Cohiba Proto board */
+	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
@@ -77,6 +89,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x13B1, 0x000C)},	/* Linksys WUSB54AG */
 	{USB_DEVICE(0x1413, 0x5400)},   /* Telsey 802.11g USB2.0 Adapter */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
+	{USB_DEVICE(0x1668, 0x1050)},	/* Actiontec 802UIG-1 */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
 	{USB_DEVICE(0x413c, 0x5513)},	/* Dell WLA3310 USB Wireless Adapter */
 	{USB_DEVICE(0x413c, 0x8102)},	/* Spinnaker DUT */


