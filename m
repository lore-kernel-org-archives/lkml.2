Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab0HLAEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:04:08 -0400
Received: from kroah.org ([198.145.64.141]:60095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab0HLADx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:03:53 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:24 2010
Message-Id: <20100812000123.941827730@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [07/54] staging: rt2870: Add USB ID for Belkin F6D4050 v2
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 5d92fe3387d086fc2f10426fbdb6b86d6cce5a47 upstream.

Device missing from current tables.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Rod Huffaker <rod.huffaker@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -64,6 +64,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x14B2, 0x3C07)},	/* AL */
 	{USB_DEVICE(0x050D, 0x8053)},	/* Belkin */
 	{USB_DEVICE(0x050D, 0x825B)},	/* Belkin */
+	{USB_DEVICE(0x050D, 0x935B)},	/* Belkin F6D4050 v2 */
 	{USB_DEVICE(0x14B2, 0x3C23)},	/* Airlink */
 	{USB_DEVICE(0x14B2, 0x3C27)},	/* Airlink */
 	{USB_DEVICE(0x07AA, 0x002F)},	/* Corega */


