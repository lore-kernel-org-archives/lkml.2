Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab2FOFyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 01:54:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53085 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2FOFyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 01:54:46 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-99-4fdace2436e5
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] DMA-mapping fixes for v3.5-rc3
Date: Fri, 15 Jun 2012 07:54:24 +0200
Message-id: <1339739664-31736-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQV2Vc7f8Dfb/0rG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZu/4dZSy4zlnx+sMztgbGs+xdjJwcEgImEg83PmCEsMUkLtxb
	z9bFyMUhJDCdUWLn8zOsEM5qJonJz3Yxg1SxCRhKdL3tYgOxRQSMJD6/uAJWxCzQxSTx7cIc
	sFHCQIlVDQ1gNouAqkTfxGtg63gFPCSu3z/HBLFOXuLp/T62CYzcCxgZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEe/GZ9A7GVQ0WhxgFOBiVeHgtNtzyF2JNLCuuzD3EKMHBrCTCKxQF
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM7bZH3BX0ggPbEkNTs1tSC1CCbLxMEp1cBoI95eZyL2
	hkPuvZLQGnvB6g1vjzt1npR2Lgg6fEvr3hHfiM8lVxqPP+yJv7fW22H1QaeY8K1Kj36c66jN
	2tb0qpNxbcZOBuGm5p+nvfm8jPI0hepmu2tqn50mnPZE4e+CXaoRC1+z7Gu2UuxLD7mY8WTK
	N8YDW32k+/6f3eY/s/jJ7q3976cqsRRnJBpqMRcVJwIAqVs8ct4BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling a set of minor fixes for dma-mapping
code (ARM and x86) required for Contiguous Memory Allocator (CMA)
patches merged in v3.5-rc1.

The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

with the top-most commit c080e26edc3a2a3cdfa4c430c663ee1c3bbd8fae

  x86: dma-mapping: fix broken allocation when dma_mask has been provided

are available in the git repository at:
  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-linus

Marek Szyprowski (3):
      ARM: mm: fix type of the arm_dma_limit global variable
      ARM: dma-mapping: fix debug messages in dmabounce code
      x86: dma-mapping: fix broken allocation when dma_mask has been provided

Sachin Kamat (1):
      ARM: dma-mapping: Add missing static storage class specifier

 arch/arm/common/dmabounce.c |   16 ++++++++--------
 arch/arm/mm/dma-mapping.c   |    4 ++--
 arch/arm/mm/init.c          |    2 +-
 arch/arm/mm/mm.h            |    2 +-
 arch/x86/kernel/pci-dma.c   |    3 ++-
 5 files changed, 14 insertions(+), 13 deletions(-)

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center

