Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0GUVTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:19:08 -0400
Received: from mail.perches.com ([173.55.12.10]:2028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755703Ab0GUVTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:19:04 -0400
Subject: [PATCH net-next] drivers/net/qlge: Remove duplicated initial DUMP_
 macro entries
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100721.135800.43444396.davem@davemloft.net>
References: <1279576149.5434.59.camel@Joe-Laptop.home>
	 <20100721.135800.43444396.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 14:19:01 -0700
Message-ID: <1279747141.1909.22.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of errors in the previous patch.
Two of the first DUMP_<foo> entries are duplicated.
Sorry, bad use of emacs macros...

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/qlge/qlge_dbg.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/qlge/qlge_dbg.c b/drivers/net/qlge/qlge_dbg.c
index 9d9498b..4747492 100644
--- a/drivers/net/qlge/qlge_dbg.c
+++ b/drivers/net/qlge/qlge_dbg.c
@@ -1465,7 +1465,6 @@ void ql_dump_regs(struct ql_adapter *qdev)
 {
 	pr_err("reg dump for function #%d\n", qdev->func);
 	DUMP_REG(qdev, SYS);
-	DUMP_REG(qdev, SYS);
 	DUMP_REG(qdev, RST_FO);
 	DUMP_REG(qdev, FSC);
 	DUMP_REG(qdev, CSR);
@@ -1535,7 +1534,6 @@ void ql_dump_stat(struct ql_adapter *qdev)
 {
 	pr_err("%s: Enter\n", __func__);
 	DUMP_STAT(qdev, tx_pkts);
-	DUMP_STAT(qdev, tx_pkts);
 	DUMP_STAT(qdev, tx_bytes);
 	DUMP_STAT(qdev, tx_mcast_pkts);
 	DUMP_STAT(qdev, tx_bcast_pkts);


