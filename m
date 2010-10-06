Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab0JFWEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:04:40 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:55319 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab0JFWEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:04:38 -0400
X-Greylist: delayed 1087 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2010 18:04:38 EDT
Date: Wed, 6 Oct 2010 23:46:25 +0200
From: Anders Larsen <al@alarsen.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Craig Shelley <craig@microtron.org.uk>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: cp210x: Add WAGO 750-923 Service Cable device ID
Message-ID: <20101006214625.GA21514@alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: anders@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/usb/serial/cp210x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index f72afa9..8d7731d 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -133,6 +133,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
+	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
 	{ } /* Terminating Entry */
 };
-- 
1.7.0.4

