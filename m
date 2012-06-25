Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2FYId5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:33:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13197 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FYId4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:33:56 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-db-4fe8226bf26a
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] DMA-mapping fixes for v3.5-rc5
Date: Mon, 25 Jun 2012 10:33:22 +0200
Message-id: <1340613202-1053-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jAd1spRf+Bru/cltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mxg//2Au+slZ8vD6TqYHxFUsXIyeHhICJxJ65b5kgbDGJC/fW
	s3UxcnEICSxilPj54SoLhLOaSWLp5UfMIFVsAoYSXW+72EBsEQEjic8vrrCCFDELdDFJfLsw
	hxEkIQyU6OjdATaWRUBV4u2xDlYQm1fAXWJr21ZmiHXyEk/v97FNYORewMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyPYi8+kdjCubLA4xCjAwajEw9sg9cJfiDWxrLgy9xCjBAezkggv
	ByNQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+T9QV/IYH0xJLU7NTUgtQimCwTB6dUA2O6Wp3x
	K+nJqQ+rRcRChesLZ3lsi4ze9tb53JpdzpJcGw/7BEzZ0rktMOqJXGUyz+bVB7dp6zV+OPJe
	+sR397DHigac6165bteNnijfInc0KllEnOXC1TJzn58pa+9U+WQYGf3fukWqhK9++8tP01W1
	4uWeciXpqZZenBtVXn3v+QGOK7wfdyuxFGckGmoxFxUnAgAMWpAM3gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling another minor fixup for ARM dma-mapping
redesign and extensions merged in v3.5-rc1.

The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4 (2012-06-24 12:53:04 -0700)

with the top-most commit 593f47355467b9ef44293698817e2bdb347e2d11

  ARM: dma-mapping: fix buffer chunk allocation order

are available in the git repository at:
  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-linus

Marek Szyprowski (1):
      ARM: dma-mapping: fix buffer chunk allocation order

 arch/arm/mm/dma-mapping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center

