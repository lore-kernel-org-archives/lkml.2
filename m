Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0LMAVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:21:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44881 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab0LLXpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:54 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: Larry.Finger@lwfinger.net, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [55/223] staging: rt2870: Add new USB ID for Belkin F6D4050 v1
Message-Id: <20101212234552.D2D5CB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

commit 705059a670f3af2b37695e82de0ee58e75e656ed upstream.

Add new USB ID for FT2870 for Belkin F6D4050 v1

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported- and Tested-by: James Long <crogonint@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/staging/rt2860/usb_main_dev.c
===================================================================
--- linux.orig/drivers/staging/rt2860/usb_main_dev.c
+++ linux/drivers/staging/rt2860/usb_main_dev.c
@@ -65,6 +65,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x14B2, 0x3C07)},	/* AL */
 	{USB_DEVICE(0x050D, 0x8053)},	/* Belkin */
 	{USB_DEVICE(0x050D, 0x825B)},	/* Belkin */
+	{USB_DEVICE(0x050D, 0x935A)},	/* Belkin F6D4050 v1 */
 	{USB_DEVICE(0x050D, 0x935B)},	/* Belkin F6D4050 v2 */
 	{USB_DEVICE(0x14B2, 0x3C23)},	/* Airlink */
 	{USB_DEVICE(0x14B2, 0x3C27)},	/* Airlink */
