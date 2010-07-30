Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0G3SQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:16:57 -0400
Received: from kroah.org ([198.145.64.141]:58897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760030Ab0G3R4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:46 2010
Message-Id: <20100730175146.058711817@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        August Huber <gus@pbx.org>,
        Elina Pasheva <epasheva@sierrawireless.com>
Subject: [133/205] USB: Add PID for Sierra 250U to drivers/usb/serial/sierra.c
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -245,6 +245,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U */
+	{ USB_DEVICE(0x1199, 0x0301) },	/* Sierra Wireless USB Dongle 250U */
 	/* Sierra Wireless C597 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x0023, 0xFF, 0xFF, 0xFF) },
 	/* Sierra Wireless T598 */


