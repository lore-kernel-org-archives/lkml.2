Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab1C3WIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:08:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:4817 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193Ab1C3VGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903733809"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: r.schtz@t-online.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [15/275] USB: usb-storage: unusual_devs update for Cypress ATACB
Message-Id: <20110330210409.7ABEB3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Richard Schütz <r.schtz@t-online.de>

commit cae41118f50ef0c431e13159df6d7dd8bbd54004 upstream.

New device ID added for unusual Cypress ATACB device.

Signed-off-by: Richard Schütz <r.schtz@t-online.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/storage/unusual_cypress.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.35.y/drivers/usb/storage/unusual_cypress.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/storage/unusual_cypress.h	2011-03-29 22:52:01.983137175 -0700
+++ linux-2.6.35.y/drivers/usb/storage/unusual_cypress.h	2011-03-29 23:02:58.541337493 -0700
@@ -31,4 +31,9 @@
 		"Cypress ISD-300LP",
 		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
 
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
+		"Super Top",
+		"USB 2.0  SATA BRIDGE",
+		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
+
 #endif /* defined(CONFIG_USB_STORAGE_CYPRESS_ATACB) || ... */
