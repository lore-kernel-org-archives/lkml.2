Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162877Ab1FAIl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:41:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162840Ab1FAIYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:24:39 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:55 2011
Message-Id: <20110601081154.814441119@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:18 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Elizabeth Jennifer Myers <elizabeth@sporksirc.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [108/165] USB: moto_modem: Add USB identifier for the Motorola VE240.
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 841
Lines: 25

From: Elizabeth Jennifer Myers <elizabeth@sporksirc.net>

commit 3938a0b32dc12229e76735679b37095bc2bc1578 upstream.

Tested on my phone, the ttyUSB device is created and is fully
functional.

Signed-off-by: Elizabeth Jennifer Myers <elizabeth@sporksirc.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/moto_modem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/moto_modem.c
+++ b/drivers/usb/serial/moto_modem.c
@@ -25,6 +25,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x05c6, 0x3197) },	/* unknown Motorola phone */
 	{ USB_DEVICE(0x0c44, 0x0022) },	/* unknown Mororola phone */
 	{ USB_DEVICE(0x22b8, 0x2a64) },	/* Motorola KRZR K1m */
+	{ USB_DEVICE(0x22b8, 0x2c84) }, /* Motorola VE240 phone */
 	{ USB_DEVICE(0x22b8, 0x2c64) }, /* Motorola V950 phone */
 	{ },
 };


