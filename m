Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab1BPCOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:14:15 -0500
Received: from kroah.org ([198.145.64.141]:48714 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab1BPBtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:55 2011
Message-Id: <20110216014655.095067066@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Craig Shelley <craig@microtron.org.uk>
Subject: [008/115] USB: CP210x Removed incorrect device ID
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Craig Shelley <craig@microtron.org.uk>

commit 9926c0df7b31b2128eebe92e0e2b052f380ea464 upstream.

Device ID removed 0x10C4/0x8149 for West Mountain Radio Computerized
Battery Analyzer.  This device is actually based on a SiLabs C8051Fxxx,
see http://www.etheus.net/SiUSBXp_Linux_Driver for further info.

Signed-off-by: Craig Shelley <craig@microtron.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -87,7 +87,6 @@ static struct usb_device_id id_table []
 	{ USB_DEVICE(0x10C4, 0x8115) }, /* Arygon NFC/Mifare Reader */
 	{ USB_DEVICE(0x10C4, 0x813D) }, /* Burnside Telecom Deskmobile */
 	{ USB_DEVICE(0x10C4, 0x813F) }, /* Tams Master Easy Control */
-	{ USB_DEVICE(0x10C4, 0x8149) }, /* West Mountain Radio Computerized Battery Analyzer */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
 	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */


