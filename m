Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab0G3Rh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:37:27 -0400
Received: from kroah.org ([198.145.64.141]:36187 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab0G3RgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:36:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:14 2010
Message-Id: <20100730173113.948773760@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Airlie <richard@backtrace.co.uk>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [125/140] staging: rtl8192su: add Support for Belkin F5D8053 v6
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Airlie <richard@backtrace.co.uk>

commit d615da093eb0f691a73a754589e2a4a24a6f1ca7 upstream.

Please find attached a patch which adds the device ID for the Belkin
F5D8053 v6 to the rtl8192su driver. I've tested this in 2.6.34-rc3
(Ubuntu 9.10 amd64) and the network adapter is working flawlessly.

Signed-off-by: Richard Airlie <richard@backtrace.co.uk>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8192su/r8192U_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -118,6 +118,7 @@ static struct usb_device_id rtl8192_usb_
 	{USB_DEVICE(0x07aa, 0x0043)},
 	/* Belkin */
 	{USB_DEVICE(0x050d, 0x805E)},
+	{USB_DEVICE(0x050d, 0x815F)}, /* Belkin F5D8053 v6 */
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x0031)},
 	{USB_DEVICE(0x0df6, 0x004b)},	/* WL-349 */


