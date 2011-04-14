Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab1DNSDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:03:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:42326 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965058Ab1DNR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 188/209] p54usb: add 5 more USBIDs
Date: Thu, 14 Apr 2011 13:55:46 -0400
Message-Id: <1302803767-9715-75-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Lamparter <chunkeey@googlemail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 16cad7fba037b34ca32cc0adac65bc089d969fb8 upstream.

This patch adds five more USBIDs to the table.

Source:
http://www.linuxant.com/pipermail/driverloader/2005q3/002307.html
http://wireless.kernel.org/en/users/Drivers/p54/devices (by M. Davis)

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/p54/p54usb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 84118ff..960a517 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -43,6 +43,7 @@ MODULE_FIRMWARE("isl3887usb");
 
 static struct usb_device_id p54u_table[] __devinitdata = {
 	/* Version 1 devices (pci chip + net2280) */
+	{USB_DEVICE(0x0411, 0x0050)},	/* Buffalo WLI2-USB2-G54 */
 	{USB_DEVICE(0x045e, 0x00c2)},	/* Microsoft MN-710 */
 	{USB_DEVICE(0x0506, 0x0a11)},	/* 3COM 3CRWE254G72 */
 	{USB_DEVICE(0x06b9, 0x0120)},	/* Thomson SpeedTouch 120g */
@@ -56,9 +57,12 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
 	{USB_DEVICE(0x0cde, 0x0006)},	/* Medion 40900, Roper Europe */
+	{USB_DEVICE(0x0db0, 0x6826)},	/* MSI UB54G (MS-6826) */
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
+	{USB_DEVICE(0x1435, 0x0210)},	/* Inventel UR054G */
 	{USB_DEVICE(0x1630, 0x0005)},	/* 2Wire 802.11g USB (v1) / Z-Com */
+	{USB_DEVICE(0x182d, 0x096b)},	/* Sitecom WL-107 */
 	{USB_DEVICE(0x1915, 0x2234)},	/* Linksys WUSB54G OEM */
 	{USB_DEVICE(0x1915, 0x2235)},	/* Linksys WUSB54G Portable OEM */
 	{USB_DEVICE(0x2001, 0x3701)},	/* DLink DWL-G120 Spinnaker */
@@ -93,6 +97,7 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
 	{USB_DEVICE(0x1668, 0x1050)},	/* Actiontec 802UIG-1 */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
+	{USB_DEVICE(0x2001, 0x3705)},	/* D-Link DWL-G120 rev C1 */
 	{USB_DEVICE(0x413c, 0x5513)},	/* Dell WLA3310 USB Wireless Adapter */
 	{USB_DEVICE(0x413c, 0x8102)},	/* Spinnaker DUT */
 	{USB_DEVICE(0x413c, 0x8104)},	/* Cohiba Proto board */
-- 
1.7.4.4

