Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163064Ab1FAI0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:26:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:45019 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163041Ab1FAI0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:26:39 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:09 2011
Message-Id: <20110601081208.487405190@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:40 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [130/165] p54usb: add zoom 4410 usbid
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 991
Lines: 24

From: Christian Lamparter <chunkeey@googlemail.com>

commit 9368a9a2378ab721f82f59430a135b4ce4ff5109 upstream.

Reported-by: Mark Davis <marked86@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -82,6 +82,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
+	{USB_DEVICE(0x083a, 0xc501)},	/* Zoom Wireless-G 4410 */
 	{USB_DEVICE(0x083a, 0xf503)},	/* Accton FD7050E ver 1010ec  */
 	{USB_DEVICE(0x0846, 0x4240)},	/* Netgear WG111 (v2) */
 	{USB_DEVICE(0x0915, 0x2000)},	/* Cohiba Proto board */


