Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab2IGPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:25:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61685 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2IGPZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:25:18 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/10] drivers/media/i2c/tea6415c.c: removes unnecessary semicolon
Date: Fri,  7 Sep 2012 17:24:46 +0200
Message-Id: <1347031488-26598-8-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/i2c/tea6415c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/media/i2c/tea6415c.c b/drivers/media/i2c/tea6415c.c
--- a/drivers/media/i2c/tea6415c.c
+++ b/drivers/media/i2c/tea6415c.c
@@ -81,7 +81,7 @@ static int tea6415c_s_routing(struct v4l
 	case 13:
 		byte = 0x28;
 		break;
-	};
+	}
 
 	switch (i) {
 	case 5:
@@ -108,7 +108,7 @@ static int tea6415c_s_routing(struct v4l
 	case 11:
 		byte |= 0x07;
 		break;
-	};
+	}
 
 	ret = i2c_smbus_write_byte(client, byte);
 	if (ret) {

