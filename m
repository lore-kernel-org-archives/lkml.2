Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1BBAxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:53:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:35413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab1BBAov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622586"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: ecosta.tmp@gmail.com, Larry.Finger@lwfinger.net, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [103/139] p54usb: New USB ID for Gemtek WUBI-100GW
Message-Id: <20110202004501.88ECD3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eduardo Costa <ecosta.tmp@gmail.com>

commit 56e6417b49132d4f56e9f2241d31942b90b46315 upstream.

This USB ID is for the WUBI-100GW 802.11g Wireless LAN USB Device that
uses p54usb.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Eduardo Costa <ecosta.tmp@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/net/wireless/p54/p54usb.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/p54/p54usb.c
+++ linux-2.6.35.y/drivers/net/wireless/p54/p54usb.c
@@ -61,6 +61,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
 	{USB_DEVICE(0x1435, 0x0210)},	/* Inventel UR054G */
+	{USB_DEVICE(0x15a9, 0x0002)},	/* Gemtek WUBI-100GW 802.11g */
 	{USB_DEVICE(0x1630, 0x0005)},	/* 2Wire 802.11g USB (v1) / Z-Com */
 	{USB_DEVICE(0x182d, 0x096b)},	/* Sitecom WL-107 */
 	{USB_DEVICE(0x1915, 0x2234)},	/* Linksys WUSB54G OEM */
