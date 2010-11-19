Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab0KSWJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:09:41 -0500
Received: from kroah.org ([198.145.64.141]:53026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153Ab0KSWE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:28 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:26 2010
Message-Id: <20101119220125.971234012@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anders Larsen <al@alarsen.net>
Subject: [46/66] USB: cp210x: Add WAGO 750-923 Service Cable device ID
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anders Larsen <al@alarsen.net>

commit 93ad03d60b5b18897030038234aa2ebae8234748 upstream.

The WAGO 750-923 USB Service Cable is used for configuration and firmware
updates of several industrial automation products from WAGO Kontakttechnik GmbH.

Bus 004 Device 002: ID 1be3:07a6
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1be3
  idProduct          0x07a6
  bcdDevice            1.00
  iManufacturer           1 Silicon Labs
  iProduct                2 WAGO USB Service Cable
  iSerial                 3 1277796751
  . . .

Signed-off-by: Anders Larsen <al@alarsen.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -133,6 +133,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
+	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };


