Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab1C3VFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:05:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:61084 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050Ab1C3VFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903733745"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: gregkh@suse.de, rf@suse.de, IvDoorn@gmail.com, linville@tuxdriver.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [9/275] rt2x00: add device id for windy31 usb device
Message-Id: <20110330210403.2CA0A3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>

commit 9c4cf6d94fb362c27a24df5223ed6e327eb7279a upstream.

This patch adds the device id for the windy31 USB device to the rt73usb
driver.

Thanks to Ralf Flaxa for reporting this and providing testing and a
sample device.

Reported-by: Ralf Flaxa <rf@suse.de>
Tested-by: Ralf Flaxa <rf@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/rt2x00/rt73usb.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/net/wireless/rt2x00/rt73usb.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/rt2x00/rt73usb.c	2011-03-29 22:52:04.013085234 -0700
+++ linux-2.6.35.y/drivers/net/wireless/rt2x00/rt73usb.c	2011-03-29 23:02:58.424340488 -0700
@@ -2392,6 +2392,7 @@
 	{ USB_DEVICE(0x04bb, 0x093d), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0812, 0x3101), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
