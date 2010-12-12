Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0LMACW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:02:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36470 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab0LLXri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:38 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: johnflux@gmail.com, stefan.bader@canonical.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [153/223] Staging: rt2870: Add USB ID for Buffalo Airstation WLI-UC-GN
Message-Id: <20101212234736.9D2AEB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: John Tapsell <johnflux@gmail.com>

commit 251d380034c6c34efe75ffb89d863558ba68ec6a upstream.

BugLink: http://bugs.launchpad.net/bugs/441990

This was tested to successfully enable the hardware.

Signed-off-by: John Tapsell <johnflux@gmail.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/staging/rt2860/usb_main_dev.c
===================================================================
--- linux.orig/drivers/staging/rt2860/usb_main_dev.c
+++ linux/drivers/staging/rt2860/usb_main_dev.c
@@ -182,6 +182,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x2001, 0x3C09)},	/* D-Link */
 	{USB_DEVICE(0x2001, 0x3C0A)},	/* D-Link 3072 */
 	{USB_DEVICE(0x2019, 0xED14)},	/* Planex Communications, Inc. */
+	{USB_DEVICE(0x0411, 0x015D)},	/* Buffalo Airstation WLI-UC-GN */
 	{}			/* Terminating entry */
 };
 
