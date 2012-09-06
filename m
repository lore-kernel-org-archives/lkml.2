Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab2IFQLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:11:52 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41631 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701Ab2IFQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:44 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/10] drivers/media/dvb-frontends/itd1000.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:13 +0200
Message-Id: <1346947757-10481-6-git-send-email-peter.senna@gmail.com>
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
 drivers/media/dvb-frontends/itd1000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
--- a/drivers/media/dvb-frontends/itd1000.c
+++ b/drivers/media/dvb-frontends/itd1000.c
@@ -231,7 +231,7 @@ static void itd1000_set_lo(struct itd100
 	state->frequency = ((plln * 1000) + (pllf * 1000)/1048576) * 2*FREF;
 	itd_dbg("frequency: %dkHz (wanted) %dkHz (set), PLLF = %d, PLLN = %d\n", freq_khz, state->frequency, pllf, plln);
 
-	itd1000_write_reg(state, PLLNH, 0x80); /* PLLNH */;
+	itd1000_write_reg(state, PLLNH, 0x80); /* PLLNH */
 	itd1000_write_reg(state, PLLNL, plln & 0xff);
 	itd1000_write_reg(state, PLLFH, (itd1000_read_reg(state, PLLFH) & 0xf0) | ((pllf >> 16) & 0x0f));
 	itd1000_write_reg(state, PLLFM, (pllf >> 8) & 0xff);

