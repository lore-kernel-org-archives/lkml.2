Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667Ab2B2Jx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:53:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60344 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965223Ab2B2Jx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:53:56 -0500
MIME-Version: 1.0
In-Reply-To: <1329929337-16648-14-git-send-email-m.szyprowski@samsung.com>
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com> <1329929337-16648-14-git-send-email-m.szyprowski@samsung.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 29 Feb 2012 17:53:35 +0800
Message-ID: <CAGsJ_4ygM6YAUj5mcskuEYcaJqYVHp_qzbUJvE9_huFhFcWtkg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv23 13/16] drivers: add Contiguous Memory Allocator
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
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/23 Marek Szyprowski <m.szyprowski@samsung.com>:
> The Contiguous Memory Allocator is a set of helper functions for DMA
> mapping framework that improves allocations of contiguous memory chunks.
>
> CMA grabs memory on system boot, marks it with MIGRATE_CMA migrate type
> and gives back to the system. Kernel is allowed to allocate only movable
> pages within CMA's managed memory so that it can be used for example for
> page cache when DMA mapping do not use it. On
> dma_alloc_from_contiguous() request such pages are migrated out of CMA
> area to free required contiguous block and fulfill the request. This
> allows to allocate large contiguous chunks of memory at any time
> assuming that there is enough free memory available in the system.
>
> This code is heavily based on earlier works by Michal Nazarewicz.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Tested-by: Rob Clark <rob.clark@linaro.org>
> Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
> Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Tested-by: Robert Nelson <robertcnelson@gmail.com>

if there is a /proc/cmainfo like /proc/slabinfo, it might be helpful
to people as we can see the usage of CMA clearly.

Thanks
barry
