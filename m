Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2IFQLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:11:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39066 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab2IFQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:44 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/10] drivers/media/dvb-frontends/sp8870.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:12 +0200
Message-Id: <1346947757-10481-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/dvb-frontends/sp8870.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -188,7 +188,7 @@ static int configure_reg0xc05 (struct dt
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	switch (p->hierarchy) {
 	case HIERARCHY_NONE:
@@ -207,7 +207,7 @@ static int configure_reg0xc05 (struct dt
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	switch (p->code_rate_HP) {
 	case FEC_1_2:
@@ -229,7 +229,7 @@ static int configure_reg0xc05 (struct dt
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	if (known_parameters)
 		*reg0xc05 |= (2 << 1);	/* use specified parameters */

