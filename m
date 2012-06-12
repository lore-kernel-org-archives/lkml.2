Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2FLFKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 01:10:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52237 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2FLFKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 01:10:46 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] drivers/pci: fix kernel-doc warning
Date: Tue, 12 Jun 2012 13:10:35 +0800
Message-Id: <1339477835-8522-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Warning(drivers/pci/setup-bus.c:277): No description found for parameter 'fail_head'
Warning(drivers/pci/setup-bus.c:277): Excess function parameter 'failed_list' description in 'assign_requested_resources_sorted'

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8fa2d4b..9165d25 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -265,7 +265,7 @@ out:
  * assign_requested_resources_sorted() - satisfy resource requests
  *
  * @head : head of the list tracking requests for resources
- * @failed_list : head of the list tracking requests that could
+ * @fail_head : head of the list tracking requests that could
  *		not be allocated
  *
  * Satisfy resource requests of each element in the list. Add
-- 
1.7.9.5

