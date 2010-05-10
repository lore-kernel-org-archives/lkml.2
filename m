Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab0EJXrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:47:13 -0400
Received: from kroah.org ([198.145.64.141]:32851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab0EJWvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:35 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:17 2010
Message-Id: <20100510223317.380330489@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shimada Hirofumi <hirofumi@flycat.org>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       maximilian attems <max@stro.at>
Subject: [002/117] p54usb: Add usbid for Corega CG-WLUSB2GT.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shimada Hirofumi <hirofumi@flycat.org>

commit 15a69a81731d337a3d9db51692ff8704c1114f43 upstream.

Signed-off-by: Shimada Hirofumi <hirofumi@flycat.org>
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -36,6 +36,7 @@ static struct usb_device_id p54u_table[]
 	/* Version 1 devices (pci chip + net2280) */
 	{USB_DEVICE(0x0506, 0x0a11)},	/* 3COM 3CRWE254G72 */
 	{USB_DEVICE(0x0707, 0xee06)},	/* SMC 2862W-G */
+	{USB_DEVICE(0x07aa, 0x001c)},	/* Corega CG-WLUSB2GT */
 	{USB_DEVICE(0x083a, 0x4501)},	/* Accton 802.11g WN4501 USB */
 	{USB_DEVICE(0x083a, 0x4502)},	/* Siemens Gigaset USB Adapter */
 	{USB_DEVICE(0x083a, 0x5501)},	/* Phillips CPWUA054 */


