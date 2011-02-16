Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab1BPAr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:47:27 -0500
Received: from kroah.org ([198.145.64.141]:45127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414Ab1BPArS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:47:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:20:59 2011
Message-Id: <20110216002059.477515776@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:19:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [patch 004/176] staging: rt2870sta: Add ID for Linksys WUSB100v2
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 27c82819a5a42f08fc0f787ab1b0c129cbdda801 upstream.

This device was tested with rt2870sta by setting new_id.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Brian Ormond <brian.ormond@oit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -106,6 +106,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x0411, 0x016f)},	/* MelCo.,Inc. WLI-UC-G301N */
 	{USB_DEVICE(0x1737, 0x0070)},	/* Linksys WUSB100 */
 	{USB_DEVICE(0x1737, 0x0071)},	/* Linksys WUSB600N */
+	{USB_DEVICE(0x1737, 0x0078)},	/* Linksys WUSB100v2 */
 	{USB_DEVICE(0x0411, 0x00e8)},	/* Buffalo WLI-UC-G300N */
 	{USB_DEVICE(0x050d, 0x815c)},	/* Belkin F5D8053 */
 	{USB_DEVICE(0x100D, 0x9031)},	/* Motorola 2770 */


