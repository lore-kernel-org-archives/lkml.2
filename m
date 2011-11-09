Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab1KJDZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:25:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934491Ab1KJDZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:25:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:06 2011
Message-Id: <20111109212706.363601310@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, s.kirste@avm.de, d.friedel@avm.de,
        Martin Walter <m.walter@avm.de>,
        Peter Grabienski <pgrabien@qca.qualcomm.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [060/262] ath9k_htc: add AVM FRITZ!WLAN 11N v2 support
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

commit 8c34559b4a6df32e4af1b073397fa4dc189a5485 upstream.

This was reported and tested by Martin Walter over at AVM GmbH Berlin.
This also applies to 3.0.1 so sendint to stable.

Cc: s.kirste@avm.de
Cc: d.friedel@avm.de
Cc: Martin Walter <m.walter@avm.de>
Cc: Peter Grabienski <pgrabien@qca.qualcomm.com>
Tested-by: Martin Walter <m.walter@avm.de>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -37,6 +37,7 @@ static struct usb_device_id ath9k_hif_us
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
 	{ USB_DEVICE(0x040D, 0x3801) }, /* VIA */
 	{ USB_DEVICE(0x0cf3, 0xb003) }, /* Ubiquiti WifiStation Ext */
+	{ USB_DEVICE(0x057c, 0x8403) }, /* AVM FRITZ!WLAN 11N v2 USB */
 
 	{ USB_DEVICE(0x0cf3, 0x7015),
 	  .driver_info = AR9287_USB },  /* Atheros */


