Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab1KCCOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:14:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab1KCBem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:54 2011
Message-Id: <20111102221454.887321607@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rigbert Hamisch <rigbert@gmx.de>
Subject: [052/107] USB: qcserial: add device ID for "HP un2430 Mobile Broadband Module"
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Rigbert Hamisch <rigbert@gmx.de>

commit 1bfac90d1b8e63a4d44158c3445d8fda3fb6d5eb upstream.

add device ID for "HP un2430 Mobile Broadband Module"

Signed-off-by: Rigbert Hamisch <rigbert@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -26,6 +26,7 @@ static struct usb_device_id id_table[] =
 	{USB_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x201d)},	/* HP un2400 Gobi QDL Device */
+	{USB_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Mobile Broadband Module */
 	{USB_DEVICE(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
 	{USB_DEVICE(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
 	{USB_DEVICE(0x413c, 0x8172)},	/* Dell Gobi Modem device */


