Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab1KJDTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:19:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998Ab1KJDTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:19:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:01 2011
Message-Id: <20111109212701.535433175@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rigbert Hamisch <rigbert@gmx.de>
Subject: [012/262] USB: qcserial: add device ID for "HP un2430 Mobile Broadband Module"
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -28,6 +28,7 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x1f1d)},	/* HP un2400 Gobi Modem Device */
 	{USB_DEVICE(0x03f0, 0x201d)},	/* HP un2400 Gobi QDL Device */
+	{USB_DEVICE(0x03f0, 0x371d)},	/* HP un2430 Mobile Broadband Module */
 	{USB_DEVICE(0x04da, 0x250d)},	/* Panasonic Gobi Modem device */
 	{USB_DEVICE(0x04da, 0x250c)},	/* Panasonic Gobi QDL device */
 	{USB_DEVICE(0x413c, 0x8172)},	/* Dell Gobi Modem device */


