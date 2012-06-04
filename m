Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2FDGbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 02:31:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43800 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab2FDGbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 02:31:21 -0400
Date: Mon, 04 Jun 2012 08:31:10 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] CMA and ARM DMA-mapping fix for v3.5-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linaro-mm-sig@lists.linaro.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1338791470-16294-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
Content-transfer-encoding: 7BIT
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask for pulling a fix for Contiguous Memory Allocator
(CMA) integration for ARM architecture for v3.5-rc2.

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:
  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-linus

Marek Szyprowski (1):
      ARM: dma-mapping: remove unconditional dependency on CMA

 arch/arm/Kconfig          |    1 -
 arch/arm/mm/dma-mapping.c |   10 ++++------
 2 files changed, 4 insertions(+), 7 deletions(-)

Thanks!

Best regards
Marek Szyprowski
Samsung Poland R&D Center


