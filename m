Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1CEBFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:05:10 -0500
Received: from kroah.org ([198.145.64.141]:47724 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932695Ab1CEBFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 17:03:53 2011
Message-Id: <20110305010352.989584737@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 17:03:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [12/18] p54usb: add Senao NUB-350 usbid
In-Reply-To: <20110305010410.GA18668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 2b799a6b25bb9f9fbc478782cd9503e8066ab618 upstream.

Reported-by: Mark Davis
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -95,6 +95,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x1413, 0x5400)},   /* Telsey 802.11g USB2.0 Adapter */
 	{USB_DEVICE(0x1435, 0x0427)},	/* Inventel UR054G */
 	{USB_DEVICE(0x1668, 0x1050)},	/* Actiontec 802UIG-1 */
+	{USB_DEVICE(0x1740, 0x1000)},	/* Senao NUB-350 */
 	{USB_DEVICE(0x2001, 0x3704)},	/* DLink DWL-G122 rev A2 */
 	{USB_DEVICE(0x2001, 0x3705)},	/* D-Link DWL-G120 rev C1 */
 	{USB_DEVICE(0x413c, 0x5513)},	/* Dell WLA3310 USB Wireless Adapter */


