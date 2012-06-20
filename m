Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2FTSYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:24:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab2FTSYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:15 -0400
Message-Id: <20120620173039.912367583@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 04/20] USB: option: Add Vodafone/Huawei K5005 support
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 4cbbb039a9719fb3bba73d255c6a95bc6dc6428b upstream.

Tested-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -150,6 +150,7 @@ static void option_instat_callback(struc
 #define HUAWEI_PRODUCT_E14AC			0x14AC
 #define HUAWEI_PRODUCT_K3806			0x14AE
 #define HUAWEI_PRODUCT_K4605			0x14C6
+#define HUAWEI_PRODUCT_K5005			0x14C8
 #define HUAWEI_PRODUCT_K3770			0x14C9
 #define HUAWEI_PRODUCT_K3771			0x14CA
 #define HUAWEI_PRODUCT_K4510			0x14CB
@@ -666,6 +667,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3806, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0xff, 0x01, 0x31) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0xff, 0x01, 0x32) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0xff, 0x01, 0x33) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x31) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x32) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x31) },


