Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2JZAjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:39:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:52963 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab2JZAGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hiro Sugawara <hsugawara@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 25/42] iommu/tegra: smmu: Fix deadly typo
Date: Thu, 25 Oct 2012 17:05:33 -0700
Message-Id: <20121026000127.316143568@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiro Sugawara <hsugawara@nvidia.com>

commit d0078e72314df2e5ede03f2102cddde06767c374 upstream.

Fix a deadly typo in macro definition.

Signed-off-by: Hiro Sugawara <hsugawara@nvidia.com>
Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/tegra-smmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -148,7 +148,7 @@
 
 #define SMMU_ADDR_TO_PFN(addr)	((addr) >> 12)
 #define SMMU_ADDR_TO_PDN(addr)	((addr) >> 22)
-#define SMMU_PDN_TO_ADDR(addr)	((pdn) << 22)
+#define SMMU_PDN_TO_ADDR(pdn)	((pdn) << 22)
 
 #define _READABLE	(1 << SMMU_PTB_DATA_ASID_READABLE_SHIFT)
 #define _WRITABLE	(1 << SMMU_PTB_DATA_ASID_WRITABLE_SHIFT)


