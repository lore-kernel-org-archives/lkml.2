Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2KVTnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:43:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32573 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2KVTmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:42:52 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ad-50ae0d2f3a38
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v4 00/12] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Date: Thu, 22 Nov 2012 20:31:59 +0900
Message-id: <002101cdc8a4$fc375990$f4a60cb0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpPvetdNb3LV1RpCMPgotQ+4VCA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI1193nUBBn86jS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKuHTnOWLBYumL/LMUGxqciXYycHBICJhJrZr9jh7DF
	JC7cW8/WxcjFISSwjFFi9545jDBFZ9atYYRILGKUuHv9HjOE849RYu3bIywgVWwCWhKr5x4H
	qxIR6GWUuND/lQnEYRb4wSgxffMvoCoODmGBWInbv8JBGlgEVCWam5axgoR5BWwlDt/gBgnz
	CghK/Jh8D2wmM9DM9TuPM0HY8hKb17xlBimXEFCXePRXFyQsIqAn8bH1PFS5iMS+F+8YIaYL
	SHybfIgFolxWYtMBsJMlBCazS+zua4H6WFLi4IobLBMYxWYh2TwLyeZZSDbPQrJiASPLKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYyQmJHewbiqweIQowAHoxIPb4bB2gAh1sSy4srcQ4wS
	HMxKIrz3uNcFCPGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+MJ7zSuINjY1NzExMTcwtTc1N
	cQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamCcsf7OR2HTffemn1ixM2Ch07nWo5Ebri9g
	UHn5Ob+kfGlBsIFk1QwupfcVq9PrNj3TrXBat2SDnIuut8Gcq0w71LN/OfS47pj1OLHTv93H
	8ahP5T7muRJvb/B2rJXwXiduE7ek+x9z+TZX2XkFzQ+mmR636o1WOsehUV9U/yzM9vimWepc
	/5mUWIozEg21mIuKEwHy3AZRxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAV193nUBBsse6lpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXDtynLFgsXTF
	/lmKDYxPRboYOTkkBEwkzqxbwwhhi0lcuLeerYuRi0NIYBGjxN3r95ghnH+MEmvfHmEBqWIT
	0JJYPfc4I0hCRKCXUeJC/1cmEIdZ4AejxPTNv4CqODiEBWIlbv8KB2lgEVCVaG5axgoS5hWw
	lTh8gxskzCsgKPFj8j2wmcxAM9fvPM4EYctLbF7zlhmkXEJAXeLRX12QsIiAnsTH1vNQ5SIS
	+168Y5zAKDALyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/KZ
	9A7GVQ0WhxgFOBiVeHgzDNYGCLEmlhVX5h5ilOBgVhLhvce9LkCINyWxsiq1KD++qDQntfgQ
	ow/QnxOZpUST84HJIq8k3tDYxMzI0sjMwsjE3ByHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYO
	TqkGRteHPrl8IXJqXczuf2/fO+o2L26CSPsUv6WvXTMdrS+cklz5ZpUm/7ziKjmzyY+UfHin
	sTVdWXgxLVhhpkz52kXht65cyFnySbHLYd3ie3z8oX++mJR69ukH1iiIPdLpc3ZJfP2mar2W
	P0dqSYruU6teq2eLJ/J1q1St3R78gqNdu6/LccdyJZbijERDLeai4kQAciNcCfUCAAA=
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
[PATCH v4 01/12] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
[PATCH v4 02/12] ARM: EXYNOS: add System MMU definition to DT
[PATCH v4 03/12] ARM: EXYNOS: remove system mmu initialization from exynos tree
[PATCH v4 04/12] iommu/exynos: support for device tree
[PATCH v4 05/12] iommu/exynos: pass version information from DT
[PATCH v4 06/12] iommu/exynos: allocate lv2 page table from own slab
[PATCH v4 07/12] iommu/exynos: change rwlock to spinlock
[PATCH v4 08/12] iommu/exynos: set System MMU as the parent of client device
[PATCH v4 09/12] iommu/exynos: add support for runtime pm and suspend/resume
[PATCH v4 10/12] iommu/exynos: add support for System MMU 3.2 and 3.3
[PATCH v4 11/12] iommu/exynos: add literal name of System MMU for debugging
[PATCH v4 12/12] iommu/exynos: add debugfs entries for System MMU

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
 arch/arm/mach-exynos/clock-exynos5.c               |   86 +-
 arch/arm/mach-exynos/dev-sysmmu.c                  |  274 ----
 arch/arm/mach-exynos/include/mach/sysmmu.h         |   66 -
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   34 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |   30 +
 drivers/iommu/Kconfig                              |    2 +-
 drivers/iommu/exynos-iommu.c                       | 1428 +++++++++++++++-----
 16 files changed, 1720 insertions(+), 732 deletions(-)

