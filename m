Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2LKLHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:07:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36084 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2LKLHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:07:31 -0500
X-AuditID: cbfee61b-b7f616d00000319b-fe-50c713dd07a5
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Dae Inki'" <inki.dae@samsung.com>, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahun Sharma'" <rahul.sharma@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'SWKim'" <sw0312.kim@samsung.com>
Subject: [PATCH v5 00/12] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Date: Tue, 11 Dec 2012 20:07:09 +0900
Message-id: <003001cdd78f$a9bb1e00$fd315a00$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjGdkxrhShmYSQbCRV37Bf48w6wAAypMA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zfd27wscDDHp+SFpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX0fbrDVrBRvmL77t1sDYyvxLsYOTgkBEwkZq6U6WLk
	BDLFJC7cW88GYgsJLGOU2HBeFyJuIvGo/w9QnAsovohRYlHPPyYI5x+jRO+lx6wgVWwCWhKr
	5x5nBLFFBO4ySrw8zwNSxCxwhEli5/1zLCAJYYFYicefj4GtYBFQlXjV0A0W5xWwlVje/okV
	whaU+DH5HlicGWjo+p3HmSBseYnNa94yQ1ytLvHory7ELiOJX2f72CFKRCT2vXjHCDFeQOLb
	5EMsEOWyEpsOMIOcIyHQzy6x6cMaRojPJCUOrrjBMoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiJGekdjKsaLA4xCnAwKvHwamgdCxBiTSwrrsw9xCjB
	wawkwhspdDxAiDclsbIqtSg/vqg0J7X4EKMP0OUTmaVEk/OB8ZxXEm9obGxiZmJqYm5pam6K
	Q1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA2PA5Y2NZnft7jN/ndvf7Nf40KLb5RuzmsPD
	YvnYUt0z92tez70RPSHTKej7w2PpRVvsv+65smvRxJNGEtGPGcUC96VqFL0ub57kGznrkfV2
	hdsTI9o2W5beOXzlSenhls0vD9zav8jzJc+ytATTrBdlK+656vixdEx0f3skbeGXb6VrN2k9
	+m+jxFKckWioxVxUnAgAR/ATrsYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd27wscDDO71i1hc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm9H26w1awUb5i
	++7dbA2Mr8S7GDk5JARMJB71/2GDsMUkLtxbD2RzcQgJLGKUWNTzjwnC+cco0XvpMStIFZuA
	lsTquccZQWwRgbuMEi/P84AUMQscYZLYef8cC0hCWCBW4vHnY2BjWQRUJV41dIPFeQVsJZa3
	f2KFsAUlfky+BxZnBhq6fudxJghbXmLzmrfMXYwcQCepSzz6qwuxy0ji19k+dogSEYl9L94x
	TmAUmIVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFR+Ux6B+Oq
	BotDjAIcjEo8vBpaxwKEWBPLiitzDzFKcDArifBGCh0PEOJNSaysSi3Kjy8qzUktPsToA/To
	RGYp0eR8YMLIK4k3NDYxM7I0MrMwMjE3xyGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoFR
	b4ZQ+SbFTYdCnsw4Kntpz6mXj2T2n/X9/dp79y4LzrzH0l99+rgcZ5jMW2qpuyfSW9OptIM7
	XyLWJ7PM6q2djnS4vMR+d/dfy80kdTTipgQ53ZrM+Ir3G9duB4PDqqZlS3+2L7O+VMpUuyto
	+zT/jUItbG8f/HpwOCT+7KvbU95vjl4c0MqsxFKckWioxVxUnAgAMIV+9fcCAAA=
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
as the parent of the device which owns the System MMU to receive the
information when the device is turned off or turned on.

Another big change to the driver is the support for devicetree.
The bindings for System MMU is described in
Documentation/devicetree/bindings/arm/samsung/system-mmu.txt

In addition, this patchset also includes several bug fixes and enhancements
of the current driver.

Change log:
v5:
- new bugfix: patch 01
- Reordered patches
  * patch 01 ~ 05: Bugfix and enhancements of the existing driver
  * patch 06 ~ 10: Device Tree support and callbacks for power management
  * patch 11     : System MMU 3.2 and 3.3 support
  * patch 12 ~ 14: Debugging features
- Additional code compaction

v4:
- Remove Change-Id from v3 patches
- Change the order of the third and the first patch
  Thanks to Kukjin Kim.
- Fix memory leak when allocating and assigning exynos_iommu_owner to client
  device if the client device has multiple System MMUs.
  Thanks to Rahul Sharma.

v3:
- Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
- Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
  Thanks to Prathyush.

v2:
- Split the patch to iommu/exynos into 9 patches
- Support for System MMU 3.3
- Some code compaction

Patch summary:
[PATCH v5 01/14] iommu/exynos: add missing cache flush for removed pagetable entries
[PATCH v5 02/14] iommu/exynos: always use iommu fault handler
[PATCH v5 03/14] iommu/exynos: allocate lv2 page table from own slab
[PATCH v5 04/14] iommu/exynos: change rwlock to spinlock
[PATCH v5 05/14] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
[PATCH v5 06/14] ARM: EXYNOS: add System MMU definition to DT
[PATCH v5 07/14] iommu/exynos: support for device tree
[PATCH v5 08/14] iommu/exynos: set System MMU as the parent of client device
[PATCH v5 09/14] ARM: EXYNOS: remove system mmu initialization from exynos tree
[PATCH v5 10/14] iommu/exynos: add support for runtime pm and suspend/resume
[PATCH v5 11/14] iommu/exynos: add support for System MMU 3.2 and 3.3
[PATCH v5 12/14] iommu/exynos: pass version information from DT
[PATCH v5 13/14] iommu/exynos: add literal name of System MMU for debugging
[PATCH v5 14/14] iommu/exynos: add debugfs entries for System MMU

Diffstats:
 .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++
 arch/arm/boot/dts/exynos4210.dtsi                  |   96 ++
 arch/arm/boot/dts/exynos4x12.dtsi                  |  124 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |  154 +-
 arch/arm/mach-exynos/Kconfig                       |    5 -
 arch/arm/mach-exynos/Makefile                      |    1 -
 arch/arm/mach-exynos/clock-exynos4.c               |   41 +-
 arch/arm/mach-exynos/clock-exynos4210.c            |    9 +-
 arch/arm/mach-exynos/clock-exynos4212.c            |   23 +-
 arch/arm/mach-exynos/clock-exynos5.c               |   86 +-
 arch/arm/mach-exynos/dev-sysmmu.c                  |  274 ----
 arch/arm/mach-exynos/include/mach/sysmmu.h         |   66 -
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   34 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   30 +
 drivers/iommu/Kconfig                              |    2 +-
 drivers/iommu/Makefile                             |    2 +-
 drivers/iommu/exynos-iommu.c                       | 1477 +++++++++++++++-----
 17 files changed, 1745 insertions(+), 765 deletions(-)

