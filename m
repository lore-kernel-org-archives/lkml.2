Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1FPHFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:05:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34513 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755622Ab1FPHFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:44 -0400
X-Sasl-enc: brnO3O7nvRtV39iVRDqhudo+16ZQEcywlyvo7y2uHzSl 1308207943
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:12 2011
Message-Id: <20110616001612.274620590@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Elizabeth Jennifer Myers <elizabeth@sporksirc.net>
Subject: [30/91] USB: moto_modem: Add USB identifier for the Motorola VE240.
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -25,6 +25,7 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(0x05c6, 0x3197) },	/* unknown Motorola phone */
 	{ USB_DEVICE(0x0c44, 0x0022) },	/* unknown Mororola phone */
 	{ USB_DEVICE(0x22b8, 0x2a64) },	/* Motorola KRZR K1m */
+	{ USB_DEVICE(0x22b8, 0x2c84) }, /* Motorola VE240 phone */
 	{ USB_DEVICE(0x22b8, 0x2c64) }, /* Motorola V950 phone */
 	{ },
 };


