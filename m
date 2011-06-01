Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab1FAJLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:11:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161890Ab1FAIPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:37 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:13 2011
Message-Id: <20110601080412.421756186@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:40 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Elizabeth Jennifer Myers <elizabeth@sporksirc.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [104/146] USB: moto_modem: Add USB identifier for the Motorola VE240.
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

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


