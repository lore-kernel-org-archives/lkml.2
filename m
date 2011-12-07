Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849Ab1LGQX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:23:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811Ab1LGQXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:20 2011
Message-Id: <20111207161220.798058353@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:15 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Subject: [073/104] usb: option: add SIMCom SIM5218
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>

commit ec0cd94d881ca89cc9fb61d00d0f4b2b52e605b3 upstream.

Tested with SIM5218EVB-KIT evaluation kit.

Signed-off-by: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -746,6 +746,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },


