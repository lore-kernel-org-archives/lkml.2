Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1BPCRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:17:05 -0500
Received: from kroah.org ([198.145.64.141]:38650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab1BPAS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:27 2011
Message-Id: <20110216001427.038679007@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [020/272] USB: usb-storage: unusual_devs entry for Coby MP3 player
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 3ea3c9b5a8464ec8223125f95e5dddb3bfd02a39 upstream.

This patch (as1444) adds an unusual_devs entry for an MP3 player from
Coby electronics.  The device has two nasty bugs.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Jasper Mackenzie <scarletpimpernal@hotmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1890,6 +1890,13 @@ UNUSUAL_DEV(  0x1e68, 0x001b, 0x0000, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE | US_FL_SANE_SENSE ),
 
+/* Reported by Jasper Mackenzie <scarletpimpernal@hotmail.com> */
+UNUSUAL_DEV( 0x1e74, 0x4621, 0x0000, 0x0000,
+		"Coby Electronics",
+		"MP3 Player",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",


