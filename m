Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab2KWJD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:03:58 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62344 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2KWJDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:03:55 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 0/2] vfio powerpc: implemented and enabled
Date: Fri, 23 Nov 2012 20:03:14 +1100
Message-Id: <1353661396-14374-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353435584.2234.87.camel@bling.home>
References: <1353435584.2234.87.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series includes IOMMU implementation and necessary IOMMU groups initialization.

Alexey Kardashevskiy (2):
  vfio powerpc: implemented IOMMU driver for VFIO
  vfio powerpc: enabled on powernv platform

 arch/powerpc/include/asm/iommu.h     |    6 +
 arch/powerpc/kernel/iommu.c          |  141 +++++++++++++++++++
 arch/powerpc/platforms/powernv/pci.c |  135 +++++++++++++++++++
 drivers/iommu/Kconfig                |    8 ++
 drivers/vfio/Kconfig                 |    6 +
 drivers/vfio/Makefile                |    1 +
 drivers/vfio/vfio_iommu_spapr_tce.c  |  247 ++++++++++++++++++++++++++++++++++
 include/linux/vfio.h                 |   20 +++
 8 files changed, 564 insertions(+)
 create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c

-- 
1.7.10.4

