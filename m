Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab0LHBmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:42:47 -0500
Received: from kroah.org ([198.145.64.141]:48797 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071Ab0LHBA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:29 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:30 2010
Message-Id: <20101208005730.741753228@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [094/289] staging: rt2870: Add new USB ID for Belkin F6D4050 v1
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 705059a670f3af2b37695e82de0ee58e75e656ed upstream.

Add new USB ID for FT2870 for Belkin F6D4050 v1

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported- and Tested-by: James Long <crogonint@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -65,6 +65,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x14B2, 0x3C07)},	/* AL */
 	{USB_DEVICE(0x050D, 0x8053)},	/* Belkin */
 	{USB_DEVICE(0x050D, 0x825B)},	/* Belkin */
+	{USB_DEVICE(0x050D, 0x935A)},	/* Belkin F6D4050 v1 */
 	{USB_DEVICE(0x050D, 0x935B)},	/* Belkin F6D4050 v2 */
 	{USB_DEVICE(0x14B2, 0x3C23)},	/* Airlink */
 	{USB_DEVICE(0x14B2, 0x3C27)},	/* Airlink */


