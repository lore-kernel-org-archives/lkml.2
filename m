Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab2EWQa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:30:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59008 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab2EWQax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:30:53 -0400
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][TRIVIAL] mfd: Remove unused variable "desc" from function da9052_device_init.
Date: Wed, 23 May 2012 17:30:48 +0100
Message-Id: <1337790648-5483-1-git-send-email-krzysztof.wilczynski@linux.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to address the following warning during compilation time:

  drivers/mfd/da9052-core.c: In function ‘da9052_device_init’:
  drivers/mfd/da9052-core.c:646: warning: unused variable ‘desc’

This variable is indeed no longer in use (change can be traced back
to commit: 8614419451d88bf99fff7f5e468fe45f8450891e).

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/mfd/da9052-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 7776aff..88c2c26 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -643,7 +643,6 @@ EXPORT_SYMBOL_GPL(da9052_regmap_config);
 int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
-	struct irq_desc *desc;
 	int ret;
 
 	if (pdata && pdata->init != NULL)
-- 
1.7.2.5

