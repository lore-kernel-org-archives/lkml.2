Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2EXM34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:29:56 -0400
Received: from linux-sh.org ([111.68.239.195]:32850 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2EXM3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:29:55 -0400
Date: Thu, 24 May 2012 21:28:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Minchan Kim'" <minchan@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Krishna Reddy'" <vdumpa@nvidia.com>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Hiroshi Doyu'" <hdoyu@nvidia.com>,
        "'Subash Patel'" <subashrp@gmail.com>,
        "'Nick Piggin'" <npiggin@gmail.com>
Subject: Re: [PATCHv2 3/4] mm: vmalloc: add VM_DMA flag to indicate areas
 used by dma-mapping framework
Message-ID: <20120524122854.GD11860@linux-sh.org>
References: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com>
 <1337252085-22039-4-git-send-email-m.szyprowski@samsung.com>
 <4FBB3B41.8010102@kernel.org>
 <01e501cd39a8$67f34ea0$37d9ebe0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01e501cd39a8$67f34ea0$37d9ebe0$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:26:12PM +0200, Marek Szyprowski wrote:
> On Tuesday, May 22, 2012 9:08 AM Minchan Kim wrote:
> > Hmm, VM_DMA would become generic flag?
> > AFAIU, maybe VM_DMA would be used only on ARM arch.
> 
> Right now yes, it will be used only on ARM architecture, but maybe other architecture will
> start using it once it is available.
> 
There's very little about the code in question that is ARM-specific to
begin with. I plan to adopt similar changes on SH once the work has
settled one way or the other, so we'll probably use the VMA flag there,
too.
