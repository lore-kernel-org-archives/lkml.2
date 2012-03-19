Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab2CSPSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:18:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48182 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032Ab2CSPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:18:07 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, "Justin P. Mattock" <justinmattock@gmail.com>,
        Andres Salomon <dilinger@queued.net>
Subject: [PATCH 3/5]NEXT:drivers:staging:olpc_dcon:olpc_dcon_xo_1.c Fix typo in staging:olpc_dcon
Date: Mon, 19 Mar 2012 08:17:51 -0700
Message-Id: <1332170273-3482-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
References: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo I found while reading.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
index cb6ce0c..c87fdfa 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -116,7 +116,7 @@ static int dcon_init_xo_1(struct dcon_priv *dcon)
 	cs5535_gpio_set(OLPC_GPIO_DCON_IRQ, GPIO_NEGATIVE_EDGE_STS);
 	cs5535_gpio_set(OLPC_GPIO_DCON_BLANK, GPIO_NEGATIVE_EDGE_STS);
 
-	/* FIXME:  Clear the posiitive status as well, just to be sure */
+	/* FIXME:  Clear the positive status as well, just to be sure */
 	cs5535_gpio_set(OLPC_GPIO_DCON_IRQ, GPIO_POSITIVE_EDGE_STS);
 	cs5535_gpio_set(OLPC_GPIO_DCON_BLANK, GPIO_POSITIVE_EDGE_STS);
 
-- 
1.7.5.4

