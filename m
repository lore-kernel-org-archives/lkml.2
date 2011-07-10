Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab1GJJ2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:28:45 -0400
Received: from mail.perches.com ([173.55.12.10]:3724 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab1GJJ2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:28:34 -0400
From: Joe Perches <joe@perches.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] tps65910-irq: Add missing breaks in switch/case
Date: Sun, 10 Jul 2011 02:28:25 -0700
Message-Id: <ed4bdb25046a8623a0bcedc4167359ac4c905d01.1310289795.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <cover.1310289795.git.joe@perches.com>
References: <cover.1310289795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mfd/tps65910-irq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index 2bfad5c..a56be93 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -178,8 +178,10 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
 		tps65910->irq_num = TPS65910_NUM_IRQ;
+		break;
 	case TPS65911:
 		tps65910->irq_num = TPS65911_NUM_IRQ;
+		break;
 	}
 
 	/* Register with genirq */
-- 
1.7.6.131.g99019

