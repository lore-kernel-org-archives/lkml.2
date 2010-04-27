Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0D0SzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:55:06 -0400
Received: from kroah.org ([198.145.64.141]:41597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab0D0SzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:55:04 -0400
Subject: patch staging-rt2860-add-belkin-f5d8055-wireless-n-usb-dongle-device-id.patch added to gregkh-2.6 tree
To: largret@gmail.com, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Tue, 27 Apr 2010 11:54:56 -0700
In-Reply-To: <d426fb281003030324v6dc6216ch53bdb30ffc18a9be@mail.gmail.com>
Message-ID: <1272394496918@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: rt2860: add Belkin F5D8055 Wireless-N USB Dongle device id

to my gregkh-2.6 tree.  Its filename is

    staging-rt2860-add-belkin-f5d8055-wireless-n-usb-dongle-device-id.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From largret@gmail.com  Tue Apr 27 09:35:20 2010
From: Chris Largret <largret@gmail.com>
Date: Wed, 3 Mar 2010 05:24:26 -0600
Subject: Staging: rt2860: add Belkin F5D8055 Wireless-N USB Dongle device id
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <d426fb281003030324v6dc6216ch53bdb30ffc18a9be@mail.gmail.com>


Add Belkin F5D8055 Wireless-N USB support to the rt2870
staging driver.

Signed-off-by: Chris Largret <largret@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -63,6 +63,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x07D1, 0x3C11)},	/* D-Link */
 	{USB_DEVICE(0x14B2, 0x3C07)},	/* AL */
 	{USB_DEVICE(0x050D, 0x8053)},	/* Belkin */
+	{USB_DEVICE(0x050D, 0x825B)},	/* Belkin */
 	{USB_DEVICE(0x14B2, 0x3C23)},	/* Airlink */
 	{USB_DEVICE(0x14B2, 0x3C27)},	/* Airlink */
 	{USB_DEVICE(0x07AA, 0x002F)},	/* Corega */

