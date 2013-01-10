Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3AJRTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:19:11 -0500
Received: from 8bytes.org ([85.214.48.195]:56102 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab3AJRTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:19:09 -0500
Date: Thu, 10 Jan 2013 18:19:05 +0100
From: "'Joerg Roedel'" <joro@8bytes.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
Subject: Re: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Message-ID: <20130110171844.GA2650@8bytes.org>
References: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
 <032401cde783$485ae1a0$d910a4e0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <032401cde783$485ae1a0$d910a4e0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jan 10 18:19:08 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50eef80c22979944120519
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 10:18:46AM -0800, Kukjin Kim wrote:
> Cho KyongHo wrote:

> > Diffstats:
> >  arch/arm/boot/dts/exynos5250-smdk5250.dts  |    2 +-
> >  arch/arm/boot/dts/exynos5250.dtsi          |   27 +-
> >  arch/arm/mach-exynos/Kconfig               |    5 -
> >  arch/arm/mach-exynos/Makefile              |    1 -
> >  arch/arm/mach-exynos/clock-exynos4.c       |   41 +-
> >  arch/arm/mach-exynos/clock-exynos4210.c    |    9 +-
> >  arch/arm/mach-exynos/clock-exynos4212.c    |   23 +-
> >  arch/arm/mach-exynos/clock-exynos5.c       |   87 +-
> >  arch/arm/mach-exynos/dev-sysmmu.c          |  274 ------
> >  arch/arm/mach-exynos/include/mach/sysmmu.h |   66 --
> >  arch/arm/mach-exynos/mach-exynos4-dt.c     |   34 +
> >  arch/arm/mach-exynos/mach-exynos5-dt.c     |   30 +
> >  drivers/iommu/Kconfig                      |    2 +-
> >  drivers/iommu/Makefile                     |    2 +-
> >  drivers/iommu/exynos-iommu.c               | 1477 +++++++++++++++++++++--
> > -----
> >  15 files changed, 1284 insertions(+), 796 deletions(-)
> 
> Joerg, it's time to merge this. If you don't mind, let me pick up this whole
> series into Samsung tree because this touches many Samsung stuff.

Well, looking at the diffstat the IOMMU changes are a lot larger than
the exynos ones. So I think this should go through the IOMMU tree once
the latest review comments are fixed.

> Happy new year, thanks.

Happy new year too,

      Joerg


