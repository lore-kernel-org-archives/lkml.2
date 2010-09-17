Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0IQPon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:44:43 -0400
Received: from delorie.com ([65.175.133.15]:40598 "EHLO delorie.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab0IQPok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:44:40 -0400
X-Greylist: delayed 2120 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2010 11:44:39 EDT
Date: Fri, 17 Sep 2010 11:09:06 -0400
Message-Id: <201009171509.o8HF96DL013464@envy.delorie.com>
From: DJ Delorie <dj@delorie.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Craig Shelley <craig@microtron.org.uk>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: dj@delorie.com
Subject: [PATCH] USB: cp210x: Add Renesas RX-Stick device ID
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RX610 development board by Renesas

Bus 001 Device 024: ID 045b:0053 Hitachi, Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x045b Hitachi, Ltd
  idProduct          0x0053
  bcdDevice            1.00
  iManufacturer           1 Silicon Labs
  iProduct                2 RX-Stick
  iSerial                 3 0001
  . . .

http://am.renesas.com/rx610stick

Signed-off-by: DJ Delorie <dj@delorie.com>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 4f1744c..f72afa9 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -54,6 +54,7 @@ static int cp210x_carrier_raised(struct usb_serial_port *p);
 static int debug;
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
 	{ USB_DEVICE(0x0489, 0xE003) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
-- 
1.6.6.1

