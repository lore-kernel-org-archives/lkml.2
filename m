Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1JKAHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:07:24 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:40714 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751061Ab1JKAHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:07:22 -0400
From: Roland Dreier <roland@purestorage.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH] MAINTAINERS: Update VT-d entry for drivers/pci -> drivers/iommu move
Date: Mon, 10 Oct 2011 17:07:15 -0700
Message-Id: <1318291635-1485-1-git-send-email-roland@purestorage.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com

Commit 166e9278a3f9 ("x86/ia64: intel-iommu: move to drivers/iommu/")
moved the VT-d driver to drivers/iommu, but left the "F:" line in
MAINTAINERS pointing to drivers/pci, which breaks scripts/get_maintainer.pl.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5483e0c..6a9bd2b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3313,7 +3313,7 @@ M:	David Woodhouse <dwmw2@infradead.org>
 L:	iommu@lists.linux-foundation.org
 T:	git git://git.infradead.org/iommu-2.6.git
 S:	Supported
-F:	drivers/pci/intel-iommu.c
+F:	drivers/iommu/intel-iommu.c
 F:	include/linux/intel-iommu.h
 
 INTEL IOP-ADMA DMA DRIVER
