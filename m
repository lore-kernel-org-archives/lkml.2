Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3AJSfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:35:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11887 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3AJSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:35:05 -0500
X-AuditID: cbfee61b-b7f616d00000319b-78-50ef09d7e69a
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
In-reply-to: 
Subject: RE: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Thu, 10 Jan 2013 10:34:48 -0800
Message-id: <027601cdef61$2df576a0$89e063e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFIekVXHKw0ow7bnqULS98EzrZJiAHrktOYAWxAehSZMvzAIIAADtPA
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfd3rnO8DDDruyVlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUc3FtZ8Ea84tS16gbGR4JdjJwcEgImEhP6drJD2GIS
	F+6tZ+ti5OIQEljGKDHv4VN2mKKd376xQiSmM0pMudzCBOH8ZZQ4uvc1G0gVm4CGxOH3z8A6
	RARUJFrO/WAGsZkFdjFLTD0nAdEwiVFi0qStLCAJTgEeiXV/OsGKhAUSJVZf2MkEYrMIqEo8
	X/MLqIaDg1fAUuLUKRuQMK+AoMSPyfdYIGZqSazfeZwJwpaX2LzmLTPEpQoSO86+ZoS4wU3i
	5b2lUPXiEpMePGSHGC8g8W3yIbDxEgKyEpsOMIOcJiGwil1iavdyJog5khIHV9xgmcAoMQvJ
	6llIVs9CsnoWkhULGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoTEmPQOxlUNFocYBTgY
	lXh4tXzfBQixJpYVV+YeYpTgYFYS4W1ZABTiTUmsrEotyo8vKs1JLT7E6AN0+URmKdHkfGD8
	55XEGxobm5iZmJqYW5qam+IQVhLnZTz1JEBIID2xJDU7NbUgtQhmHBMHp1QDI9eqjXOcVme8
	Ul+kx/iY56nE5v3cp5znJZkI/5qe0R7c+uOr3p/f7fp9+3fKcb/4HNZ89vW2KytEIwM+yH/j
	ap3GyPM60q5eb9qj+FVW1msTz6cZ68lzWFz8Vc53M+GGtIrKO6uj03Ou2TK/DX1l/FmkkOVl
	XmHU3Ofz73Dq7Q+drvis9sOPcCWW4oxEQy3mouJEANLoCx/eAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd3rnO8DDP6vkrK4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOLi3suCNeMWp
	a9UNjI8Euxg5OSQETCR2fvvGCmGLSVy4t56ti5GLQ0hgOqPElMstTBDOX0aJo3tfs4FUsQlo
	SBx+/4wdxBYRUJFoOfeDGcRmFtjFLDH1nAREwyRGiUmTtrKAJDgFeCTW/ekEKxIWSJRYfWEn
	E4jNIqAq8XzNL6AaDg5eAUuJU6dsQMK8AoISPybfY4GYqSWxfudxJghbXmLzmrfMEJcqSOw4
	+5oR4gY3iZf3lkLVi0tMevCQfQKj0Cwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAiO4GfSOxhXNVgcYhTgYFTi4dXyfRcgxJpYVlyZe4hRgoNZSYS3ZQFQiDcl
	sbIqtSg/vqg0J7X4EKMP0KMTmaVEk/OBySWvJN7Q2MTMyNLIzMLIxNwch7CSOC/jqScBQgLp
	iSWp2ampBalFMOOYODilGhiF3J5fm71m06O7u6t+ZgWtPaRSw/+j4OTfi+1up1SOM3lXirY8
	O2Rqccgu4Mc88dSohXEyYVLXY1fdeiRyeU/iVoHL9y2fnTu/4IjsJxsPFu2H0eG8ryq2Sy6b
	MP2QyaKnXccXzBbWmdm4K+X9b203ma/dXzX2/DG8Ga9fwVS102Xegh/+QQ9fKbEUZyQaajEX
	FScCAG5RIpYNAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> 'Joerg Roedel' wrote:
> >
> > On Mon, Dec 31, 2012 at 10:18:46AM -0800, Kukjin Kim wrote:
> > > Cho KyongHo wrote:
> >
> > > > Diffstats:
> > > >  arch/arm/boot/dts/exynos5250-smdk5250.dts  |    2 +-
> > > >  arch/arm/boot/dts/exynos5250.dtsi          |   27 +-
> > > >  arch/arm/mach-exynos/Kconfig               |    5 -
> > > >  arch/arm/mach-exynos/Makefile              |    1 -
> > > >  arch/arm/mach-exynos/clock-exynos4.c       |   41 +-
> > > >  arch/arm/mach-exynos/clock-exynos4210.c    |    9 +-
> > > >  arch/arm/mach-exynos/clock-exynos4212.c    |   23 +-
> > > >  arch/arm/mach-exynos/clock-exynos5.c       |   87 +-
> > > >  arch/arm/mach-exynos/dev-sysmmu.c          |  274 ------
> > > >  arch/arm/mach-exynos/include/mach/sysmmu.h |   66 --
> > > >  arch/arm/mach-exynos/mach-exynos4-dt.c     |   34 +
> > > >  arch/arm/mach-exynos/mach-exynos5-dt.c     |   30 +
> > > >  drivers/iommu/Kconfig                      |    2 +-
> > > >  drivers/iommu/Makefile                     |    2 +-
> > > >  drivers/iommu/exynos-iommu.c               | 1477
> > +++++++++++++++++++++--
> > > > -----
> > > >  15 files changed, 1284 insertions(+), 796 deletions(-)
> > >
> > > Joerg, it's time to merge this. If you don't mind, let me pick up this
whole
> > > series into Samsung tree because this touches many Samsung stuff.
> >
> > Well, looking at the diffstat the IOMMU changes are a lot larger than
> > the exynos ones. So I think this should go through the IOMMU tree once
> > the latest review comments are fixed.
> >
> If so, too many ugly merge conflicts will be happened when Linus merges
for
> v3.9 because the legacy(current) exynos clock stuff is going away in
Samsung
> tree and as I said, this touches Samsung stuff widely. Of course, Stephen
> should complain the conflicts between your tree and mine once you apply
> this whole series in your -next before Linus' merge for v3.9. I believe,
you
> don't want it.
> 
> You know, we have several options to avoid it. When you take this series
in
> your tree, you can provide topic branch for me. Or this series should be
> separated for arch/arm/ and drivers/ for both trees, then only
> drivers/iommu changes should be picked up in your tree. I'm OK both, let
me
> know which one you would prefer or other way.
> 
Hmm, I think, just one [7/12] patch does matter so if you could create topic
branch and apply [7/12] patch firstly before other drivers/ changes would be
better to me. It's OK on both trees if I just _merge_ the first [7/12]
commit in the topic branch you provided for exynos-iommu. But you know, you
don't have to rebase it once I merge it in Samsung tree.

How about?

> BTW, KyongHo, you need to update the clock changes for exynos-iommu
> against on exynos common clock stuff.
> 
KyoungHo, your changes don't matter on exynos common clock stuff and I can
take care in my tree. So no need more work for it in your side. If any
updates, let you know.

Thanks.

- Kukjin

