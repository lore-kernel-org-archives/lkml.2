Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab2FGX5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:57:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34110 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab2FGX5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:57:41 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] of: export of_platform_populate()
Date: Thu,  7 Jun 2012 17:57:36 -0600
Message-Id: <1339113456-27089-1-git-send-email-swarren@wwwdotorg.org>
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

 drivers/of/platform.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 343ad29..3132ea0 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -462,4 +462,5 @@ int of_platform_populate(struct device_node *root,
 	of_node_put(root);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(of_platform_populate);
 #endif /* CONFIG_OF_ADDRESS */
-- 
1.7.0.4

