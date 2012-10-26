Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2JZJfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:35:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10959 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2JZJfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:35:45 -0400
X-AuditID: cbfee61b-b7f616d00000319b-89-508a596f2661
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] Urgent DMA-mapping fix for v3.7-rc3
Date: Fri, 26 Oct 2012 11:35:35 +0200
Message-id: <1351244135-12703-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd38yK4Ag5OLhSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG8rftjAX9nBWHO16xNTDeYO9i5OSQEDCR+PZ5EguELSZx4d56
	ti5GLg4hgUWMEt1XTrNDOCuYJL7MWcIEUsUmYCjR9baLDcQWETCS+PziCitIEbPAVEaJr62z
	wBLCAuYS56f8YgaxWQRUJVpuvQaL8wp4SPRPuMDYxcgBtE5BYs4kmwmM3AsYGVYxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBPvwmfQOxlUNFocYBTgYlXh4N6R1BgixJpYVV+YeYpTgYFYS
	4d09FSjEm5JYWZValB9fVJqTWnyIUZqDRUmct9kjJUBIID2xJDU7NbUgtQgmy8TBKdXAGNV+
	P6XyQenxtMPGbdY9pgdeS74JPHtwxvwZa/ZJxriJrVgsMPX/vs4r7DNEnZ2Nmn2mbozYv6Lg
	I0u2vYNE2AH/5jXPLEyOMd/5uyZE7vSfbJfA7b/43Tf7ZbzmKPiXblV2eNHHaZorX/dIBq+I
	bl7sYjwl83nsi1bFr45X5Wzn+Vw2mCzfqcRSnJFoqMVcVJwIAFP36gXdAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling an urgent fix for ARM DMA-mapping
framework for v3.7-rc3. Due to my mistake, my previous pull request
(merged as cff7b8ba60e332377568c3d55c8036e9b1de32e6) contained a patch
which is aimed for v3.8 and lacks its dependences. This pull request
reverts it and fixes build break of ARM architecture.

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center

----------------------------------------------------------------

The following changes since commit 2ab3f29dddfb444c9fcc0a2f3a56ed4bdba41969:

  Merge branch 'akpm' (Andrew's fixes) (2012-10-25 16:05:57 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes_for_linus

for you to fetch changes up to 697575896670ba9e76760ce8bbc1f5a3001967d6:

  Revert "ARM: dma-mapping: support debug_dma_mapping_error" (2012-10-26 07:39:13 +0200)

----------------------------------------------------------------
Marek Szyprowski (1):
      Revert "ARM: dma-mapping: support debug_dma_mapping_error"

 arch/arm/include/asm/dma-mapping.h |    1 -
 1 file changed, 1 deletion(-)
