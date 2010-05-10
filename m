Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0EJWw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:52:26 -0400
Received: from kroah.org ([198.145.64.141]:32956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab0EJWvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:54 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:19 2010
Message-Id: <20100510223319.370862565@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       William Lightning <kassah@gmail.com>
Subject: [024/117] USB: Add id for HP ev2210 a.k.a Sierra MC5725 miniPCI-e Cell Modem.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: William Lightning <kassah@gmail.com>

commit cfbaa39347b34837f26e01fe8f4f8dbbae60b520 upstream.

Signed-off-by: William Lightning <kassah@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -229,6 +229,7 @@ static const struct sierra_iface_info di
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x0F3D, 0x0112) }, /* Airprime/Sierra PC 5220 */
 	{ USB_DEVICE(0x03F0, 0x1B1D) },	/* HP ev2200 a.k.a MC5720 */
+	{ USB_DEVICE(0x03F0, 0x211D) }, /* HP ev2210 a.k.a MC5725 */
 	{ USB_DEVICE(0x03F0, 0x1E1D) },	/* HP hs2300 a.k.a MC8775 */
 
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */


