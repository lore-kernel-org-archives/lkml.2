Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2FTL7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:59:05 -0400
Received: from mxb.rambler.ru ([81.19.66.14]:62913 "EHLO mxb.rambler.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab2FTL7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:59:04 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2012 07:59:04 EDT
From: Dmitry Shmygov <shmygov@rambler.ru>
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jayden Kim <superbolt@cellient.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Shmygov <shmygov@rambler.ru>
Subject: [PATCH] USB: option: add id for Cellient MEN-200
Date: Wed, 20 Jun 2012 15:51:40 +0400
Message-Id: <1340193100-5920-1-git-send-email-shmygov@rambler.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add vendor and product ID to option.c driver
for Cellient MEN-200 EVDO Rev.B 450MHz data module.
http://cellient.com

Signed-off-by: Dmitry Shmygov <shmygov@rambler.ru>
---
 drivers/usb/serial/option.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e668a24..396d968 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -497,6 +497,10 @@ static void option_instat_callback(struct urb *urb);
 /* MediaTek products */
 #define MEDIATEK_VENDOR_ID			0x0e8d
 
+/* Cellient products */
+#define CELLIENT_VENDOR_ID			0x2692
+#define CELLIENT_PRODUCT_MEN200			0x9005
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1233,6 +1237,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
+	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
1.7.4.1

