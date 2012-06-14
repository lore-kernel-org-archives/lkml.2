Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab2FOAAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab2FOAAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:21 -0400
Message-Id: <20120614235626.452711798@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 29/42] wireless: rt2x00: rt2800usb add more devices ids
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

commit 63b376411173c343bbcb450f95539da91f079e0c upstream.

They were taken from ralink drivers:
2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO

0x1eda,0x2210 RT3070 Airties

0x083a,0xb511 RT3370 Panasonic
0x0471,0x20dd RT3370 Philips

0x1690,0x0764 RT35xx Askey
0x0df6,0x0065 RT35xx Sitecom
0x0df6,0x0066 RT35xx Sitecom
0x0df6,0x0068 RT35xx Sitecom

0x2001,0x3c1c RT5370 DLink
0x2001,0x3c1d RT5370 DLink

2001 is D-Link not Alpha

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -922,6 +922,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x1482, 0x3c09) },
 	/* AirTies */
 	{ USB_DEVICE(0x1eda, 0x2012) },
+	{ USB_DEVICE(0x1eda, 0x2210) },
 	{ USB_DEVICE(0x1eda, 0x2310) },
 	/* Allwin */
 	{ USB_DEVICE(0x8516, 0x2070) },
@@ -1134,6 +1135,10 @@ static struct usb_device_id rt2800usb_de
 #ifdef CONFIG_RT2800USB_RT33XX
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x945b) },
+	/* Panasonic */
+	{ USB_DEVICE(0x083a, 0xb511) },
+	/* Philips */
+	{ USB_DEVICE(0x0471, 0x20dd) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3370) },
 	{ USB_DEVICE(0x148f, 0x8070) },
@@ -1145,6 +1150,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x8516, 0x3572) },
 	/* Askey */
 	{ USB_DEVICE(0x1690, 0x0744) },
+	{ USB_DEVICE(0x1690, 0x0764) },
 	/* Cisco */
 	{ USB_DEVICE(0x167b, 0x4001) },
 	/* EnGenius */
@@ -1159,20 +1165,25 @@ static struct usb_device_id rt2800usb_de
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0041) },
 	{ USB_DEVICE(0x0df6, 0x0062) },
+	{ USB_DEVICE(0x0df6, 0x0065) },
+	{ USB_DEVICE(0x0df6, 0x0066) },
+	{ USB_DEVICE(0x0df6, 0x0068) },
 	/* Toshiba */
 	{ USB_DEVICE(0x0930, 0x0a07) },
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0284) },
 #endif
 #ifdef CONFIG_RT2800USB_RT53XX
-	/* Alpha */
-	{ USB_DEVICE(0x2001, 0x3c15) },
-	{ USB_DEVICE(0x2001, 0x3c19) },
 	/* Arcadyan */
 	{ USB_DEVICE(0x043e, 0x7a12) },
 	/* Azurewave */
 	{ USB_DEVICE(0x13d3, 0x3329) },
 	{ USB_DEVICE(0x13d3, 0x3365) },
+	/* D-Link */
+	{ USB_DEVICE(0x2001, 0x3c15) },
+	{ USB_DEVICE(0x2001, 0x3c19) },
+	{ USB_DEVICE(0x2001, 0x3c1c) },
+	{ USB_DEVICE(0x2001, 0x3c1d) },
 	/* LG innotek */
 	{ USB_DEVICE(0x043e, 0x7a22) },
 	/* Panasonic */


