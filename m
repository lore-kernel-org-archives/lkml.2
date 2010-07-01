Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab0GASei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:34:38 -0400
Received: from kroah.org ([198.145.64.141]:40700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758070Ab0GASYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:03 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:15 2010
Message-Id: <20100701173215.754545201@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Dravet <dravet@hotmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 106/149] p54usb: Add device ID for Dell WLA3310 USB
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Dravet <dravet@hotmail.com>

commit 0f666a08901f8b01f294ca0ad751019375240ae3 upstream.

Add Dell WLA3310 USB wireless card, which has a Z-Com XG-705A chipset, to the
USB Ids in p54usb.

Signed-off-by: Jason Dravet <dravet@hotmail.com>
Tested-by: Richard Gregory Tillmore <rtillmore@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -78,6 +78,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x1413, 0x5400)},   /* Telsey 802.11g USB2.0 Adapter */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
+	{USB_DEVICE(0x413c, 0x5513)},	/* Dell WLA3310 USB Wireless Adapter */
 	{USB_DEVICE(0x413c, 0x8102)},	/* Spinnaker DUT */
 	{USB_DEVICE(0x413c, 0x8104)},	/* Cohiba Proto board */
 	{}


