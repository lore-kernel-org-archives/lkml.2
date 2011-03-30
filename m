Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab1C3VF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:05:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:16640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab1C3VFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132684"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: craig@microtron.org.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [14/275] USB: CP210x Removed incorrect device ID
Message-Id: <20110330210408.6DCBB3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Craig Shelley <craig@microtron.org.uk>

commit 9926c0df7b31b2128eebe92e0e2b052f380ea464 upstream.

Device ID removed 0x10C4/0x8149 for West Mountain Radio Computerized
Battery Analyzer.  This device is actually based on a SiLabs C8051Fxxx,
see http://www.etheus.net/SiUSBXp_Linux_Driver for further info.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/cp210x.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.35.y/drivers/usb/serial/cp210x.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/cp210x.c	2011-03-29 23:02:58.505338415 -0700
+++ linux-2.6.35.y/drivers/usb/serial/cp210x.c	2011-03-29 23:02:58.523337954 -0700
@@ -85,7 +85,6 @@
 	{ USB_DEVICE(0x10C4, 0x8115) }, /* Arygon NFC/Mifare Reader */
 	{ USB_DEVICE(0x10C4, 0x813D) }, /* Burnside Telecom Deskmobile */
 	{ USB_DEVICE(0x10C4, 0x813F) }, /* Tams Master Easy Control */
-	{ USB_DEVICE(0x10C4, 0x8149) }, /* West Mountain Radio Computerized Battery Analyzer */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
 	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
