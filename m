Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab0HLAJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:09:04 -0400
Received: from kroah.org ([198.145.64.141]:47934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab0HLAIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:52 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:17 2010
Message-Id: <20100812000617.567784686@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [53/67] USB: cp210x: Add four new device IDs
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alessio Igor Bogani <abogani@texware.it>

commit 356c5a4834a74c621715f7a7f16ded914eecbd3c upstream.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -126,6 +126,10 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
+	{ USB_DEVICE(0x16DC, 0x0010) }, /* W-IE-NE-R Plein & Baus GmbH PL512 Power Supply */
+	{ USB_DEVICE(0x16DC, 0x0011) }, /* W-IE-NE-R Plein & Baus GmbH RCM Remote Control for MARATON Power Supply */
+	{ USB_DEVICE(0x16DC, 0x0012) }, /* W-IE-NE-R Plein & Baus GmbH MPOD Multi Channel Power Supply */
+	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ } /* Terminating Entry */
 };
 


