Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2DSVMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:12:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab2DSVMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:12:38 -0400
Message-Id: <20120419210612.969483574@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Samokhvalov <pg83@yandex.ru>
Subject: [ 22/59] USB: sierra: add support for Sierra Wireless MC7710
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Samokhvalov <pg83@yandex.ru>

commit c5d703dcc776cb542b41665f2b7e2ba054efb4a7 upstream.

Just add new device id. 3G works fine, LTE not tested.

Signed-off-by: Anton Samokhvalov <pg83@yandex.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/sierra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -289,6 +289,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
 	{ USB_DEVICE(0x1199, 0x6859) },	/* Sierra Wireless AirCard 885 E */
 	{ USB_DEVICE(0x1199, 0x685A) },	/* Sierra Wireless AirCard 885 E */
+	{ USB_DEVICE(0x1199, 0x68A2) }, /* Sierra Wireless MC7710 */
 	/* Sierra Wireless C885 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x6880, 0xFF, 0xFF, 0xFF)},
 	/* Sierra Wireless C888, Air Card 501, USB 303, USB 304 */


