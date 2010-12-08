Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0LHB4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:56:49 -0500
Received: from kroah.org ([198.145.64.141]:48533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0LHA7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:34 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005725.348573928@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [040/289] ath9k_htc: Update usb device ID list
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 32b089558c54792028f14ae830ca7c0a8d9ac9a3 upstream.

Added new VID/PIDs into supported devices list

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -36,8 +36,13 @@ static struct usb_device_id ath9k_hif_us
 	{ USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3346) }, /* IMC Networks */
+	{ USB_DEVICE(0x13D3, 0x3348) }, /* Azurewave */
+	{ USB_DEVICE(0x13D3, 0x3349) }, /* Azurewave */
+	{ USB_DEVICE(0x13D3, 0x3350) }, /* Azurewave */
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
 	{ USB_DEVICE(0x083A, 0xA704) }, /* SMC Networks */
+	{ USB_DEVICE(0x040D, 0x3801) }, /* VIA */
+	{ USB_DEVICE(0x1668, 0x1200) }, /* Verizon */
 	{ },
 };
 


