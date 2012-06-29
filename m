Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2F2NA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:00:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49198 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2F2NAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:00:55 -0400
X-AuditID: cbfee61b-b7f776d000002f3f-82-4feda706d738
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Clemens Ladisch'" <clemens@ladisch.de>
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'David Gibson'" <david@gibson.dropbear.id.au>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'Sumit Semwal'" <sumit.semwal@linaro.org>
References: <1339741135-7841-1-git-send-email-m.szyprowski@samsung.com>
 <4FED8D03.10507@ladisch.de>
In-reply-to: <4FED8D03.10507@ladisch.de>
Subject: RE: [PATCH] common: dma-mapping: add support for generic dma_mmap_*
 calls
Date: Fri, 29 Jun 2012 15:00:37 +0200
Organization: SPRC
Message-id: <00a501cd55f7$323946f0$96abd4d0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1V57vKxP88kqEOQMOKJoqJe7/9qgADmtWQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jAV225W/9DW6cF7Ho2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVs+aNR8IGl4ub0sywNjI+Zuxg5OSQETCQerrzBBGGL
	SVy4t56ti5GLQ0hgEaPExle7WSCcn4wSL16sYAOpYhMwlOh62wVmiwhoSZz5tpwdpIhZYDuL
	xP/eiWCjhARSJTbNu8QKYnMKaEgc3P6UHcQWFgiR2LNlB1icRUBV4t6tBUD1HBz8AkISE2cp
	gIR5BVwkmnt+sELYghI/Jt9jAbGZgXat33mcCcKWl9i85i0zSKuEgLrEo7+6EOcYSSyf3sYI
	USIicbfhOesERuFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	HOjPpHcwrmqwOMQowMGoxMOrsOitvxBrYllxZe4hRgkOZiUR3oeLgUK8KYmVValF+fFFpTmp
	xYcYpTlYlMR5m6wv+AsJpCeWpGanphakFsFkmTg4pRoYC44wWRyRPGP3r63RRdjRe96cRWqN
	85q7Z6j7xdot7Cp7fcTz0T9GMc0dWsdveK2Y6BFz46rc9qWqa19VNTxd9INfx+vxnY/5vz0n
	X45h35XwZFfQ+xuLk2+ePROXGado/yXr7UOPwk36Z0v/7tPauuft+kn31m2VUfm56t/6srNs
	Xbq1341+JCmxFGckGmoxFxUnAgAnUu5bcAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, June 29, 2012 1:10 PM Clemens Ladisch wrote:

> Marek Szyprowski wrote:
> > +++ b/drivers/base/dma-mapping.c
> > ...
> > +int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
> > +		    void *cpu_addr, dma_addr_t dma_addr, size_t size)
> > +{
> > +	int ret = -ENXIO;
> > +	...
> > +	if (dma_mmap_from_coherent(dev, vma, cpu_addr, size, &ret))
> > +		return ret;
> 
> This will return -ENXIO if dma_mmap_from_coherent() succeeds.
 
Thanks for spotting this! I will fix it in the next version of the patch.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


