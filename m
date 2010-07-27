Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0G0VF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 17:05:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35491 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0G0VF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 17:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=svikH+s+h3bNMD86QRNl+61u5Da/L1Aet4LZA/w2nFZZf+XuInDBX6GUj5urQ5JKGg
         7V62zeK+KCAfiPZQkoWFIay1sI918/bicH/D/dvoPgQ7VmAN5ttzF8fHPJayDIVKnVU4
         CRsQIkk/eNGAC+XYcy547+r4T8HN9y0tShB1E=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Craig Shelley <craig@microtron.org.uk>,
        Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Michael Brunner <mibru@gmx.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] USB: cp210x: Add four new device IDs
Date: Tue, 27 Jul 2010 23:05:14 +0200
Message-Id: <1280264714-17175-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/usb/serial/cp210x.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 8b8c797..2bef441 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -126,6 +126,10 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x413C, 0x9500) }, /* DW700 GPS USB interface */
+	{ USB_DEVICE(0x16DC, 0x0010) }, /* W-IE-NE-R Plein & Baus GmbH PL512 Power Supply */
+	{ USB_DEVICE(0x16DC, 0x0011) }, /* W-IE-NE-R Plein & Baus GmbH RCM Remote Control for MARATON Power Supply */
+	{ USB_DEVICE(0x16DC, 0x0012) }, /* W-IE-NE-R Plein & Baus GmbH MPOD Multi Channel Power Supply */
+	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ } /* Terminating Entry */
 };
 
-- 
1.7.0.4

