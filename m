Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2HIFxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:53:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24286 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2HIFxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:53:53 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-f3-5023506f51f8
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL] DMA-mapping fixups for v3.6-rc2
Date: Thu, 09 Aug 2012 07:53:25 +0200
Message-id: <1344491605-19770-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd38AOUAg9uPDS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGnmUrmQoWsVe0HNnP3sD4lrWLkZNDQsBEYvrmNcwQtpjEhXvr
	2boYuTiEBBYxSrzsmswM4axmkji0bSsbSBWbgKFE19suMFtEwEji84srrCBFzAJdTBLfLsxh
	BEkICxhLfF96jR3EZhFQlZjQeRNoEgcHr4CHxN9l0RDb5CWe3u9jm8DIvYCRYRWjaGpBckFx
	UnquoV5xYm5xaV66XnJ+7iZGsA+fSe1gXNlgcYhRgINRiYdXY4NSgBBrYllxZe4hRgkOZiUR
	3l1KygFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeY29v/oLCaQnlqRmp6YWpBbBZJk4OKUaGNXO
	W5rG1V8z89uxqSPL1fnIUvU2f4agorOzE7d9nmIp0Jqmv0Bw+VFn7ldSssqfPG8dkdtsL9fM
	aMPTN/tGxDuFyR5mifPY9++oS7rCeSRHZv+d8va1kddDhJ/lTQpZeWqVaOoHeVevB9mtj3p+
	73nvNMH8ZlXEgj//9ZN7Mn4WZPc27brOqMRSnJFoqMVcVJwIAN9TjivdAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling a set of fixup patches for ARM
dma-mapping extensions merged in v3.6-rc1.

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

with the top-most commit d9e0d149b5dcc2ef4688afc572b9906bcda941ef

  ARM: dma-mapping: fix incorrect freeing of atomic allocations

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-linus-for-3.6-rc2

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Aaro Koskinen (2):
      ARM: dma-mapping: fix atomic allocation alignment
      ARM: dma-mapping: fix incorrect freeing of atomic allocations

Chris Brand (1):
      ARM: mm: fix MMU mapping of CMA regions

 arch/arm/mm/dma-mapping.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)
