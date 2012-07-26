Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2GZSZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:25:44 -0400
Received: from mail.tpi.com ([70.99.223.143]:1184 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab2GZSZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:25:42 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: [PATCH] ivtv: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 12:26:20 -0600
Message-Id: <1343327180-94759-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: ivtv-devel@ivtvdriver.org
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/ivtv/ivtv-firmware.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/video/ivtv/ivtv-firmware.c b/drivers/media/video/ivtv/ivtv-firmware.c
index 02c5ade..6ec7705 100644
--- a/drivers/media/video/ivtv/ivtv-firmware.c
+++ b/drivers/media/video/ivtv/ivtv-firmware.c
@@ -396,3 +396,7 @@ int ivtv_firmware_check(struct ivtv *itv, char *where)
 
 	return res;
 }
+
+MODULE_FIRMWARE(CX2341X_FIRM_ENC_FILENAME);
+MODULE_FIRMWARE(CX2341X_FIRM_DEC_FILENAME);
+MODULE_FIRMWARE(IVTV_DECODE_INIT_MPEG_FILENAME);
-- 
1.7.9.5

