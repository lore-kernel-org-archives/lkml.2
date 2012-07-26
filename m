Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2GZSip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:38:45 -0400
Received: from mail.tpi.com ([70.99.223.143]:3474 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab2GZSio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:38:44 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steven Toth <stoth@kernellabs.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: [PATCH] cx23885: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 12:39:24 -0600
Message-Id: <1343327964-95791-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steven Toth <stoth@kernellabs.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/cx23885/cx23885-417.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index f5c79e5..5d5052d 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1786,3 +1786,5 @@ int cx23885_417_register(struct cx23885_dev *dev)
 
 	return 0;
 }
+
+MODULE_FIRMWARE(CX23885_FIRM_IMAGE_NAME);
-- 
1.7.9.5

