Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab2A0O7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:59:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54455 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2A0O7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:59:31 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.166.112]
In-Reply-To: <010301ccdd03$1ad15ab0$50741010$%szyprowski@samsung.com>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-13-git-send-email-m.szyprowski@samsung.com>
 <CADMYwHw1B4RNV_9BqAg_M70da=g69Z3kyo5Cr6izCMwJ9LAtvA@mail.gmail.com>
 <00de01ccdce1$e7c8a360$b759ea20$%szyprowski@samsung.com> <CAO8GWqnQg-W=TEc+CUc8hs=GrdCa9XCCWcedQx34cqURhNwNwA@mail.gmail.com>
 <010301ccdd03$1ad15ab0$50741010$%szyprowski@samsung.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 27 Jan 2012 16:59:11 +0200
Message-ID: <CAK=WgbZWHBKNQwcoY9OiXXH-r1n3XxB=ZODZJN-3vZopU2yhJA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 12/15] drivers: add Contiguous Memory Allocator
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "Clark, Rob" <rob@ti.com>, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/27 Marek Szyprowski <m.szyprowski@samsung.com>:
> Ohad, could you tell a bit more about your issue?

Sure, feel free to ask.

> Does this 'large region'
> is a device private region (declared with dma_declare_contiguous())

Yes, it is.

See omap_rproc_reserve_cma() in:

http://git.kernel.org/?p=linux/kernel/git/ohad/remoteproc.git;a=commitdiff;h=dab6a2584550a629746fa1dea2be8ffbe1910277

Thanks,
Ohad.
