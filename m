Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab0LHBVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:21:47 -0500
Received: from kroah.org ([198.145.64.141]:33580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab0LHBDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:00 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:42 2010
Message-Id: <20101208005741.972969810@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Tapsell <johnflux@gmail.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: [205/289] Staging: rt2870: Add USB ID for Buffalo Airstation WLI-UC-GN
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Tapsell <johnflux@gmail.com>

commit 251d380034c6c34efe75ffb89d863558ba68ec6a upstream.

BugLink: http://bugs.launchpad.net/bugs/441990

This was tested to successfully enable the hardware.

Signed-off-by: John Tapsell <johnflux@gmail.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -182,6 +182,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x2001, 0x3C09)},	/* D-Link */
 	{USB_DEVICE(0x2001, 0x3C0A)},	/* D-Link 3072 */
 	{USB_DEVICE(0x2019, 0xED14)},	/* Planex Communications, Inc. */
+	{USB_DEVICE(0x0411, 0x015D)},	/* Buffalo Airstation WLI-UC-GN */
 	{}			/* Terminating entry */
 };
 


