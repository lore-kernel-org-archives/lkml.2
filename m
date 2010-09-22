Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0IVN6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 09:58:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59776 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751757Ab0IVN6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 09:58:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Declare abx500_remove_ops()
Date: Wed, 22 Sep 2010 14:58:30 +0100
Message-Id: <1285163910-1789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise sparse warns about a public symbol with no declaration and
the compiler can't spot if the callers and users have different signatures
for the function.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/abx500.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index be7373c..67bd6f7 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -229,4 +229,5 @@ struct abx500_ops {
 };
 
 int abx500_register_ops(struct device *core_dev, struct abx500_ops *ops);
+void abx500_remove_ops(struct device *dev);
 #endif
-- 
1.7.1

