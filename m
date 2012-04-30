Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2D3Dib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 23:38:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45465 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab2D3Dia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 23:38:30 -0400
MIME-Version: 1.0
In-Reply-To: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 30 Apr 2012 11:38:09 +0800
Message-ID: <CAGsJ_4yAwh32u3tdWFA3BC76NpMws5RT_JnxnzNdHx6eoHHxMw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv24 00/16] Contiguous Memory Allocator
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Clark <rob.clark@linaro.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/3 Marek Szyprowski <m.szyprowski@samsung.com>:
> Hi,
>
> This is (yet another) update of CMA patches. I've rebased them onto
> recent v3.4-rc1 kernel tree and integrated some minor bugfixes. The
> first issue has been pointed by Sandeep Patil - alloc_contig_range
> reclaimed two times too many pages, second issue (possible mismatch
> between pageblock size and MAX_ORDER pages) has been recently spotted
> by Michal Nazarewicz.
>
> These patches are also available on my git repository:
> git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git 3.4-rc1-cma-v24
>
> Best regards
> Marek Szyprowski
> Samsung Poland R&D Center
>
>
>
> Patches in this patchset:

Marek,

how about the patch "mm: cma: add a simple kernel module as the helper
to test CMA", did you forget merging this?
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-March/088412.html

>
> Marek Szyprowski (6):
>  mm: extract reclaim code from __alloc_pages_direct_reclaim()
>  mm: trigger page reclaim in alloc_contig_range() to stabilise
>    watermarks
>  drivers: add Contiguous Memory Allocator
>  X86: integrate CMA with DMA-mapping subsystem
>  ARM: integrate CMA with DMA-mapping subsystem
>  ARM: Samsung: use CMA for 2 memory banks for s5p-mfc device
>
> Mel Gorman (1):
>  mm: Serialize access to min_free_kbytes
>
> Michal Nazarewicz (9):
>  mm: page_alloc: remove trailing whitespace
>  mm: compaction: introduce isolate_migratepages_range()
>  mm: compaction: introduce map_pages()
>  mm: compaction: introduce isolate_freepages_range()
>  mm: compaction: export some of the functions
>  mm: page_alloc: introduce alloc_contig_range()
>  mm: page_alloc: change fallbacks array handling
>  mm: mmzone: MIGRATE_CMA migration type added
>  mm: page_isolation: MIGRATE_CMA isolation functions added
>

-barry
