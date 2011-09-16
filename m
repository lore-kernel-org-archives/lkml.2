Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1IPRwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:52:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53304 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1IPRwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:52:17 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v3 0/6] iommu: split mapping to page sizes as supported by the hardware
Date: Fri, 16 Sep 2011 20:51:40 +0300
Message-Id: <1316195506-9777-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3:

- s/KB/KiB/ (David W)

v1->v2:

- split to patches (by keeping the old code around until all drivers are converted) (Joerg)


Ohad Ben-Cohen (6):
  iommu/core: split mapping to page sizes as supported by the hardware
  iommu/omap: announce supported page sizes
  iommu/msm: announce supported page sizes
  iommu/amd: announce supported page sizes
  iommu/intel: announce supported page sizes
  iommu/core: remove the temporary register_iommu_pgsize API

 drivers/iommu/amd_iommu.c   |   20 ++++++-
 drivers/iommu/intel-iommu.c |   20 ++++++-
 drivers/iommu/iommu.c       |  130 +++++++++++++++++++++++++++++++++++++++----
 drivers/iommu/msm_iommu.c   |    8 ++-
 drivers/iommu/omap-iommu.c  |    6 ++-
 drivers/iommu/omap-iovmm.c  |   12 +---
 include/linux/iommu.h       |    7 +-
 virt/kvm/iommu.c            |    4 +-
 8 files changed, 177 insertions(+), 30 deletions(-)

-- 
1.7.4.1

