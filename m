Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab2J2SIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:08:22 -0400
Received: from 8bytes.org ([85.214.48.195]:59545 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228Ab2J2SIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:08:20 -0400
From: Joerg Roedel <joro@8bytes.org>
To: linux-kernel@vger.kernel.org
Cc: iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/2] iommu/amd: Update MAINTAINERS entry
Date: Mon, 29 Oct 2012 19:08:16 +0100
Message-Id: <1351534096-28538-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Oct 29 19:08:18 2012
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 508ec61222971173769406
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no access to my AMD email address anymore. Update
entry in MAINTAINERS to the new address.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 027ec2b..0267ba2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -526,10 +526,10 @@ F:	drivers/video/geode/
 F:	arch/x86/include/asm/geode.h
 
 AMD IOMMU (AMD-VI)
-M:	Joerg Roedel <joerg.roedel@amd.com>
+M:	Joerg Roedel <joro@8bytes.org>
 L:	iommu@lists.linux-foundation.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
-S:	Supported
+S:	Maintained
 F:	drivers/iommu/amd_iommu*.[ch]
 F:	include/linux/amd-iommu.h
 
-- 
1.7.9.5


