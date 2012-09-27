Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2I0IBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:01:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23318 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2I0IBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:01:45 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-3e-506407e7fc7a
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] DMA-mapping fix for v3.6
Date: Thu, 27 Sep 2012 10:01:20 +0200
Message-id: <1348732880-7141-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t9jAd3n7CkBBptumltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6ME53XWQvOsFV8m7yPvYHxAGsXIyeHhICJxNwLz5khbDGJC/fW
	s4HYQgKLGCWW9ZpB2CuYJJa+0wKx2QQMJbredoHViAgYSXx+cQVoDhcHs0AXk8S3C3MYQRLC
	AjoSa9buBRrKwcEioCox72UZSJhXwF1iyd+vLCBhCQEFiTmTbCYwci9gZFjFKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJEey9Z9I7GFc1WBxiFOBgVOLhDXBPDhBiTSwrrsw9xCjBwawkwrvp
	NlCINyWxsiq1KD++qDQntfgQozQHi5I4r/CnwAAhgfTEktTs1NSC1CKYLBMHp1QDI9tnj207
	kvYxcbzJ/T9hzWNvkydfDty5+rNJd9rHj8Ybnq4S3aTE8Tq17mDyxwPcPtzpppZKrsXZyTd8
	+yxkD2eVxC3n8OrhUeLQjGjgmpOdcDfeWvPmk9fPhdeeTA5hNbvZbVKoI7f/TRarUxDz9OWn
	L/Y8jV0X/K/v1MoPM4Vz3K8ymP48o8RSnJFoqMVcVJwIAOmq95baAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling yet another patch for ARM dma-mapping
subsystem to Linux v3.6 kernel tree. This patch fixes potential memory
leak ARM dma-mapping code.

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-3.6

for you to fetch changes up to ec10665cbf271fb1f60daeb194ad4f2cdcdc59d9:

  ARM: dma-mapping: Fix potential memory leak in atomic_pool_init() (2012-09-24 08:35:03 +0200)

----------------------------------------------------------------
Sachin Kamat (1):
      ARM: dma-mapping: Fix potential memory leak in atomic_pool_init()

 arch/arm/mm/dma-mapping.c |    2 ++
 1 file changed, 2 insertions(+)
