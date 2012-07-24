Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2GXUwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:52:07 -0400
Received: from mail.tpi.com ([70.99.223.143]:3810 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab2GXUwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:52:06 -0400
X-Greylist: delayed 1271 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2012 16:52:06 EDT
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Dean Anderson <linux-dev@sensoray.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: Add MODULE_FIRMWARE statement
Date: Tue, 24 Jul 2012 14:52:27 -0600
Message-Id: <1343163147-94118-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dean Anderson <linux-dev@sensoray.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/s2255drv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 01c2179..95007dd 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -2686,3 +2686,4 @@ MODULE_DESCRIPTION("Sensoray 2255 Video for Linux driver");
 MODULE_AUTHOR("Dean Anderson (Sensoray Company Inc.)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(S2255_VERSION);
+MODULE_FIRMWARE(FIRMWARE_FILE_NAME);
-- 
1.7.9.5

