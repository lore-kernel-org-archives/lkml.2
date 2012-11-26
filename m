Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2KZB1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:27:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43781 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2KZB1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:27:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-56-50b2c58d0aa5
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
References: <002101cdc8a4$fc375990$f4a60cb0$%cho@samsung.com>
 <112e01cdc951$976699b0$c633cd10$%kim@samsung.com>
In-reply-to: <112e01cdc951$976699b0$c633cd10$%kim@samsung.com>
Subject: RE: [PATCH v4 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Mon, 26 Nov 2012 10:27:39 +0900
Message-id: <000001cdcb75$39d5d6a0$ad8183e0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpPvetdNb3LV1RpCMPgotQ+4VCAAqXvJAAImPLkA=
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA93eo5sCDHaf1bK4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpY+P4te8Ev1Yo/nX9YGxh3yXQxcnJICJhI7Gi+yQRh
	i0lcuLeeDcQWEljGKPHsjVYXIwdYzfmXal2MXEDhRYwSn04tY4Zw/jFKTHr9mxGkgU1AS2L1
	3OOMIAkRga2MEotWLmMDcZgFLjBKHG+dCDW2UOL1mVksIGM5Bewk9u7gBAkLCyRKPPu5nxXE
	ZhFQldi04xJYOa+ArcS/ufNYIWxBiR+T77GA2MxAy9bvPM4EYctLbF7zlhniUnWJR391QcIi
	AlYS+28fZYQoEZHY9+IdI8R4AYlvkw+xQJTLSmw6APaLhMAmdol975dDA0JS4uCKGywTGCVm
	Idk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MkBiT3sG4qsHiEKMA
	B6MSD69BysYAIdbEsuLK3EOMEhzMSiK8E5k2BQjxpiRWVqUW5ccXleakFh9i9AG6fCKzlGhy
	PjD+80riDY2NTcxMTE3MLU3NTXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgLN2Wrdrx
	06bWQ186/g5D/LurHc9Xme06863V1PzAK6XPE252+WXOlQxbV1/RUst2NJJtt7vLzae1X1Ri
	ZvKsjby8WfD1nRtei7NN7FkcPnUwPXm5yK7WIGX5rC3xrP1PUp3P5834cLFGd8Ohb1+2BNoc
	MXOfc8zCr3rr4xdVq+6EOr5/f9M3XImlOCPRUIu5qDgRACcrr4beAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd2eo5sCDHbcNLC4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWPj+LXvBL9WK
	P51/WBsYd8l0MXJwSAiYSJx/qdbFyAlkiklcuLeerYuRi0NIYBGjxKdTy5ghnH+MEpNe/2YE
	qWIT0JJYPfc4I0hCRGAro8SilcvAWpgFLjBKHG+dyAZSJSRQKPH6zCwWkBWcAnYSe3dwgoSF
	BRIlnv3czwpiswioSmzacQmsnFfAVuLf3HmsELagxI/J91hAbGagZet3HmeCsOUlNq95ywxx
	tbrEo7+6IGERASuJ/bePMkKUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5K
	zzXSK07MLS7NS9dLzs/dxAiO4WfSOxhXNVgcYhTgYFTi4TVI2RggxJpYVlyZe4hRgoNZSYR3
	ItOmACHelMTKqtSi/Pii0pzU4kOMPkCPTmSWEk3OB6aXvJJ4Q2MTMyNLIzMLIxNzcxzCSuK8
	zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYF/DHu53vjkuVNd0nYPfYyPLz3TCHFuOTLY3hu9YV
	bbx395Eq4wTW1Y/XC7fFzPTYY8+iZdBbPO2RWeCpLf8nKrroMinNk49691JdetY0yazz8V6x
	mytfxL/gOqu9tmnR6z3LoieaumX4tfExTbx22aVae0bMIrF0q47GwsIH++SfM3/8kvBSiaU4
	I9FQi7moOBEAYOxFxA4DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kukjin Kim [mailto:kgene.kim@samsung.com]
> Sent: Friday, November 23, 2012 5:08 PM
> Subject: RE: [PATCH v4 00/12] iommu/exynos: Fixes and Enhancements of System MMU driver with DT
> 
> Cho KyongHo wrote:
> >
> > The current exynos-iommu(System MMU) driver does not work autonomously
> > since it is lack of support for power management of peripheral blocks.
> > For example, MFC device driver must ensure that its System MMU is disabled
> > before MFC block is power-down not to invalidate IOTLB in the System MMU
> > when I/O memory mapping is changed. Because A System MMU is resides in the
> > same H/W block, access to control registers of System MMU while the H/W
> > block is turned off must be prohibited.
> >
> > This set of changes solves the above problem with setting each System MMUs
> > as the parent of the device which owns the System MMU to recieve the
> > information when the device is turned off or turned on.
> >
> > Another big change to the driver is the support for devicetree.
> > The bindings for System MMU is described in
> > Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
> >
> > In addition, this patchset also includes several bug fixes and
> > enhancements
> > of the current driver.
> >
> > Change log:
> > v4:
> > - Remove Change-Id from v3 patches
> > - Change the order of the third and the first patch
> >   Thanks to Kukjin Kim.
> > - Fix memory leak when allocating and assigning exynos_iommu_owner to
> > client
> >   device if the client device has multiple System MMUs.
> >   Thanks to Rahul Sharma.
> >
> > v3:
> > - Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
> > - Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
> >   Thanks to Prathyush.
> >
> > v2:
> > - Split the patch to iommu/exynos into 9 patches
> > - Support for System MMU 3.3
> > - Some code compaction
> >
> > Patch summary:
> > [PATCH v4 01/12] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
> > [PATCH v4 02/12] ARM: EXYNOS: add System MMU definition to DT
> > [PATCH v4 03/12] ARM: EXYNOS: remove system mmu initialization from exynos
> > tree
> > [PATCH v4 04/12] iommu/exynos: support for device tree
> > [PATCH v4 05/12] iommu/exynos: pass version information from DT
> > [PATCH v4 06/12] iommu/exynos: allocate lv2 page table from own slab
> > [PATCH v4 07/12] iommu/exynos: change rwlock to spinlock
> > [PATCH v4 08/12] iommu/exynos: set System MMU as the parent of client
> > device
> > [PATCH v4 09/12] iommu/exynos: add support for runtime pm and
> > suspend/resume
> > [PATCH v4 10/12] iommu/exynos: add support for System MMU 3.2 and 3.3
> > [PATCH v4 11/12] iommu/exynos: add literal name of System MMU for
> > debugging
> > [PATCH v4 12/12] iommu/exynos: add debugfs entries for System MMU
> >
> > Diffstats:
> >  .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   96 ++
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |  124 ++
> >  arch/arm/boot/dts/exynos5250.dtsi                  |  147 +-
> >  arch/arm/mach-exynos/Kconfig                       |    5 -
> >  arch/arm/mach-exynos/Makefile                      |    1 -
> >  arch/arm/mach-exynos/clock-exynos4.c               |   41 +-
> >  arch/arm/mach-exynos/clock-exynos4210.c            |    9 +-
> >  arch/arm/mach-exynos/clock-exynos4212.c            |   23 +-
> >  arch/arm/mach-exynos/clock-exynos5.c               |   86 +-
> >  arch/arm/mach-exynos/dev-sysmmu.c                  |  274 ----
> >  arch/arm/mach-exynos/include/mach/sysmmu.h         |   66 -
> >  arch/arm/mach-exynos/mach-exynos4-dt.c             |   34 +
> >  arch/arm/mach-exynos/mach-exynos5-dt.c             |   30 +
> >  drivers/iommu/Kconfig                              |    2 +-
> >  drivers/iommu/exynos-iommu.c                       | 1428
> +++++++++++++++-----
> >  16 files changed, 1720 insertions(+), 732 deletions(-)
> 
> Looks good to me 1st~3rd patches. After quick review, I think, 1st and 2nd
> patches can go to upstream for v3.8 without any dependency. So I will.
> 
> The 3rd patch has a dependency with other driver changes (4th ~ 12th), so it
> should be sent to upstream with others.
> 
> BTW since the 3rd patch touches many Samsung stuff in arch/arm/ so I'd
> prefer to take it in Samsung tree. If Joerg is ok on iommu/exynos driver
> changes for v3.8...
> 
> Joerg, please let me know about iommu/exynos stuff so that I can decide to
> take 3rd patch or not for v3.8.
> 

Hi, Kukjin Kim.

I found that control bit fields of clock gating of System MMU of MFC L/R is inversed.
That is reported by Prathyush Kalashwaram.

I will post v5 patchset that solves this.

Thank you.

Cho KyongHo.

