Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1KWMvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:51:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39063 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab1KWMvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:51:15 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] irq: Prototype irqdomain mapping functions
Date: Wed, 23 Nov 2011 12:51:04 +0000
Message-Id: <1322052664-20249-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that irq_create_of_mapping() and irq_dispose_mapping() match their
prototypes by including the relevant header file.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/irq/irqdomain.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 4dc9826..a3a90e2 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -4,6 +4,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/slab.h>
 
 static LIST_HEAD(irq_domain_list);
-- 
1.7.7.3

