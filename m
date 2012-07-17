Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2GQGTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:19:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50700 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2GQGTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:19:36 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-9d-500503f6ec00
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] CMA and DMA-mapping fixes for v3.5-rc7
Date: Tue, 17 Jul 2012 08:19:17 +0200
Message-id: <1342505957-31964-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd3vzKwBBidusFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mx7OXMBbM46qYeeEoSwNjC0cXIweHhICJxJYGoS5GTiBTTOLC
	vfVsILaQwCJGiXPPrbsYuYDs1UwS069vAkuwCRhKdL3tArNFBIwkPr+4wgpSxCzQxSTx7cIc
	RpCEsICVxNE1J1lAbBYBVYlzP2Yxg9i8Ah4Sfy/NZobYJi/x9H4f2wRG7gWMDKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgj34TGoH48oGi0OMAhyMSjy8HH9ZAoRYE8uKK3MPMUpwMCuJ
	8IocBQrxpiRWVqUW5ccXleakFh9ilOZgURLnNfb+6i8kkJ5YkpqdmlqQWgSTZeLglGpgjG/U
	DdZ4u6EqyHgF3wcXs+tK585WK88/tsml8jT/1KTkO0/XX+YREDxW693TV/hbKIZr96/N2n98
	pT9KzpnUZ/Dl0buU7lhFlx/7kzqFDqSrXbkpe8w7W/PoyQN6ft/OHvu5clPmqemnS5VPbLXU
	OsAWs6gthev0041qViJVX17MSQ8TnvOuSImlOCPRUIu5qDgRAND9JBbcAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I woukd like to ask you again for pulling another set of minor fixups
for recently merged Contiguous Memory Allocator and ARM DMA-mapping
changes. Those patches fix mysterious crashes on systems with CMA and
Himem enabled as well as some corner cases caused by typical off-by-one
bug. I'm sorry for a delay in sending this pull request which is caused
by my vacations.
 
The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

with the top-most commit 46c87852e99cf8ce97e207b11cde19085837e39c

  ARM: dma-mapping: modify condition check while freeing pages

are available in the git repository at:
  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-linus

Marek Szyprowski (1):
      mm: cma: fix condition check when setting global cma area

Prathyush K (1):
      ARM: dma-mapping: modify condition check while freeing pages

Rabin Vincent (1):
      mm: cma: don't replace lowmem pages with highmem

 arch/arm/mm/dma-mapping.c            |    4 ++--
 include/asm-generic/dma-contiguous.h |    2 +-
 mm/page_alloc.c                      |    7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center
