Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439Ab2CIUTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:19:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030809Ab2CITsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:48:21 -0500
Message-Id: <20120309190206.448072297@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 51/95] rtl8192cu: Add new device IDs
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 6cddafab54e9a17b2efefe982547865955a5ff3a upstream.

The latest vendor (non-mac80211) driver of 9/22/2011 shows some new
device IDs for rtl8192cu. In addition, some typos in the table are
fixed and one duplicate is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |   36 ++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -275,6 +275,8 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8191, rtl92cu_hal_cfg)},
 
 	/****** 8188CU ********/
+	/* RTL8188CTV */
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x018a, rtl92cu_hal_cfg)},
 	/* 8188CE-VAU USB minCard */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8170, rtl92cu_hal_cfg)},
 	/* 8188cu 1*1 dongle */
@@ -291,14 +293,14 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817e, rtl92cu_hal_cfg)},
 	/* 8188RU in Alfa AWUS036NHR */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
+	/* RTL8188CUS-VL */
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x818a, rtl92cu_hal_cfg)},
 	/* 8188 Combo for BC4 */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8754, rtl92cu_hal_cfg)},
 
 	/****** 8192CU ********/
-	/* 8191cu 1*2 */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8177, rtl92cu_hal_cfg)},
 	/* 8192cu 2*2 */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817b, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8178, rtl92cu_hal_cfg)},
 	/* 8192CE-VAU USB minCard */
 	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817c, rtl92cu_hal_cfg)},
 
@@ -309,13 +311,17 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
-	{RTL_USB_DEVICE(0x0Df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
 	/* HP - Lite-On ,8188CUS Slim Combo */
 	{RTL_USB_DEVICE(0x103c, 0x1629, rtl92cu_hal_cfg)},
 	{RTL_USB_DEVICE(0x13d3, 0x3357, rtl92cu_hal_cfg)}, /* AzureWave */
 	{RTL_USB_DEVICE(0x2001, 0x3308, rtl92cu_hal_cfg)}, /*D-Link - Alpha*/
+	{RTL_USB_DEVICE(0x2019, 0x4902, rtl92cu_hal_cfg)}, /*Planex - Etop*/
 	{RTL_USB_DEVICE(0x2019, 0xab2a, rtl92cu_hal_cfg)}, /*Planex - Abocom*/
+	/*SW-WF02-AD15 -Abocom*/
+	{RTL_USB_DEVICE(0x2019, 0xab2e, rtl92cu_hal_cfg)},
 	{RTL_USB_DEVICE(0x2019, 0xed17, rtl92cu_hal_cfg)}, /*PCI - Edimax*/
 	{RTL_USB_DEVICE(0x20f4, 0x648b, rtl92cu_hal_cfg)}, /*TRENDnet - Cameo*/
 	{RTL_USB_DEVICE(0x7392, 0x7811, rtl92cu_hal_cfg)}, /*Edimax - Edimax*/
@@ -326,14 +332,36 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x4855, 0x0091, rtl92cu_hal_cfg)}, /* NetweeN-Feixun */
 	{RTL_USB_DEVICE(0x9846, 0x9041, rtl92cu_hal_cfg)}, /* Netgear Cameo */
 
+	/****** 8188 RU ********/
+	/* Netcore */
+	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x317f, rtl92cu_hal_cfg)},
+
+	/****** 8188CUS Slim Solo********/
+	{RTL_USB_DEVICE(0x04f2, 0xaff7, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x04f2, 0xaff9, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x04f2, 0xaffa, rtl92cu_hal_cfg)}, /*Xavi*/
+
+	/****** 8188CUS Slim Combo ********/
+	{RTL_USB_DEVICE(0x04f2, 0xaff8, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x04f2, 0xaffb, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x04f2, 0xaffc, rtl92cu_hal_cfg)}, /*Xavi*/
+	{RTL_USB_DEVICE(0x2019, 0x1201, rtl92cu_hal_cfg)}, /*Planex-Vencer*/
+
 	/****** 8192CU ********/
+	{RTL_USB_DEVICE(0x050d, 0x2102, rtl92cu_hal_cfg)}, /*Belcom-Sercomm*/
+	{RTL_USB_DEVICE(0x050d, 0x2103, rtl92cu_hal_cfg)}, /*Belcom-Edimax*/
 	{RTL_USB_DEVICE(0x0586, 0x341f, rtl92cu_hal_cfg)}, /*Zyxel -Abocom*/
 	{RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
 	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
+	{RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
+	{RTL_USB_DEVICE(0x0b05, 0x17ab, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
+	{RTL_USB_DEVICE(0x0df6, 0x0061, rtl92cu_hal_cfg)}, /*Sitecom-Edimax*/
+	{RTL_USB_DEVICE(0x0e66, 0x0019, rtl92cu_hal_cfg)}, /*Hawking-Edimax*/
 	{RTL_USB_DEVICE(0x2001, 0x3307, rtl92cu_hal_cfg)}, /*D-Link-Cameo*/
 	{RTL_USB_DEVICE(0x2001, 0x3309, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
 	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
 	{RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
+	{RTL_USB_DEVICE(0x20f4, 0x624d, rtl92cu_hal_cfg)}, /*TRENDNet*/
 	{RTL_USB_DEVICE(0x7392, 0x7822, rtl92cu_hal_cfg)}, /*Edimax -Edimax*/
 	{}
 };


