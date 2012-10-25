Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2JYFli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:41:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44270 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2JYFlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:41:36 -0400
X-AuditID: cbfee61b-b7f616d00000319b-d9-5088d10e5f5e
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] CMA and DMA-mapping fixes for v3.7-rc3
Date: Thu, 25 Oct 2012 07:40:58 +0200
Message-id: <1351143658-30902-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAV2+ix0BBl8/KFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mp//mMxX081fcmT6bsYHxDXcXIyeHhICJxNv789khbDGJC/fW
	s3UxcnEICSxilDgxdSErhLOCSWJL42QmkCo2AUOJrrddbCC2iICRxOcXV8CKmAW6mCS+XZjD
	CJIQFrCSOPH3MAuIzSKgKtFx+R7YCl4BD4k7c44BDeIAWqcgMWeSzQRG7gWMDKsYRVMLkguK
	k9JzjfSKE3OLS/PS9ZLzczcxgn34THoH46oGi0OMAhyMSjy8Bz06AoRYE8uKK3MPMUpwMCuJ
	8E5+0B4gxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVASCA9sSQ1OzW1ILUIJsvEwSnVwJia
	sqn7Qedado6rP0TPL7+ZcGn3nTMuxhdmPYzcsnOvv+mO27P/8nI2bGcwCF9+Y5n9Ne3Hs13P
	pxlqr5yTxu98XOaKUs5hnvTcZU9X1n1K33K49Idg//GiVktDzm2/N0/+E1aZvUxKdd72/h+W
	/r8lmjWL7q5N2PU3R17BwUlngtGsDsaVsY5KLMUZiYZazEXFiQDjE7393QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling some minor fixes for both CMA
(Contiguous Memory Allocator) and DMA-mapping framework for v3.7-rc3.

----------------------------------------------------------------

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes_for_linus

for you to fetch changes up to 4e85fb831aa210fd1c5e2cb7909ac203c1f5b67f:

  ARM: mm: Remove unused arm_vmregion priv field (2012-10-24 07:38:15 +0200)

----------------------------------------------------------------

This pull request consists mainly of a set of one-liner fixes and
cleanups for a few minor issues identified in both Contiguous Memory
Allocator code and ARM DMA-mapping subsystem.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center

----------------------------------------------------------------

Patch summary:

Bob Liu (1):
      mm: cma: alloc_contig_range: return early for err path

Jingoo Han (1):
      ARM: dma-mapping: fix build warning in __dma_alloc()

Laurent Pinchart (4):
      drivers: dma-contiguous: Don't redefine SZ_1M
      drivers: dma-coherent: Fix typo in dma_mmap_from_coherent documentation
      drivers: cma: Fix wrong CMA selected region size default value
      ARM: mm: Remove unused arm_vmregion priv field

Ming Lei (1):
      ARM: dma-mapping: support debug_dma_mapping_error

 arch/arm/include/asm/dma-mapping.h |    1 +
 arch/arm/mm/dma-mapping.c          |    2 +-
 arch/arm/mm/vmregion.h             |    1 -
 drivers/base/Kconfig               |    2 +-
 drivers/base/dma-coherent.c        |    5 ++---
 drivers/base/dma-contiguous.c      |    5 +----
 mm/page_alloc.c                    |    2 +-
 7 files changed, 7 insertions(+), 11 deletions(-)
