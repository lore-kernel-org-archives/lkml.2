Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2AXPbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:31:38 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:58272
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751473Ab2AXPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:31:37 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: dwmw2@infradead.org, iommu@lists.linux-foundation.org
Cc: standby24x7@gmail.com, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] [trivial] iommu: Fix typo in intel-iommu.c
Date: Wed, 25 Jan 2012 00:25:52 +0900
Message-Id: <1327418752-3622-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "supportd" to "supported" in
drivers/iommu/intel-iommu.c

Signed-off-by: Masanari Iida<standby24x7@gmail.com>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c9c6053..e23f273 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1241,7 +1241,7 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	unsigned long nlongs;
 
 	ndomains = cap_ndoms(iommu->cap);
-	pr_debug("IOMMU %d: Number of Domains supportd <%ld>\n", iommu->seq_id,
+	pr_debug("IOMMU %d: Number of Domains supported <%ld>\n", iommu->seq_id,
 			ndomains);
 	nlongs = BITS_TO_LONGS(ndomains);
 
-- 
1.7.6.5

