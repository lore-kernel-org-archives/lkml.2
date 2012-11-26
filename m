Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2KZByb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:54:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11777 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab2KZBy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:54:29 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-17-50b2cbcad63f
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
References: <002101cdc8a4$fc375990$f4a60cb0$%cho@samsung.com>
 <112e01cdc951$976699b0$c633cd10$%kim@samsung.com>
In-reply-to: 
Subject: RE: [PATCH v4 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Mon, 26 Nov 2012 10:54:17 +0900
Message-id: <001b01cdcb78$f2079670$d616c350$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpPvetdNb3LV1RpCMPgotQ+4VCAAqXvJAAImPLkAAAPnVIA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zQ91TpzcFGOy9LW1xedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJUx5+Zd1oJbmhUrls9mbWD8JdfFyMkhIWAi0Xq1iRXC
	FpO4cG89WxcjF4eQwDJGiXOPdrHDFDW0HWOFSCxilNhz7heU849RYvmHH2BVbAJaEqvnHmcE
	SYgI3GeUeHt8OxOIwyxwgVHieOtENpAqIYFCiddnZrGA2JwCPBLr/nQyg9jCAokSz37uBzuE
	RUBV4uqRBrCpvAK2EvcfTmWFsAUlfky+B9bLDLRt/c7jTBC2vMTmNW+B5nAA3aou8eivLkhY
	RMBJ4u6bbYwQJSIS+168Y4QYLyDxbfIhFohyWYlNB5hBzpQQ2MQuMXv/RBaIlyUlDq64wTKB
	UWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIiTSpHYwrGywO
	MQpwMCrx8Bae2BQgxJpYVlyZe4hRgoNZSYR3IhNQiDclsbIqtSg/vqg0J7X4EKMP0OUTmaVE
	k/OBSSCvJN7Q2NjEzMTUxNzS1NwUh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsbUwFw5
	l4R5TdMuLsrZ/ZAhZP+aT6WKcVfTD4SW3JcPiWGZolVVGO3YfPxsoDjT1K0HGbZGJkXwW3QZ
	BvQprj0dGFLYL6m/e1vahNo1upm6BT77MqxYQ1M0zX24Jlqc3PaD90XSkxX6OqvaFmh5HA/Y
	uPdICMPhDKkddg+LNN5d2WxX3hXBq8RSnJFoqMVcVJwIADzbj8nhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd1TpzcFGNx+I2RxedccNosZ5/cx
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMefmXdaCW5oV
	K5bPZm1g/CXXxcjJISFgItHQdowVwhaTuHBvPVsXIxeHkMAiRok9536xQjj/GCWWf/jBDlLF
	JqAlsXrucUaQhIjAfUaJt8e3M4E4zAIXGCWOt05kA6kSEiiUeH1mFguIzSnAI7HuTycziC0s
	kCjx7Od+sH0sAqoSV480gE3lFbCVuP9wKiuELSjxY/I9sF5moG3rdx5ngrDlJTaveQs0hwPo
	VnWJR391QcIiAk4Sd99sY4QoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iREcx8+kdjCubLA4xCjAwajEw1t4YlOAEGtiWXFl7iFGCQ5mJRHe
	iUxAId6UxMqq1KL8+KLSnNTiQ4w+QI9OZJYSTc4Hppi8knhDYxMzI0sjMwsjE3NzHMJK4rzN
	HikBQgLpiSWp2ampBalFMOOYODilGhjV6ksUp+6+/D5wA9M+fr+2Zx3TOWa/+fW0+J/V7jkv
	KmZs6Iza5JoS2d6/r7KLec3ZSMn/EoH3WEpy2Pb5/65RNEqp3yP8NPz3nQNz18h2f/uzeubB
	qZy3G3RZbwe5TbCYbvHpQGjsedOgM0rPOy9XzvAtvJnWoLkhNixPNP/OtkUvjp29o3ReiaU4
	I9FQi7moOBEA9COlOxADAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Cho KyongHo [mailto:pullip.cho@samsung.com]
> Sent: Monday, November 26, 2012 10:28 AM
> 
> > -----Original Message-----
> > From: Kukjin Kim [mailto:kgene.kim@samsung.com]
> > Sent: Friday, November 23, 2012 5:08 PM
> > Subject: RE: [PATCH v4 00/12] iommu/exynos: Fixes and Enhancements of System MMU driver with DT
> >
> > Cho KyongHo wrote:
> > >
> > > The current exynos-iommu(System MMU) driver does not work autonomously
> > > since it is lack of support for power management of peripheral blocks.
> > > For example, MFC device driver must ensure that its System MMU is disabled
> > > before MFC block is power-down not to invalidate IOTLB in the System MMU
> > > when I/O memory mapping is changed. Because A System MMU is resides in the
> > > same H/W block, access to control registers of System MMU while the H/W
> > > block is turned off must be prohibited.
> > >
> > > This set of changes solves the above problem with setting each System MMUs
> > > as the parent of the device which owns the System MMU to recieve the
> > > information when the device is turned off or turned on.
> > >
> > > Another big change to the driver is the support for devicetree.
> > > The bindings for System MMU is described in
> > > Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
> > >
> > > In addition, this patchset also includes several bug fixes and
> > > enhancements
> > > of the current driver.
> > >
> > > Change log:
> > > v4:
> > > - Remove Change-Id from v3 patches
> > > - Change the order of the third and the first patch
> > >   Thanks to Kukjin Kim.
> > > - Fix memory leak when allocating and assigning exynos_iommu_owner to
> > > client
> > >   device if the client device has multiple System MMUs.
> > >   Thanks to Rahul Sharma.
> > >
> > > v3:
> > > - Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
> > > - Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
> > >   Thanks to Prathyush.
> > >
> > > v2:
> > > - Split the patch to iommu/exynos into 9 patches
> > > - Support for System MMU 3.3
> > > - Some code compaction
> > >
> > > Patch summary:
> > > [PATCH v4 01/12] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
> > > [PATCH v4 02/12] ARM: EXYNOS: add System MMU definition to DT
> > > [PATCH v4 03/12] ARM: EXYNOS: remove system mmu initialization from exynos
> > > tree
> > > [PATCH v4 04/12] iommu/exynos: support for device tree
> > > [PATCH v4 05/12] iommu/exynos: pass version information from DT
> > > [PATCH v4 06/12] iommu/exynos: allocate lv2 page table from own slab
> > > [PATCH v4 07/12] iommu/exynos: change rwlock to spinlock
> > > [PATCH v4 08/12] iommu/exynos: set System MMU as the parent of client
> > > device
> > > [PATCH v4 09/12] iommu/exynos: add support for runtime pm and
> > > suspend/resume
> > > [PATCH v4 10/12] iommu/exynos: add support for System MMU 3.2 and 3.3
> > > [PATCH v4 11/12] iommu/exynos: add literal name of System MMU for
> > > debugging
> > > [PATCH v4 12/12] iommu/exynos: add debugfs entries for System MMU
> > >
> > > Diffstats:
> > >  .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++
> > >  arch/arm/boot/dts/exynos4210.dtsi                  |   96 ++
> > >  arch/arm/boot/dts/exynos4x12.dtsi                  |  124 ++
> > >  arch/arm/boot/dts/exynos5250.dtsi                  |  147 +-
> > >  arch/arm/mach-exynos/Kconfig                       |    5 -
> > >  arch/arm/mach-exynos/Makefile                      |    1 -
> > >  arch/arm/mach-exynos/clock-exynos4.c               |   41 +-
> > >  arch/arm/mach-exynos/clock-exynos4210.c            |    9 +-
> > >  arch/arm/mach-exynos/clock-exynos4212.c            |   23 +-
> > >  arch/arm/mach-exynos/clock-exynos5.c               |   86 +-
> > >  arch/arm/mach-exynos/dev-sysmmu.c                  |  274 ----
> > >  arch/arm/mach-exynos/include/mach/sysmmu.h         |   66 -
> > >  arch/arm/mach-exynos/mach-exynos4-dt.c             |   34 +
> > >  arch/arm/mach-exynos/mach-exynos5-dt.c             |   30 +
> > >  drivers/iommu/Kconfig                              |    2 +-
> > >  drivers/iommu/exynos-iommu.c                       | 1428
> > +++++++++++++++-----
> > >  16 files changed, 1720 insertions(+), 732 deletions(-)
> >
> > Looks good to me 1st~3rd patches. After quick review, I think, 1st and 2nd
> > patches can go to upstream for v3.8 without any dependency. So I will.
> >
> > The 3rd patch has a dependency with other driver changes (4th ~ 12th), so it
> > should be sent to upstream with others.
> >
> > BTW since the 3rd patch touches many Samsung stuff in arch/arm/ so I'd
> > prefer to take it in Samsung tree. If Joerg is ok on iommu/exynos driver
> > changes for v3.8...
> >
> > Joerg, please let me know about iommu/exynos stuff so that I can decide to
> > take 3rd patch or not for v3.8.
> >
> 
> Hi, Kukjin Kim.
> 
> I found that control bit fields of clock gating of System MMU of MFC L/R is inversed.
> That is reported by Prathyush Kalashwaram.
> 
> I will post v5 patchset that solves this.
> 

I did not posted v5 patchset.
Instead, I posted just the fix for the 03/12 patch mentioned above
as the reply to the 03/12 patch.

Thank you.

Cho KyongHo.




