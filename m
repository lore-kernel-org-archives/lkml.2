Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab0KSWE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:29 -0500
Received: from kroah.org ([198.145.64.141]:53023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758117Ab0KSWE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:27 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:25 2010
Message-Id: <20101119220125.885445136@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        DJ Delorie <dj@delorie.com>
Subject: [45/66] USB: cp210x: Add Renesas RX-Stick device ID
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: DJ Delorie <dj@delorie.com>

commit 2f1136d1d08a63dcdbcd462621373f30d8dfe590 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -54,6 +54,7 @@ static int cp210x_carrier_raised(struct
 static int debug;
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
 	{ USB_DEVICE(0x0489, 0xE003) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */


