Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915Ab2KWIHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:07:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54295 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab2KWIHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:07:36 -0500
X-AuditID: cbfee61b-b7f616d00000319b-82-50af2ec559d3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
References: <002101cdc8a4$fc375990$f4a60cb0$%cho@samsung.com>
In-reply-to: <002101cdc8a4$fc375990$f4a60cb0$%cho@samsung.com>
Subject: RE: [PATCH v4 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Fri, 23 Nov 2012 17:07:33 +0900
Message-id: <112e01cdc951$976699b0$c633cd10$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpPvetdNb3LV1RpCMPgotQ+4VCAAqXvJA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zY92jeusDDPb0q1tc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX03u5jLJijVPHyilED42fJLkZODgkBE4l3p/ewQthi
	EhfurWfrYuTiEBJYxiixecU/Zpii15sfMEIkpjNKLHt+nQnC+csocWP+MTaQKjYBDYnD75+x
	gyREBLYzSnRMfQTWwixwgVHieOtEoCoOoBZbiYeLa0EaOAXsJHat/88IYgsLJEo8+7kf7A4W
	AVWJ12fXsoDYvEDlyxaugrIFJX5MvgdmMwtoSazfeZwJwpaX2LzmLTPIeAkBdYlHf3VBwiIC
	RhKNT66xQZSISOx78Y4RYryAxLfJh1ggymUlNh1gBrlSQmAdu8SKG1tZID6WlDi44gbLBEaJ
	WUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIyTKpHcwrmqwOMQo
	wMGoxMNrWLYuQIg1say4MvcQowQHs5IIL5PY+gAh3pTEyqrUovz4otKc1OJDjD5Al09klhJN
	zgcmgLySeENjYxMzE1MTc0tTc1McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGNM/L7wz
	xWd9y3+XE5w9zeq/RVXCFlttfP/a9bWyyqp/R62O3Q+8Mkmg+MDX/i4nxaLJvHEb4u4dbWyS
	fnxE49SDakX9C2XTBBLtZYS2LH319+83w4df/H63Gv1kjXFk1chamaIgz/VCvuzKLF/Bi/Yn
	wz56njh19+Xa8jVTeZVvZRQGHKgXFFRiKc5INNRiLipOBABurBdH3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd2jeusDDF5fV7S4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6L3dx1gwR6ni
	5RWjBsbPkl2MnBwSAiYSrzc/YISwxSQu3FvP1sXIxSEkMJ1RYtnz60wQzl9GiRvzj7GBVLEJ
	aEgcfv+MHSQhIrCdUaJj6iNGEIdZ4AKjxPHWiUBVHEAtthIPF9eCNHAK2EnsWv8fbIWwQKLE
	s5/7WUFsFgFViddn17KA2LxA5csWroKyBSV+TL4HZjMLaEms33mcCcKWl9i85i0zyHgJAXWJ
	R391QcIiAkYSjU+usUGUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAiO4WfSOxhXNVgcYhTgYFTi4TUsWxcgxJpYVlyZe4hRgoNZSYSXSWx9
	gBBvSmJlVWpRfnxRaU5q8SFGH6BHJzJLiSbnA9NLXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+U
	ACGB9MSS1OzU1ILUIphxTBycUg2M1s5fKisXeE4s5I9Vfbmlbq2JmGYv08x3DbylksfdDnI+
	VFi1UTbpWdrBy1t2KsSbzbv9KU2otjdp+X5fmeL5LfrcrlN/nraTUixV12n8ov4mqvXZopen
	18/4Vmf2U/v/lsXih/M+/xV6sdrW84zisvXxgtM3eT26/9dsL+uLzBXni90k9zn3KrEUZyQa
	ajEXFScCAPhdzJEOAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cho KyongHo wrote:
> 
> The current exynos-iommu(System MMU) driver does not work autonomously
> since it is lack of support for power management of peripheral blocks.
> For example, MFC device driver must ensure that its System MMU is disabled
> before MFC block is power-down not to invalidate IOTLB in the System MMU
> when I/O memory mapping is changed. Because A System MMU is resides in the
> same H/W block, access to control registers of System MMU while the H/W
> block is turned off must be prohibited.
> 
> This set of changes solves the above problem with setting each System MMUs
> as the parent of the device which owns the System MMU to recieve the
> information when the device is turned off or turned on.
> 
> Another big change to the driver is the support for devicetree.
> The bindings for System MMU is described in
> Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
> 
> In addition, this patchset also includes several bug fixes and
> enhancements
> of the current driver.
> 
> Change log:
> v4:
> - Remove Change-Id from v3 patches
> - Change the order of the third and the first patch
>   Thanks to Kukjin Kim.
> - Fix memory leak when allocating and assigning exynos_iommu_owner to
> client
>   device if the client device has multiple System MMUs.
>   Thanks to Rahul Sharma.
> 
> v3:
> - Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
> - Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
>   Thanks to Prathyush.
> 
> v2:
> - Split the patch to iommu/exynos into 9 patches
> - Support for System MMU 3.3
> - Some code compaction
> 
> Patch summary:
> [PATCH v4 01/12] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
> [PATCH v4 02/12] ARM: EXYNOS: add System MMU definition to DT
> [PATCH v4 03/12] ARM: EXYNOS: remove system mmu initialization from exynos
> tree
> [PATCH v4 04/12] iommu/exynos: support for device tree
> [PATCH v4 05/12] iommu/exynos: pass version information from DT
> [PATCH v4 06/12] iommu/exynos: allocate lv2 page table from own slab
> [PATCH v4 07/12] iommu/exynos: change rwlock to spinlock
> [PATCH v4 08/12] iommu/exynos: set System MMU as the parent of client
> device
> [PATCH v4 09/12] iommu/exynos: add support for runtime pm and
> suspend/resume
> [PATCH v4 10/12] iommu/exynos: add support for System MMU 3.2 and 3.3
> [PATCH v4 11/12] iommu/exynos: add literal name of System MMU for
> debugging
> [PATCH v4 12/12] iommu/exynos: add debugfs entries for System MMU
> 
> Diffstats:
>  .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   96 ++
>  arch/arm/boot/dts/exynos4x12.dtsi                  |  124 ++
>  arch/arm/boot/dts/exynos5250.dtsi                  |  147 +-
>  arch/arm/mach-exynos/Kconfig                       |    5 -
>  arch/arm/mach-exynos/Makefile                      |    1 -
>  arch/arm/mach-exynos/clock-exynos4.c               |   41 +-
>  arch/arm/mach-exynos/clock-exynos4210.c            |    9 +-
>  arch/arm/mach-exynos/clock-exynos4212.c            |   23 +-
>  arch/arm/mach-exynos/clock-exynos5.c               |   86 +-
>  arch/arm/mach-exynos/dev-sysmmu.c                  |  274 ----
>  arch/arm/mach-exynos/include/mach/sysmmu.h         |   66 -
>  arch/arm/mach-exynos/mach-exynos4-dt.c             |   34 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c             |   30 +
>  drivers/iommu/Kconfig                              |    2 +-
>  drivers/iommu/exynos-iommu.c                       | 1428
+++++++++++++++-----
>  16 files changed, 1720 insertions(+), 732 deletions(-)

Looks good to me 1st~3rd patches. After quick review, I think, 1st and 2nd
patches can go to upstream for v3.8 without any dependency. So I will.

The 3rd patch has a dependency with other driver changes (4th ~ 12th), so it
should be sent to upstream with others.

BTW since the 3rd patch touches many Samsung stuff in arch/arm/ so I'd
prefer to take it in Samsung tree. If Joerg is ok on iommu/exynos driver
changes for v3.8...

Joerg, please let me know about iommu/exynos stuff so that I can decide to
take 3rd patch or not for v3.8.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

