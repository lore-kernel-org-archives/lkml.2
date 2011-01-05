Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1AEXr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:47:27 -0500
Received: from kroah.org ([198.145.64.141]:41089 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab1AEXpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:23 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:27 2011
Message-Id: <20110105230327.566454290@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Eduardo Costa <ecosta.tmp@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [41/49] p54usb: New USB ID for Gemtek WUBI-100GW
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Eduardo Costa <ecosta.tmp@gmail.com>

commit 56e6417b49132d4f56e9f2241d31942b90b46315 upstream.

This USB ID is for the WUBI-100GW 802.11g Wireless LAN USB Device that
uses p54usb.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Eduardo Costa <ecosta.tmp@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -59,6 +59,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
 	{USB_DEVICE(0x124a, 0x4023)},	/* Shuttle PN15, Airvast WM168g, IOGear GWU513 */
 	{USB_DEVICE(0x1435, 0x0210)},	/* Inventel UR054G */
+	{USB_DEVICE(0x15a9, 0x0002)},	/* Gemtek WUBI-100GW 802.11g */
 	{USB_DEVICE(0x1630, 0x0005)},	/* 2Wire 802.11g USB (v1) / Z-Com */
 	{USB_DEVICE(0x182d, 0x096b)},	/* Sitecom WL-107 */
 	{USB_DEVICE(0x1915, 0x2234)},	/* Linksys WUSB54G OEM */


