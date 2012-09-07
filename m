Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2IGPZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:25:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58800 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2IGPZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:25:17 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/10] drivers/media/dvb-frontends/tda10071.c: removes unnecessary semicolon
Date: Fri,  7 Sep 2012 17:24:43 +0200
Message-Id: <1347031488-26598-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/dvb-frontends/tda10071.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -257,7 +257,7 @@ static int tda10071_set_voltage(struct d
 				__func__);
 		ret = -EINVAL;
 		goto error;
-	};
+	}
 
 	cmd.args[0] = CMD_LNB_SET_DC_LEVEL;
 	cmd.args[1] = 0;
@@ -369,7 +369,7 @@ static int tda10071_diseqc_recv_slave_re
 	if (ret)
 		goto error;
 
-	reply->msg_len = tmp & 0x1f; /* [4:0] */;
+	reply->msg_len = tmp & 0x1f; /* [4:0] */
 	if (reply->msg_len > sizeof(reply->msg))
 		reply->msg_len = sizeof(reply->msg); /* truncate API max */
 

