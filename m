Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1G0VsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:26104 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab1G0VsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="35258011"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: craig@microtron.org.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [13/99] USB: CP210x Add 4 Device IDs for AC-Services Devices
Message-Id: <20110727214811.8ACC92403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Craig Shelley <craig@microtron.org.uk>

commit 4eff0b40a7174896b860312910e0db51f2dcc567 upstream.

This patch adds 4 device IDs for CP2102 based devices manufactured by
AC-Services. See http://www.ac-services.eu for further info.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/cp210x.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/cp210x.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/cp210x.c
+++ linux-2.6.35.y/drivers/usb/serial/cp210x.c
@@ -112,6 +112,10 @@ static const struct usb_device_id id_tab
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
