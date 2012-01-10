Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab2AJXBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:01:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811Ab2AJXBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:01:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:23 2012
Message-Id: <20120110215023.304391537@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Malte=20Schr=C3=B6der?= <maltesch@gmx.de>
Subject: [28/42] USB: Add USB-ID for Multiplex RC serial adapter to cp210x.c
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malte Schröder <maltesch@gmx.de>

commit 08e87d0d773dc9ca5faf4c3306e238ed0ea129b0 upstream.

Hi, below patch adds the USB-ID of the serial adapters sold by
Multiplex RC (www.multiplex-rc.de).

Signed-off-by: Malte Schröder <maltesch@gmx.de>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -92,6 +92,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x818B) }, /* AVIT Research USB to TTL */
 	{ USB_DEVICE(0x10C4, 0x819F) }, /* MJS USB Toslink Switcher */
 	{ USB_DEVICE(0x10C4, 0x81A6) }, /* ThinkOptics WavIt */
+	{ USB_DEVICE(0x10C4, 0x81A9) }, /* Multiplex RC Interface */
 	{ USB_DEVICE(0x10C4, 0x81AC) }, /* MSD Dash Hawk */
 	{ USB_DEVICE(0x10C4, 0x81AD) }, /* INSYS USB Modem */
 	{ USB_DEVICE(0x10C4, 0x81C8) }, /* Lipowsky Industrie Elektronik GmbH, Baby-JTAG */


