Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1EFAxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:53:48 -0400
Received: from kroah.org ([198.145.64.141]:36814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab1EFAY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:11 2011
Message-Id: <20110506002211.085208403@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: [060/143] Staging: rtl8192su: remove device ids
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Schilhabel <florian.c.schilhabel@googlemail.com>

commit 60b42de30ad6fb131dc8e9dbd11a8a9ea0ab394c upstream.

This patch removes some device-ids.
The list of unsupported devices was extracted from realteks driver package.
removed IDs are:
(0x0bda, 0x8192)
(0x0bda, 0x8709)
(0x07aa, 0x0043)
(0x050d, 0x805E)
(0x0df6, 0x0031)
(0x1740, 0x9201)
(0x2001, 0x3301)
(0x5a57, 0x0290)
These devices are _not_ rtl819su based.

Signed-off-by: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rtl8192su/r8192U_core.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -114,22 +114,8 @@ u32 rt_global_debug_component = \
 static struct usb_device_id rtl8192_usb_id_tbl[] = {
 	/* Realtek */
 	{USB_DEVICE(0x0bda, 0x8171)},
-	{USB_DEVICE(0x0bda, 0x8192)},
-	{USB_DEVICE(0x0bda, 0x8709)},
-	/* Corega */
-	{USB_DEVICE(0x07aa, 0x0043)},
-	/* Belkin */
-	{USB_DEVICE(0x050d, 0x805E)},
 	{USB_DEVICE(0x050d, 0x815F)}, /* Belkin F5D8053 v6 */
-	/* Sitecom */
-	{USB_DEVICE(0x0df6, 0x0031)},
 	{USB_DEVICE(0x0df6, 0x004b)},	/* WL-349 */
-	/* EnGenius */
-	{USB_DEVICE(0x1740, 0x9201)},
-	/* Dlink */
-	{USB_DEVICE(0x2001, 0x3301)},
-	/* Zinwell */
-	{USB_DEVICE(0x5a57, 0x0290)},
 	/* Guillemot */
 	{USB_DEVICE(0x06f8, 0xe031)},
 	//92SU


