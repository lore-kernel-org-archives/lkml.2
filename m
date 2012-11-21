Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab2KUFCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:02:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63730 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2KUFCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:02:37 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c9-50ac60620a74
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 00/12] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Date: Wed, 21 Nov 2012 14:02:25 +0900
Message-id: <002601cdc7a5$66216bd0$32644370$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HpWWbwvgn5uTVQPmVAUsNj8vC3Q==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zA92khDUBBjtaxC0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLOvv7BWNAtWXG7YwZ7A2O7cBcjJ4eEgIlEa8MHNghb
	TOLCvfVANheHkMAyRolr976wdzFygBXtaI+DiE9nlNhwdQUTSIOQwD9GiTcNxSA2m4CWxOq5
	xxlBikQEehklLvR/ZQJxmAV+MEpM3/yLBWSSsECsxOyrviANLAKqEvfPT2cHsXkFbCWe7djI
	BGELSvyYfI8FxGYGGrp+53EmCFteYvOat8wQB6lLPPqrCxIWEdCT6P/UzAhRIiKx78U7Rojx
	AhLfJh9igSiXldh0gBnkGgmB6ewSzctXQj0sKXFwxQ2WCYxis5BsnoVk8ywkm2chWbGAkWUV
	o2hqQXJBcVJ6rqFecWJucWleul5yfu4mRkjMSO1gXNlgcYhRgINRiYd349rVAUKsiWXFlbmH
	GCU4mJVEeBnk1wQI8aYkVlalFuXHF5XmpBYfYvQBunwis5Rocj4wnvNK4g2NjU3MTExNzC1N
	zU1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYKzryXYzKdl4S7N+2vJ5AhWdjQJi7E8u
	FJxKnnv1XeN75UdLXtha15Wtn7HY6lZ+zqklp/ZqyEeWLzu3/pXBx9/mZazB+Y/077X5eJ+P
	vjnpYNP14966n29tEM9n3hf/VplZ1G8x2/v11XYTEry5zm1ftfJo9L3bhodc/967YCJ04vKX
	tuXv/ASVWIozEg21mIuKEwFGlntFxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQd2khDUBBq+nClhc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmnH39g7GgW7Li
	dscM9gbGduEuRg4OCQETiR3tcV2MnECmmMSFe+vZuhi5OIQEpjNKbLi6ggkkISTwj1HiTUMx
	iM0moCWxeu5xRpAiEYFeRokL/V+ZQBxmgR+MEtM3/2IBmSosECsx+6ovSAOLgKrE/fPT2UFs
	XgFbiWc7NjJB2IISPybfYwGxmYGGrt95nAnClpfYvOYtM8Rx6hKP/uqChEUE9CT6PzUzQpSI
	SOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7I
	Z1I7GFc2WBxiFOBgVOLh3bh2dYAQa2JZcWXuIUYJDmYlEV4G+TUBQrwpiZVVqUX58UWlOanF
	hxh9gB6dyCwlmpwPTBZ5JfGGxiZmRpZGZhZGJubmOISVxHmbPVIChATSE0tSs1NTC1KLYMYx
	cXBKNTBKN+ioZzlzGVU+WBGqovqdbba4ceuEiYemHrfzPfzNw7yvYwOHiJv6+4SfCT3NB7g7
	rRkXFb2bOGlH/q6psRy7Gu8s3RF0aqa9V2jQTbVJ3zjzBBp8/1dsKCu+VPrv6XzDaZt65s7u
	XGv9XOzX0t/Pd+t/vbXz+5a1cSK+l7Wbe9fMFzFdOLlLiaU4I9FQi7moOBEAkMSAXvUCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current exynos-iommu(System MMU) driver does not work autonomously
since it is lack of support for power management of peripheral blocks.
For example, MFC device driver must ensure that its System MMU is disabled
before MFC block is power-down not to invalidate IOTLB in the System MMU
when I/O memory mapping is changed. Because A System MMU is resides in the
same H/W block, access to control registers of System MMU while the H/W
block is turned off must be prohibited.

This set of changes solves the above problem with setting each System MMUs
as the parent of the device which owns the System MMU to recieve the
information when the device is turned off or turned on.

Another big change to the driver is the support for devicetree.
The bindings for System MMU is described in
Documentation/devicetree/bindings/arm/samsung/system-mmu.txt

In addition, this patchset also includes several bug fixes and enhancements
of the current driver.

Change log:
v2:
- Split the patch to iommu/exynos into 9 patches
- Support for System MMU 3.3
- Some code compaction

v3:
- Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
- Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
   Thanks to Prathyush.

Patch summary:
[PATCH v3 01/12] ARM: EXYNOS: remove system mmu initialization from exynos tree
[PATCH v3 02/12] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
[PATCH v3 03/12] ARM: EXYNOS: add System MMU definition to DT
[PATCH v3 04/12] iommu/exynos: support for device tree
[PATCH v3 05/12] iommu/exynos: pass version information from DT
[PATCH v3 06/12] iommu/exynos: allocate lv2 page table from own slab
[PATCH v3 07/12] iommu/exynos: change rwlock to spinlock
[PATCH v3 08/12] iommu/exynos: set System MMU as the parent of client device
[PATCH v3 09/12] iommu/exynos: add supoort for runtime pm and suspend/resume
[PATCH v3 10/12] iommu/exynos: add support for System MMU 3.2 and 3.3
[PATCH v3 11/12] iommu/exynos: add literal name of System MMU for debugging
[PATCH v3 12/12] iommu/exynos: add debugfs entries for System MMU


Diffstats:
 .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++
 arch/arm/boot/dts/exynos4210.dtsi                  |   96 ++
 arch/arm/boot/dts/exynos4x12.dtsi                  |  124 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |  147 +-
 arch/arm/mach-exynos/Kconfig                       |    5 -
 arch/arm/mach-exynos/Makefile                      |    1 -
 arch/arm/mach-exynos/clock-exynos4.c               |   41 +-
 arch/arm/mach-exynos/clock-exynos4210.c            |    9 +-
 arch/arm/mach-exynos/clock-exynos4212.c            |   23 +-
 arch/arm/mach-exynos/clock-exynos5.c               |   87 +-
 arch/arm/mach-exynos/dev-sysmmu.c                  |  274 ----
 arch/arm/mach-exynos/include/mach/sysmmu.h         |   66 -
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   34 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   30 +
 drivers/iommu/Kconfig                              |    2 +-
 drivers/iommu/exynos-iommu.c                       | 1424 +++++++++++++++-----
 16 files changed, 1718 insertions(+), 731 deletions(-)

