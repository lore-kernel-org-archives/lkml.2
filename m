Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab1C3WII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:08:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:35488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933192Ab1C3VGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903733784"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: craig@microtron.org.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [13/275] USB: CP210x Add two device IDs
Message-Id: <20110330210407.613E03E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Craig Shelley <craig@microtron.org.uk>

commit faea63f7ccfddfb8fc19798799fcd38c58415172 upstream.

Device Ids added for IRZ Automation Teleport SG-10 GSM/GPRS Modem and
DekTec DTA Plus VHF/UHF Booster/Attenuator.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/cp210x.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/usb/serial/cp210x.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/cp210x.c	2011-03-29 23:02:58.479339081 -0700
+++ linux-2.6.35.y/drivers/usb/serial/cp210x.c	2011-03-29 23:55:33.857600845 -0700
@@ -108,7 +108,9 @@
 	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x8382) }, /* Cygnal Integrated Products, Inc. */
 	{ USB_DEVICE(0x10C4, 0x83A8) }, /* Amber Wireless AMB2560 */
+	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
+	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0x8477) }, /* Balluff RFID */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
