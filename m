Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2GZSeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:34:20 -0400
Received: from mail.tpi.com ([70.99.223.143]:3463 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab2GZSdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:33:41 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: [PATCH] cx231xx: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 12:34:22 -0600
Message-Id: <1343327662-95251-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/cx231xx/cx231xx-417.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/video/cx231xx/cx231xx-417.c
index ce2f622..b024e51 100644
--- a/drivers/media/video/cx231xx/cx231xx-417.c
+++ b/drivers/media/video/cx231xx/cx231xx-417.c
@@ -2193,3 +2193,5 @@ int cx231xx_417_register(struct cx231xx *dev)
 
 	return 0;
 }
+
+MODULE_FIRMWARE(CX231xx_FIRM_IMAGE_NAME);
-- 
1.7.9.5

