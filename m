Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161912Ab1FAIPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:15:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:43816 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161889Ab1FAIPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:32 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:12 2011
Message-Id: <20110601080411.320750674@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:39 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Craig Shelley <craig@microtron.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [103/146] USB: CP210x Add 4 Device IDs for AC-Services Devices
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Craig Shelley <craig@microtron.org.uk>

commit 4eff0b40a7174896b860312910e0db51f2dcc567 upstream.

This patch adds 4 device IDs for CP2102 based devices manufactured by
AC-Services. See http://www.ac-services.eu for further info.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -113,6 +113,10 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0x8477) }, /* Balluff RFID */
+	{ USB_DEVICE(0x10C4, 0x85EA) }, /* AC-Services IBUS-IF */
+	{ USB_DEVICE(0x10C4, 0x85EB) }, /* AC-Services CIS-IBUS */
+	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
+	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA71) }, /* Infinity GPS-MIC-1 Radio Monophone */


