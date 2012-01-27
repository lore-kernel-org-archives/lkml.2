Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2A0PRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:17:12 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59305 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2A0PRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:17:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Fri, 27 Jan 2012 16:17:03 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [Linaro-mm-sig] [PATCH 12/15] drivers: add Contiguous Memory
 Allocator
In-reply-to: <CAK=WgbZWHBKNQwcoY9OiXXH-r1n3XxB=ZODZJN-3vZopU2yhJA@mail.gmail.com>
To: "'Ohad Ben-Cohen'" <ohad@wizery.com>
Cc: "'Clark, Rob'" <rob@ti.com>, "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <010501ccdd06$b9844f20$2c8ced60$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczdBEjs8DQtA0ycTbW8W50A1z3DcgAAcDpA
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-13-git-send-email-m.szyprowski@samsung.com>
 <CADMYwHw1B4RNV_9BqAg_M70da=g69Z3kyo5Cr6izCMwJ9LAtvA@mail.gmail.com>
 <00de01ccdce1$e7c8a360$b759ea20$%szyprowski@samsung.com>
 <CAO8GWqnQg-W=TEc+CUc8hs=GrdCa9XCCWcedQx34cqURhNwNwA@mail.gmail.com>
 <010301ccdd03$1ad15ab0$50741010$%szyprowski@samsung.com>
 <CAK=WgbZWHBKNQwcoY9OiXXH-r1n3XxB=ZODZJN-3vZopU2yhJA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, January 27, 2012 3:59 PM Ohad Ben-Cohen wrote:

> 2012/1/27 Marek Szyprowski <m.szyprowski@samsung.com>:
> > Ohad, could you tell a bit more about your issue?
> 
> Sure, feel free to ask.
> 
> > Does this 'large region'
> > is a device private region (declared with dma_declare_contiguous())
> 
> Yes, it is.
> 
> See omap_rproc_reserve_cma() in:
> 
> http://git.kernel.org/?p=linux/kernel/git/ohad/remoteproc.git;a=commitdiff;h=dab6a2584550a6297
> 46fa1dea2be8ffbe1910277

There have been some vmalloc layout changes merged to v3.3-rc1. Please check
if the hardcoded OMAP_RPROC_CMA_BASE+CONFIG_OMAP_DUCATI_CMA_SIZE fits into kernel
low-memory. Some hints you can find after the "Virtual kernel memory layout:" 
message during boot and using "cat /proc/iomem".

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



