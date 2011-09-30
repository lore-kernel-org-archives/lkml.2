Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab1I3Nm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:42:56 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:11583
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295Ab1I3Nmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:42:55 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4R8275bh8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LSC8R6-02-3NE-02
X-M-MSG: 
Date: Fri, 30 Sep 2011 15:42:43 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Kukjin Kim <kgene.kim@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
        "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "younglak1004.kim@samsung.com" <younglak1004.kim@samsung.com>
Subject: Re: [PATCH v2 2/5] ARM: S5P: Remove system MMU driver from
 arm/plat-s5p
Message-ID: <20110930134243.GR2138@amd.com>
References: <016d01cc7f42$e58a0aa0$b09e1fe0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <016d01cc7f42$e58a0aa0$b09e1fe0$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 03:30:57AM -0400, Kukjin Kim wrote:
> From: KyongHo Cho <pullip.cho@samsung.com>
> 
> Due to Ohad Ben-Cohen gathered IOMMU drivers in drivers/iommu directory,
> System MMU driver is moved to drivers/iommu directory and removed
> from arch/arm/plat-s5p directory.
> 
> Please see
> https://lkml.org/lkml/2011/6/8/69
> 
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  arch/arm/plat-s5p/Kconfig               |    8 -
>  arch/arm/plat-s5p/Makefile              |    1 -
>  arch/arm/plat-s5p/include/plat/sysmmu.h |   95 ----------
>  arch/arm/plat-s5p/sysmmu.c              |  312 -------------------------------

You can use 'git mv' to just move the file. This ensures bisectability
of your patches. No need to delete the code in one patch and re-add it
in the next one (which breaks bisectability).

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

