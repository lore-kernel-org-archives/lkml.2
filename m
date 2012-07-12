Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161922Ab2GLWlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:41:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161766Ab2GLWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Shmygov <shmygov@rambler.ru>
Subject: [ 095/187] USB: option: add id for Cellient MEN-200
Date: Thu, 12 Jul 2012 15:34:11 -0700
Message-Id: <20120712191531.208084182@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Shmygov <shmygov@rambler.ru>

commit 1e2c4e59d2b8797973471b4a287a43eac12a0f40 upstream.

Add vendor and product ID to option.c driver
for Cellient MEN-200 EVDO Rev.B 450MHz data module.
http://cellient.com

Signed-off-by: Dmitry Shmygov <shmygov@rambler.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -497,6 +497,10 @@ static void option_instat_callback(struc
 /* MediaTek products */
 #define MEDIATEK_VENDOR_ID			0x0e8d
 
+/* Cellient products */
+#define CELLIENT_VENDOR_ID			0x2692
+#define CELLIENT_PRODUCT_MEN200			0x9005
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE = 0,
@@ -1233,6 +1237,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
+	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);


