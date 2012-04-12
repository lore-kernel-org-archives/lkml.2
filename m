Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801Ab2DLVAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:00:14 -0400
Received: from mail.tpi.com ([70.99.223.143]:3909 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab2DLVAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:00:12 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH linux-next] staging: go7007: Add MODULE_FIRMWARE
Date: Thu, 12 Apr 2012 15:00:07 -0600
Message-Id: <1334264407-111159-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/media/go7007/s2250-loader.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/go7007/s2250-loader.c b/drivers/staging/media/go7007/s2250-loader.c
index 4e13251..829c248 100644
--- a/drivers/staging/media/go7007/s2250-loader.c
+++ b/drivers/staging/media/go7007/s2250-loader.c
@@ -189,3 +189,5 @@ module_exit(s2250loader_cleanup);
 MODULE_AUTHOR("");
 MODULE_DESCRIPTION("firmware loader for Sensoray 2250/2251");
 MODULE_LICENSE("GPL v2");
+MODULE_FIRMWARE(S2250_LOADER_FIRMWARE);
+MODULE_FIRMWARE(S2250_FIRMWARE);
-- 
1.7.9.5

