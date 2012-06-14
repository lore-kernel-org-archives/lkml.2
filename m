Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2FNJBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:01:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18766 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2FNJBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:01:31 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-cc-4fd9a8681b22
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Daniel Vetter'" <daniel@ffwll.ch>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Abhinav Kochhar'" <abhinav.k@samsung.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>
References: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
 <1339588218-24398-2-git-send-email-m.szyprowski@samsung.com>
 <20120613185202.GM4829@phenom.ffwll.local>
In-reply-to: <20120613185202.GM4829@phenom.ffwll.local>
Subject: RE: [Linaro-mm-sig] [PATCHv2 1/6] common: DMA-mapping: add
 DMA_ATTR_NO_KERNEL_MAPPING attribute
Date: Thu, 14 Jun 2012 11:01:11 +0200
Organization: SPRC
Message-id: <003601cd4a0c$431d7780$c9586680$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JlWxTqBhyV4fLSSuBbRWc9td6fAAdggfw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jAd2MFTf9DfqnsVt07PrKYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLuLn7OWNDMVdF14CdzA2MXRxcjJ4eEgInEw9mTWSFs
	MYkL99azdTFycQgJLGKUuHnhEguE85NRYs+ROSwgVWwChhJdb7vYQGwRAVWJ699fMoMUMQu8
	ZJZ4dewXVMcWRomns9vZQao4BcwlPjUcYQSxhQWyJJ40HAXq4OBgAeqe/4ARxOQXEJKYOEsB
	pIJXwEWiu+EhG4QtKPFj8j2wvcwCWhLrdx5ngrDlJTaveQs2RUJAXeLRX12Ic4wkTn/fzQ5R
	IiJxt+E56wRG4VlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc
	6s+kdjCubLA4xCjAwajEw3u476a/EGtiWXFl7iFGCQ5mJRHekMVAId6UxMqq1KL8+KLSnNTi
	Q4zSHCxK4rxN1hf8hQTSE0tSs1NTC1KLYLJMHJxSDYx6X64unv7kO8fqjjSrLu0rM8wzmLjV
	m3+bnthd+cTmru5RkUpmplUb7p1sN7k8Zc3KiOIjbU9frkoPqZH5H2wiJ9HdvsxvdeWsxbse
	P10fsmNyhTRj455aU/aCf5b7e+5P2trIZSp8q+zrtaxdc415zkV7tt++2+X5QT5fk/mV79a1
	M7zl9T8osRRnJBpqMRcVJwIATt2nG3ECAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, June 13, 2012 8:52 PM Daniel Vetter wrote:

> On Wed, Jun 13, 2012 at 01:50:13PM +0200, Marek Szyprowski wrote:
> > This patch adds DMA_ATTR_NO_KERNEL_MAPPING attribute which lets the
> > platform to avoid creating a kernel virtual mapping for the allocated
> > buffer. On some architectures creating such mapping is non-trivial task
> > and consumes very limited resources (like kernel virtual address space
> > or dma consistent address space). Buffers allocated with this attribute
> > can be only passed to user space by calling dma_mmap_attrs().
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Looks like a nice little extension to support dma-buf for the common case,
> so:
> 
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> One question is whether we should go right ahead and add kmap support for
> this, too (with a default implementation that simply returns a pointer to
> the coherent&contigous dma mem), but I guess that can wait until a
> use-case pops up.

I will wait with this until there will be real use cases. Let's get the
patch into mainline first.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


