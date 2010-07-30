Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab0G3RSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:18:53 -0400
Received: from kroah.org ([198.145.64.141]:51654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940Ab0G3RSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:05 2010
Message-Id: <20100730171505.826471627@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Roskin <proski@gnu.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: [068/165] Staging: rtl8192su: add USB ID for 0bda:8171
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Roskin <proski@gnu.org>

commit c0087580b8d414f6874cfe93d2653212842fcb44 upstream.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8192su/r8192U_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -112,6 +112,7 @@ u32 rt_global_debug_component = \
 
 static struct usb_device_id rtl8192_usb_id_tbl[] = {
 	/* Realtek */
+	{USB_DEVICE(0x0bda, 0x8171)},
 	{USB_DEVICE(0x0bda, 0x8192)},
 	{USB_DEVICE(0x0bda, 0x8709)},
 	/* Corega */


