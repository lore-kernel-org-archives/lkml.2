Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab0KGFQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 01:16:34 -0400
Received: from [218.247.216.29] ([218.247.216.29]:58770 "EHLO
	mail.linuxfire.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0KGFQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 01:16:32 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Nov 2010 01:16:32 EDT
From: Haitao Zhang <minipanda@linuxrobot.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k_htc: Add support for device ID 3346
Date: Sun,  7 Nov 2010 12:50:24 +0800
Message-Id: <1289105424-3597-1-git-send-email-minipanda@linuxrobot.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for USB dongle with device ID 3346 from IMC Networks.

Signed-off-by: Haitao Zhang <minipanda@linuxrobot.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 6576f68..2f6b1e9 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -35,6 +35,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x07D1, 0x3A10) }, /* Dlink Wireless 150 */
 	{ USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
+	{ USB_DEVICE(0x13D3, 0x3346) }, /* IMC Networks */
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
 	{ USB_DEVICE(0x083A, 0xA704) }, /* SMC Networks */
 	{ },
-- 
1.7.0.4

