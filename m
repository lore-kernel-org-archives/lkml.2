Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab1DMQXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:23:44 -0400
Received: from kroah.org ([198.145.64.141]:52865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862Ab1DMQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:46 2011
Message-Id: <20110413161045.973360811@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [33/71] p54usb: IDs for two new devices
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 220107610c7c2c9703e09eb363e8ab31025b9315 upstream.

Reported-by: Mark Davis [via p54/devices wiki]
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -54,6 +54,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x0846, 0x4210)},	/* Netgear WG121 the second ? */
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
+	{USB_DEVICE(0x0bf8, 0x1007)},	/* Fujitsu E-5400 USB */
 	{USB_DEVICE(0x0cde, 0x0006)},	/* Medion 40900, Roper Europe */
 	{USB_DEVICE(0x0db0, 0x6826)},	/* MSI UB54G (MS-6826) */
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
@@ -66,6 +67,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x1915, 0x2235)},	/* Linksys WUSB54G Portable OEM */
 	{USB_DEVICE(0x2001, 0x3701)},	/* DLink DWL-G120 Spinnaker */
 	{USB_DEVICE(0x2001, 0x3703)},	/* DLink DWL-G122 */
+	{USB_DEVICE(0x2001, 0x3762)},	/* Conceptronic C54U */
 	{USB_DEVICE(0x5041, 0x2234)},	/* Linksys WUSB54G */
 	{USB_DEVICE(0x5041, 0x2235)},	/* Linksys WUSB54G Portable */
 


