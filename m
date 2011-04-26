Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab1DZVf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:35:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:19974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723Ab1DZVNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950983"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: Marc-Antoine@Perennou.com, padovan@profusion.mobi, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [27/106] Bluetooth: add support for Apple MacBook Pro 8,2
Message-Id: <20110426211306.2C94B3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>

commit 63a8588debd4dc72becb9e27add9343c76301c7d upstream.

Just adding the vendor details makes it work fine.

Signed-off-by: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/drivers/bluetooth/btusb.c
===================================================================
--- linux-2.6.35.y.orig/drivers/bluetooth/btusb.c
+++ linux-2.6.35.y/drivers/bluetooth/btusb.c
@@ -62,6 +62,9 @@ static struct usb_device_id btusb_table[
 	/* Apple iMac11,1 */
 	{ USB_DEVICE(0x05ac, 0x8215) },
 
+	/* Apple MacBookPro8,2 */
+	{ USB_DEVICE(0x05ac, 0x821a) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 
