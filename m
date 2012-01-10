Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2AJImf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:42:35 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41004 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2AJImd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:42:33 -0500
Date: Tue, 10 Jan 2012 09:42:13 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv18 0/11] Contiguous Memory Allocator
In-reply-to: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org
Cc: "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Benjamin Gaignard'" <benjamin.gaignard@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>
Message-id: <012401cccf73$c013bf10$403b3d30$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AczGJt+jU0S+bP+zS0Oo1aeXqXr41QJQMudg
References: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

To help everyone in testing and adapting our patches for his hardware 
platform I've rebased our patches onto the latest v3.2 Linux kernel and
prepared a few GIT branches in our public repository. These branches
contain our memory management related patches posted in the following
threads:

"[PATCHv18 0/11] Contiguous Memory Allocator":
http://www.spinics.net/lists/linux-mm/msg28125.html
later called CMAv18,

"[PATCH 00/14] DMA-mapping framework redesign preparation":
http://www.spinics.net/lists/linux-sh/msg09777.html
and
"[PATCH 0/8 v4] ARM: DMA-mapping framework redesign":
http://www.spinics.net/lists/arm-kernel/msg151147.html
with the following update:
http://www.spinics.net/lists/arm-kernel/msg154889.html
later called DMAv5.

These branches are available in our public GIT repository:

git://git.infradead.org/users/kmpark/linux-samsung
http://git.infradead.org/users/kmpark/linux-samsung/

The following branches are available:

1) 3.2-cma-v18
Vanilla Linux v3.2 with fixed CMA v18 patches (first patch replaced
with the one from v17 to fix SMP issues, see the respective thread).

2) 3.2-dma-v5
Vanilla Linux v3.2 + iommu/next (IOMMU maintainer's patches) branch
with DMA-preparation and DMA-mapping framework redesign patches.

3) 3.2-cma-v18-dma-v5
Previous two branches merged together (DMA-mapping on top of CMA)

4) 3.2-cma-v18-dma-v5-exynos
Previous branch rebased on top of iommu/next + kgene/for-next (Samsung
SoC platform maintainer's patches) with new Exynos4 IOMMU driver by 
KyongHo Cho and relevant glue code.

5) 3.2-dma-v5-exynos
Branch from point 2 rebased on top of iommu/next + kgene/for-next 
(Samsung SoC maintainer's patches) with new Exynos4 IOMMU driver by 
KyongHo Cho and relevant glue code.

I hope everyone will find a branch that suits his needs. :)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



