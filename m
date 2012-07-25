Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2GYTkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:40:40 -0400
Received: from mail.tpi.com ([70.99.223.143]:4199 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2GYTki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:40:38 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Huang Shijie <shijie8@gmail.com>,
        Kang Yong <kangyong@telegent.com>,
        Zhang Xiaobing <xbzhang@telegent.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] tlg2300: Declare MODULE_FIRMWARE usage
Date: Wed, 25 Jul 2012 13:41:04 -0600
Message-Id: <1343245264-23291-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Huang Shijie <shijie8@gmail.com>
Cc: Kang Yong <kangyong@telegent.com>
Cc: Zhang Xiaobing <xbzhang@telegent.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/tlg2300/pd-main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index c096b3f..7b1f6eb 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -53,7 +53,8 @@ int debug_mode;
 module_param(debug_mode, int, 0644);
 MODULE_PARM_DESC(debug_mode, "0 = disable, 1 = enable, 2 = verbose");
 
-static const char *firmware_name = "tlg2300_firmware.bin";
+#define TLG2300_FIRMWARE "tlg2300_firmware.bin"
+static const char *firmware_name = TLG2300_FIRMWARE;
 static struct usb_driver poseidon_driver;
 static LIST_HEAD(pd_device_list);
 
@@ -532,3 +533,4 @@ MODULE_AUTHOR("Telegent Systems");
 MODULE_DESCRIPTION("For tlg2300-based USB device ");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.2");
+MODULE_FIRMWARE(TLG2300_FIRMWARE);
-- 
1.7.9.5

