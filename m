Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132Ab0FKKRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:17:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37006 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0FKKRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:14 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] trivial: fix typos concerning "first"
Date: Fri, 11 Jun 2010 12:16:55 +0200
Message-Id: <1276251424-12806-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100611101624.GD10894@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/gianfar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 1830f31..abfdf93 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -904,7 +904,7 @@ static void gfar_init_filer_table(struct gfar_private *priv)
 	rqfar = cluster_entry_per_class(priv, rqfar, RQFPR_IPV4 | RQFPR_UDP);
 	rqfar = cluster_entry_per_class(priv, rqfar, RQFPR_IPV4 | RQFPR_TCP);
 
-	/* cur_filer_idx indicated the fisrt non-masked rule */
+	/* cur_filer_idx indicated the first non-masked rule */
 	priv->cur_filer_idx = rqfar;
 
 	/* Rest are masked rules */
-- 
1.7.1

