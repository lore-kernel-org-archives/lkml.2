Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2G1AC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 20:02:58 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:56836 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2G1AC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 20:02:56 -0400
From: Yann Cantin <yann.cantin@laposte.net>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, Yann Cantin <yann.cantin@laposte.net>
Subject: [RFC ebeam PATCH 1/3] hid: hid-ids.h: Add vendor and device ID for eBeam classic device.
Date: Sat, 28 Jul 2012 02:02:32 +0200
Message-Id: <1343433754-3887-2-git-send-email-yann.cantin@laposte.net>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343433754-3887-1-git-send-email-yann.cantin@laposte.net>
References: <1343433754-3887-1-git-send-email-yann.cantin@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
---
 drivers/hid/hid-ids.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 41c34f2..8cd4b8e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -271,6 +271,9 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349	0x7349
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
+#define USB_VENDOR_ID_EFI		0x2650
+#define USB_DEVICE_ID_EFI_CLASSIC	0x1311
+
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
 
-- 
1.7.10

