Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab2LZBxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:53:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37760 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2LZBxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:53:18 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-ea-50da588c00a7
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
Subject: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Date: Wed, 26 Dec 2012 10:53:15 +0900
Message-id: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC8Uh9PE9rZayTGy3hSzhhjnFTA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zfd2eiFsBBtPWKFhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVsmvuEraBbvuL5mgcsDYzHJboYOTkkBEwkls+YzQRh
	i0lcuLeerYuRi0NIYBmjxPrtO1m6GDnAipYtU4CIL2KUmH1pMiuE849RonHtDbBuNgEtidVz
	jzOC2CICdxklXp7nASliFvjLKPHpzCF2kEnCArESmzuqQWpYBFQlfk3bxgwS5hWwlfjepwES
	5hUQlPgx+R4LiM0MNHL9zuNMELa8xOY1b5kh7lGXePRXF2KTnsSZSzdZIUpEJPa9eMcIMV1A
	4tvkQ1Dny0psOsAMcoyEwGR2iSVtm5gh/pWUOLjiBssERrFZSDbPQrJ5FpLNs5CsWMDIsopR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjJGKkdjCubLA4xCjAwajEw7vx+80AIdbEsuLK3EOM
	EhzMSiK8zh+BQrwpiZVVqUX58UWlOanFhxh9gC6fyCwlmpwPjOa8knhDY2MTMxNTE3NLU3NT
	HMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhi5t+9rzs1fYemgbrf0WOuF85pLLC++nRRx
	NELVyob7ruOU2Ls3Dt0zPlRnU3ek1OLYh3T+V1ZvuUyTjHT6HV6IT9m4s9q4ne1n5508zvlX
	Ks4kcOsvftxwPfdO910vTq7usnl2rzauSHx6uJbn54T+GL81Fp/NxD0tfdn1JVQuLuFpf/3o
	mKISS3FGoqEWc1FxIgAmG2LBxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd2eiFsBBq9uiltc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbJr7hK2gW77i
	+ZoHLA2MxyW6GDk4JARMJJYtU+hi5AQyxSQu3FvP1sXIxSEksIhRYvalyawQzj9Gica1N5hA
	qtgEtCRWzz3OCGKLCNxllHh5ngekiFngL6PEpzOH2EGmCgvESmzuqAapYRFQlfg1bRszSJhX
	wFbie58GSJhXQFDix+R7LCA2M9DI9TuPM0HY8hKb17xlhrhNXeLRX12ITXoSZy7dZIUoEZHY
	9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcj8+k
	djCubLA4xCjAwajEw7vx+80AIdbEsuLK3EOMEhzMSiK8zh+BQrwpiZVVqUX58UWlOanFhxh9
	gP6cyCwlmpwPTBV5JfGGxiZmRpZGZhZGJubmOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBK
	NTCWsOlqLp4a+k12jtrN3Eu3+v538LT9Prb6lW/u6mOrnp2YzTixeIXFwfsPzqUoXt9+9iiz
	yb1yhsmR57ZNWbJju65V4j058xJRvSSvnce+neJa28PD+OXbBydxqUmFXXnHDvz3jjH6dCJw
	Vd7krHMneU7k2wdd3X1mY8r/lZoi0i7ZmpkSUv8WKbEUZyQaajEXFScCAHweYIX0AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

notice: v6 patch-set is rebased on next/iommu-exynos branch of
linux-samsung.git.  This patch-set does not include 2 patches (05 and 06
patches in v5 patch-se) because they alread exist already in the branch.

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
v6:
- Rebased on the branch, next/iommu-exynos of
  git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git

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
[PATCH v6 01/12] iommu/exynos: add missing cache flush for removed pagetable entries
[PATCH v6 02/12] iommu/exynos: always use iommu fault handler
[PATCH v6 03/12] iommu/exynos: allocate lv2 page table from own slab
[PATCH v6 04/12] iommu/exynos: change rwlock to spinlock
[PATCH v6 05/12] iommu/exynos: support for device tree
[PATCH v6 06/12] iommu/exynos: set System MMU as the parent of client device
[PATCH v6 07/12] ARM: EXYNOS: remove system mmu initialization from exynos tree
[PATCH v6 08/12] iommu/exynos: add support for runtime pm and suspend/resume
[PATCH v6 09/12] iommu/exynos: add support for System MMU 3.2 and 3.3
[PATCH v6 10/12] iommu/exynos: pass version information from DT
[PATCH v6 11/12] iommu/exynos: add literal name of System MMU for debugging
[PATCH v6 12/12] iommu/exynos: add debugfs entries for System MMU

Diffstats:
 arch/arm/boot/dts/exynos5250-smdk5250.dts  |    2 +-
 arch/arm/boot/dts/exynos5250.dtsi          |   27 +-
 arch/arm/mach-exynos/Kconfig               |    5 -
 arch/arm/mach-exynos/Makefile              |    1 -
 arch/arm/mach-exynos/clock-exynos4.c       |   41 +-
 arch/arm/mach-exynos/clock-exynos4210.c    |    9 +-
 arch/arm/mach-exynos/clock-exynos4212.c    |   23 +-
 arch/arm/mach-exynos/clock-exynos5.c       |   87 +-
 arch/arm/mach-exynos/dev-sysmmu.c          |  274 ------
 arch/arm/mach-exynos/include/mach/sysmmu.h |   66 --
 arch/arm/mach-exynos/mach-exynos4-dt.c     |   34 +
 arch/arm/mach-exynos/mach-exynos5-dt.c     |   30 +
 drivers/iommu/Kconfig                      |    2 +-
 drivers/iommu/Makefile                     |    2 +-
 drivers/iommu/exynos-iommu.c               | 1477 +++++++++++++++++++++-------
 15 files changed, 1284 insertions(+), 796 deletions(-)

