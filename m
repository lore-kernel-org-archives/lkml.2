Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab0G3RS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:18:57 -0400
Received: from kroah.org ([198.145.64.141]:51691 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940Ab0G3RSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:06 2010
Message-Id: <20100730171506.251657218@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        August Huber <gus@pbx.org>,
        Elina Pasheva <epasheva@sierrawireless.com>
Subject: [073/165] USB: Add PID for Sierra 250U to drivers/usb/serial/sierra.c
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: august huber <gus@pbx.org>

commit 9d72c81d657340e54a260a3b621f4a9f5b33829c upstream.

Add VID/PID for Sierra Wireless 250U USB dongle to sierra.c
Allows use of 3G radio only

Signed-off-by: August Huber <gus@pbx.org>
Cc: Elina Pasheva <epasheva@sierrawireless.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -210,6 +210,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U */
+	{ USB_DEVICE(0x1199, 0x0301) },	/* Sierra Wireless USB Dongle 250U */
 	/* Sierra Wireless C597 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x0023, 0xFF, 0xFF, 0xFF) },
 	/* Sierra Wireless T598 */


