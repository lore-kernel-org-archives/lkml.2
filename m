Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0LHA7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:35 -0500
Received: from kroah.org ([198.145.64.141]:48527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab0LHA7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:33 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005725.249891803@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Haitao Zhang <minipanda@linuxrobot.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [039/289] ath9k_htc: Add support for device ID 3346
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Haitao Zhang <minipanda@linuxrobot.org>

commit ac618d70aeb681df7b77c1107fdf26f3249f855f upstream.

This patch adds support for USB dongle with device ID 3346 from IMC Networks.

Signed-off-by: Haitao Zhang <minipanda@linuxrobot.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -35,6 +35,7 @@ static struct usb_device_id ath9k_hif_us
 	{ USB_DEVICE(0x07D1, 0x3A10) }, /* Dlink Wireless 150 */
 	{ USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
+	{ USB_DEVICE(0x13D3, 0x3346) }, /* IMC Networks */
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
 	{ USB_DEVICE(0x083A, 0xA704) }, /* SMC Networks */
 	{ },


