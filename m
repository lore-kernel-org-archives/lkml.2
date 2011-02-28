Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1B1Ql7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:41:59 -0500
Received: from kroah.org ([198.145.64.141]:48228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab1B1QiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:38:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:11 2011
Message-Id: <20110228162411.326228646@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Thomas <jthomas@redhat.com>
Subject: [56/68] sierra: add new ID for Airprime/Sierra USB IP modem
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jon Thomas <jthomas@redhat.com>

commit e1dc5157c574e7249dc1cd072fde2e48b3011533 upstream.

I picked up a new Sierra usb 308 (At&t Shockwave) on 2/2011 and the vendor code
is 0x0f3d

Looking up vendor and product id's I see:

0f3d  Airprime, Incorporated
 0112  CDMA 1xEVDO PC Card, PC 5220

Sierra and Airprime are somehow related and I'm guessing the At&t usb 308 might
be have some common hardware with the AirPrime SL809x.

Signed-off-by: Jon Thomas <jthomas@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -266,6 +266,9 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
+	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 
 	{ }
 };


