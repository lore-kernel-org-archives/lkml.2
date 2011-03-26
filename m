Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab1CZBki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:40:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33697 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755783Ab1CZBke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:40:34 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+xeT9ELwexdbuQUF5QYB8XFsZsXzglPhXgDa8Aqv
	812JBs0Ko3xtUL
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 14/27] staging/olpc_dcon: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:39:23 +0100
Message-Id: <1301103576-16109-14-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
References: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very common spelling mistake in
drivers/staging/dcon.

WRONG -> RIGHT
interupt -> interrupt

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
index b154be7..b5d21f6 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -80,7 +80,7 @@ static int dcon_init_xo_1(struct dcon_priv *dcon)
 	lob &= ~(1 << DCON_IRQ);
 	outb(lob, 0x4d0);
 
-	/* Register the interupt handler */
+	/* Register the interrupt handler */
 	if (request_irq(DCON_IRQ, &dcon_interrupt, 0, "DCON", dcon)) {
 		printk(KERN_ERR "olpc-dcon: failed to request DCON's irq\n");
 		goto err_req_irq;
-- 
1.7.3.4

