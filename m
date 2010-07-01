Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab0GAWWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:22:31 -0400
Received: from kroah.org ([198.145.64.141]:47133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab0GAUta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:30 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:27 2010
Message-Id: <20100701173427.894926859@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rodrigo Linfati <rodrigo@linfati.cl>
Subject: [patch 012/164] Staging: add Add Sitecom WL-349 to rtl8192su
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Linfati <rodrigo@linfati.cl>

commit 64a5a09218626464be35e0229d85b2ab0fcf03fd upstream.

Add usb id of Sitecom WL-349 to rtl8192su

Signed-off-by: Rodrigo Linfati <rodrigo@linfati.cl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8192su/r8192U_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -120,6 +120,7 @@ static struct usb_device_id rtl8192_usb_
 	{USB_DEVICE(0x050d, 0x805E)},
 	/* Sitecom */
 	{USB_DEVICE(0x0df6, 0x0031)},
+	{USB_DEVICE(0x0df6, 0x004b)},	/* WL-349 */
 	/* EnGenius */
 	{USB_DEVICE(0x1740, 0x9201)},
 	/* Dlink */


