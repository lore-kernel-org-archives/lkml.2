Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab1DLOrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:47:32 -0400
Received: from kroah.org ([198.145.64.141]:57639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab1DLOi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:55 2011
Message-Id: <20110412143555.132233758@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [067/105] p54usb: IDs for two new devices
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -56,6 +56,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x0846, 0x4210)},	/* Netgear WG121 the second ? */
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
+	{USB_DEVICE(0x0bf8, 0x1007)},	/* Fujitsu E-5400 USB */
 	{USB_DEVICE(0x0cde, 0x0006)},	/* Medion 40900, Roper Europe */
 	{USB_DEVICE(0x0db0, 0x6826)},	/* MSI UB54G (MS-6826) */
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
@@ -68,6 +69,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x1915, 0x2235)},	/* Linksys WUSB54G Portable OEM */
 	{USB_DEVICE(0x2001, 0x3701)},	/* DLink DWL-G120 Spinnaker */
 	{USB_DEVICE(0x2001, 0x3703)},	/* DLink DWL-G122 */
+	{USB_DEVICE(0x2001, 0x3762)},	/* Conceptronic C54U */
 	{USB_DEVICE(0x5041, 0x2234)},	/* Linksys WUSB54G */
 	{USB_DEVICE(0x5041, 0x2235)},	/* Linksys WUSB54G Portable */
 


