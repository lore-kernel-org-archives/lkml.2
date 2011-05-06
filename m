Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab1EFAxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:53:31 -0400
Received: from kroah.org ([198.145.64.141]:36816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab1EFAY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:11 2011
Message-Id: <20110506002211.192716521@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: [061/143] Staging: rtl8192su: add device ids
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Schilhabel <florian.c.schilhabel@googlemail.com>

commit 15d93ed070125d51693f102a0f94045dcaf30d9b upstream.

This patch adds some device ids.
The list of supported devices was extracted from realteks driver package.
(0x050d, 0x815F) and (0x0df6, 0x004b) are not in the official list of
supported devices  and may not work correctly.
In case of problems with these, they should probably be removed from the list.

Signed-off-by: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[bwh: Adjust context for 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rtl8192su/r8192U_core.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -112,14 +112,30 @@ u32 rt_global_debug_component = \
 #define CAM_CONTENT_COUNT 8
 
 static struct usb_device_id rtl8192_usb_id_tbl[] = {
-	/* Realtek */
-	{USB_DEVICE(0x0bda, 0x8171)},
-	{USB_DEVICE(0x050d, 0x815F)}, /* Belkin F5D8053 v6 */
-	{USB_DEVICE(0x0df6, 0x004b)},	/* WL-349 */
-	/* Guillemot */
-	{USB_DEVICE(0x06f8, 0xe031)},
-	//92SU
+	{USB_DEVICE(0x0bda, 0x8171)}, /* Realtek */
 	{USB_DEVICE(0x0bda, 0x8172)},
+	{USB_DEVICE(0x0bda, 0x8173)},
+	{USB_DEVICE(0x0bda, 0x8174)},
+	{USB_DEVICE(0x0bda, 0x8712)},
+	{USB_DEVICE(0x0bda, 0x8713)},
+	{USB_DEVICE(0x07aa, 0x0047)},
+	{USB_DEVICE(0x07d1, 0x3303)},
+	{USB_DEVICE(0x07d1, 0x3302)},
+	{USB_DEVICE(0x07d1, 0x3300)},
+	{USB_DEVICE(0x1740, 0x9603)},
+	{USB_DEVICE(0x1740, 0x9605)},
+	{USB_DEVICE(0x050d, 0x815F)},
+	{USB_DEVICE(0x06f8, 0xe031)},
+	{USB_DEVICE(0x7392, 0x7611)},
+	{USB_DEVICE(0x7392, 0x7612)},
+	{USB_DEVICE(0x7392, 0x7622)},
+	{USB_DEVICE(0x0DF6, 0x0045)},
+	{USB_DEVICE(0x0E66, 0x0015)},
+	{USB_DEVICE(0x0E66, 0x0016)},
+	{USB_DEVICE(0x0b05, 0x1786)},
+	/* these are not in the official list */
+	{USB_DEVICE(0x050d, 0x815F)}, /* Belkin F5D8053 v6 */
+	{USB_DEVICE(0x0df6, 0x004b)}, /* WL-349 */
 	{}
 };
 


