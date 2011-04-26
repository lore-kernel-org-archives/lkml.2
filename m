Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab1DZVNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:13:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:30103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758705Ab1DZVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483465"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: chunkeey@googlemail.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [22/106] p54usb: IDs for two new devices
Message-Id: <20110426211300.E37773E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Christian Lamparter <chunkeey@googlemail.com>

commit 220107610c7c2c9703e09eb363e8ab31025b9315 upstream.

Reported-by: Mark Davis [via p54/devices wiki]
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/p54/p54usb.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/net/wireless/p54/p54usb.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/p54/p54usb.c
+++ linux-2.6.35.y/drivers/net/wireless/p54/p54usb.c
@@ -56,6 +56,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x0846, 0x4210)},	/* Netgear WG121 the second ? */
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */
 	{USB_DEVICE(0x09aa, 0x1000)},	/* Spinnaker Proto board */
+	{USB_DEVICE(0x0bf8, 0x1007)},	/* Fujitsu E-5400 USB */
 	{USB_DEVICE(0x0cde, 0x0006)},	/* Medion 40900, Roper Europe */
 	{USB_DEVICE(0x0db0, 0x6826)},	/* MSI UB54G (MS-6826) */
 	{USB_DEVICE(0x107b, 0x55f2)},	/* Gateway WGU-210 (Gemtek) */
@@ -68,6 +69,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x1915, 0x2235)},	/* Linksys WUSB54G Portable OEM */
 	{USB_DEVICE(0x2001, 0x3701)},	/* DLink DWL-G120 Spinnaker */
 	{USB_DEVICE(0x2001, 0x3703)},	/* DLink DWL-G122 */
+	{USB_DEVICE(0x2001, 0x3762)},	/* Conceptronic C54U */
 	{USB_DEVICE(0x5041, 0x2234)},	/* Linksys WUSB54G */
 	{USB_DEVICE(0x5041, 0x2235)},	/* Linksys WUSB54G Portable */
 
