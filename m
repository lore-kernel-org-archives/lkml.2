Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3AJSGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:06:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20265 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3AJSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:06:40 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d9-50ef032f01a7
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Joerg Roedel'" <joro@8bytes.org>
Cc: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
References: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
 <032401cde783$485ae1a0$d910a4e0$@samsung.com>
 <20130110171844.GA2650@8bytes.org>
In-reply-to: <20130110171844.GA2650@8bytes.org>
Subject: RE: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Thu, 10 Jan 2013 10:06:24 -0800
Message-id: <026e01cdef5d$364fd150$a2ef73f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFIekVXHKw0ow7bnqULS98EzrZJiAHrktOYAWxAehSZMvzAIA==
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zY1195vcBBv+3yFpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXs6RcvOCtUcfrfU7YGxve8XYycHBICJhKTd3QyQdhi
	EhfurWcDsYUEljFK7P6tB1NzY9km5i5GLqD4dEaJF5PuM0E4fxklfpx9AdbBJqAhcfj9M3YQ
	W0RARaLl3A9mEJtZYBezxNRzEhANkxglJk3aygKS4BTQl2j7PRWsSFggUWL1hZ1AUzk4WARU
	JXZ224GEeQUsJS5cns8KYQtK/Jh8jwVippbE+p3HmSBseYnNa94yQ1yqILHj7GtGkDEiAk4S
	81f6Q5SIS0x68BDsNBYBAYlvkw+xgJRICMhKbDoA9peEwCp2iUsLV7NBjJGUOLjiBssERolZ
	SDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjJMKkdzCuarA4xCjA
	wajEw6vl+y5AiDWxrLgy9xCjBAezkghvywKgEG9KYmVValF+fFFpTmrxIUYfoMsnMkuJJucD
	oz+vJN7Q2NjEzMTUxNzS1NwUh7CSOC/jqScBQgLpiSWp2ampBalFMOOYODilGhhLzPL9JWXk
	tjC3H5zDWhe/8928ytzWk4555xMl4uvZJULeb2BY5PdAiPHqlEwry6Wns/T2lPyc9CX8yamt
	58VKjzc+8jw40SvQeavUgurm9BuP7t6O/H7oxkx196lBe8+ouG71UJnnFyp0VyT/jd7S7XUN
	GR9kZ16a6tll3fnZo/1/o+lF4WQlluKMREMt5qLiRACzb5TO3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQV195vcBBtfXiVtc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm7OkXLzgrVHH6
	31O2Bsb3vF2MnBwSAiYSN5ZtYoawxSQu3FvP1sXIxSEkMJ1R4sWk+0wQzl9GiR9nX7CBVLEJ
	aEgcfv+MHcQWEVCRaDn3A6ybWWAXs8TUcxIQDZMYJSZN2soCkuAU0Jdo+z0VrEhYIFFi9YWd
	QFM5OFgEVCV2dtuBhHkFLCUuXJ7PCmELSvyYfI8FYqaWxPqdx5kgbHmJzWveQl2qILHj7GtG
	kDEiAk4S81f6Q5SIS0x68JB9AqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswt
	Ls1L10vOz93ECI7gZ9I7GFc1WBxiFOBgVOLh1fJ9FyDEmlhWXJl7iFGCg1lJhLdlAVCINyWx
	siq1KD++qDQntfgQow/QnxOZpUST84HJJa8k3tDYxMzI0sjMwsjE3ByHsJI4L+OpJwFCAumJ
	JanZqakFqUUw45g4OKUaGBM+6bas+bu423Trno27P0X9P1G4+KbOpcyreknvQj2X1lQWbGK4
	867PTP2C3rvJf4te7vDe6ubOJlWx76/Rg+5TB79tkdUTc9v8LlOr4qFQ1nGXPfoKHn2Tcoss
	e6ebC1SsEmEw8A6Km3/q5/+5KWvNLtccfyv+p3aPcewqX/+alCk3D+hyGimxFGckGmoxFxUn
	AgBmd2/FDQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'Joerg Roedel' wrote:
> 
> On Mon, Dec 31, 2012 at 10:18:46AM -0800, Kukjin Kim wrote:
> > Cho KyongHo wrote:
> 
> > > Diffstats:
> > >  arch/arm/boot/dts/exynos5250-smdk5250.dts  |    2 +-
> > >  arch/arm/boot/dts/exynos5250.dtsi          |   27 +-
> > >  arch/arm/mach-exynos/Kconfig               |    5 -
> > >  arch/arm/mach-exynos/Makefile              |    1 -
> > >  arch/arm/mach-exynos/clock-exynos4.c       |   41 +-
> > >  arch/arm/mach-exynos/clock-exynos4210.c    |    9 +-
> > >  arch/arm/mach-exynos/clock-exynos4212.c    |   23 +-
> > >  arch/arm/mach-exynos/clock-exynos5.c       |   87 +-
> > >  arch/arm/mach-exynos/dev-sysmmu.c          |  274 ------
> > >  arch/arm/mach-exynos/include/mach/sysmmu.h |   66 --
> > >  arch/arm/mach-exynos/mach-exynos4-dt.c     |   34 +
> > >  arch/arm/mach-exynos/mach-exynos5-dt.c     |   30 +
> > >  drivers/iommu/Kconfig                      |    2 +-
> > >  drivers/iommu/Makefile                     |    2 +-
> > >  drivers/iommu/exynos-iommu.c               | 1477
> +++++++++++++++++++++--
> > > -----
> > >  15 files changed, 1284 insertions(+), 796 deletions(-)
> >
> > Joerg, it's time to merge this. If you don't mind, let me pick up this
whole
> > series into Samsung tree because this touches many Samsung stuff.
> 
> Well, looking at the diffstat the IOMMU changes are a lot larger than
> the exynos ones. So I think this should go through the IOMMU tree once
> the latest review comments are fixed.
> 
If so, too many ugly merge conflicts will be happened when Linus merges for
v3.9 because the legacy(current) exynos clock stuff is going away in Samsung
tree and as I said, this touches Samsung stuff widely. Of course, Stephen
should complain the conflicts between your tree and mine once you apply this
whole series in your -next before Linus' merge for v3.9. I believe, you
don't want it.

You know, we have several options to avoid it. When you take this series in
your tree, you can provide topic branch for me. Or this series should be
separated for arch/arm/ and drivers/ for both trees, then only drivers/iommu
changes should be picked up in your tree. I'm OK both, let me know which one
you would prefer or other way.

BTW, KyongHo, you need to update the clock changes for exynos-iommu against
on exynos common clock stuff. 

Thanks.

- Kukjin 

