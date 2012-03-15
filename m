Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761141Ab2COK7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:59:40 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:21330
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638Ab2COK7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:59:39 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0XAJ4-02-290-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] iommu/amd: Update git-tree in MAINTAINERS
Date: Thu, 15 Mar 2012 11:59:09 +0100
Message-ID: <1331809149-2652-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the kernel.org relaunch the URL for the IOMMU git tree
changed. Update MAINTAINERS file accordingly.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 75a9a5f..6f93a8d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -503,7 +503,7 @@ F:	arch/x86/include/asm/geode.h
 AMD IOMMU (AMD-VI)
 M:	Joerg Roedel <joerg.roedel@amd.com>
 L:	iommu@lists.linux-foundation.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
 S:	Supported
 F:	drivers/iommu/amd_iommu*.[ch]
 F:	include/linux/amd-iommu.h
-- 
1.7.5.4


