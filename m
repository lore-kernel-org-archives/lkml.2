Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2FGX4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:56:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37324 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2FGX4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:56:16 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] gpio: export devm_gpio_request_one
Date: Thu,  7 Jun 2012 17:56:09 -0600
Message-Id: <1339113369-27045-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Without this, modules can't use this API, leading to build failures.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This is useful in 3.5.

 drivers/gpio/devres.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 9e9947c..1077754 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -98,6 +98,7 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
 
 	return 0;
 }
+EXPORT_SYMBOL(devm_gpio_request_one);
 
 /**
  *      devm_gpio_free - free an interrupt
-- 
1.7.0.4

