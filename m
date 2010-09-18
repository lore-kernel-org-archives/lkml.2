Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0IRTCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:06 -0400
Received: from kroah.org ([198.145.64.141]:51181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab0IRTBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:22 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:54 2010
Message-Id: <20100918185954.624670901@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Craig Shelley <craig@microtron.org.uk>
Subject: [021/123] USB: CP210x Add new device ID
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=usb-cp210x-add-new-device-id.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Craig Shelley <craig@microtron.org.uk>

commit 541e05ec3add5ab5bcf238d60161b53480280b20 upstream.

New device ID added for Balluff RFID reader.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -111,6 +111,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(0x10C4, 0x83A8) }, /* Amber Wireless AMB2560 */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
+	{ USB_DEVICE(0x10C4, 0x8477) }, /* Balluff RFID */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA71) }, /* Infinity GPS-MIC-1 Radio Monophone */
@@ -124,14 +125,14 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(0x1555, 0x0004) }, /* Owen AC4 USB-RS485 Converter */
 	{ USB_DEVICE(0x166A, 0x0303) }, /* Clipsal 5500PCU C-Bus USB interface */
 	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
-	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
-	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
-	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
-	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ USB_DEVICE(0x16DC, 0x0010) }, /* W-IE-NE-R Plein & Baus GmbH PL512 Power Supply */
 	{ USB_DEVICE(0x16DC, 0x0011) }, /* W-IE-NE-R Plein & Baus GmbH RCM Remote Control for MARATON Power Supply */
 	{ USB_DEVICE(0x16DC, 0x0012) }, /* W-IE-NE-R Plein & Baus GmbH MPOD Multi Channel Power Supply */
 	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
+	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
+	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
+	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
+	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };
 


