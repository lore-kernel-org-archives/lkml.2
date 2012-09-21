Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2IUHRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:17:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4196 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2IUHRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:17:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 21 Sep 2012 00:17:52 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <grant.likely@secretlab.ca>, <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] irqdomain: Removed unused variable description
Date: Fri, 21 Sep 2012 12:47:27 +0530
Message-ID: <1348211847-24252-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed description for unused variables: irq_base, nr_irq &
hwirq_base, from the irq_domain structure.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 include/linux/irqdomain.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 0d5b17b..a248aec 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -75,11 +75,6 @@ struct irq_domain_ops {
  * @ops: pointer to irq_domain methods
  * @host_data: private data pointer for use by owner.  Not touched by irq_domain
  *             core code.
- * @irq_base: Start of irq_desc range assigned to the irq_domain.  The creator
- *            of the irq_domain is responsible for allocating the array of
- *            irq_desc structures.
- * @nr_irq: Number of irqs managed by the irq domain
- * @hwirq_base: Starting number for hwirqs managed by the irq domain
  * @of_node: (optional) Pointer to device tree nodes associated with the
  *           irq_domain.  Used when decoding device tree interrupt specifiers.
  */
-- 
1.7.1.1

