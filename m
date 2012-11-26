Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967Ab2KZROF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:14:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab2KZROA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hiro Sugawara <hsugawara@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 226/270] iommu/tegra: smmu: Fix deadly typo
Date: Mon, 26 Nov 2012 14:58:36 -0200
Message-Id: <1353949160-26803-227-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiro Sugawara <hsugawara@nvidia.com>

commit d0078e72314df2e5ede03f2102cddde06767c374 upstream.

Fix a deadly typo in macro definition.

Signed-off-by: Hiro Sugawara <hsugawara@nvidia.com>
Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/iommu/tegra-smmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 3f3d09d..1fcc936 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -148,7 +148,7 @@
 
 #define SMMU_ADDR_TO_PFN(addr)	((addr) >> 12)
 #define SMMU_ADDR_TO_PDN(addr)	((addr) >> 22)
-#define SMMU_PDN_TO_ADDR(addr)	((pdn) << 22)
+#define SMMU_PDN_TO_ADDR(pdn)	((pdn) << 22)
 
 #define _READABLE	(1 << SMMU_PTB_DATA_ASID_READABLE_SHIFT)
 #define _WRITABLE	(1 << SMMU_PTB_DATA_ASID_WRITABLE_SHIFT)
-- 
1.7.9.5

