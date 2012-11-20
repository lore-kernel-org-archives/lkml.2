Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2KTH3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:29:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13330 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2KTH3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:29:47 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d3-50ab3169ebf8
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v2 0/12] iommu/exynos: Fixes and Enhancements of System MMU
 driver with DT
Date: Tue, 20 Nov 2012 16:29:45 +0900
Message-id: <001a01cdc6f0$d06c1f90$71445eb0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3G8NAUltP+cideQPyg9y1AZXWxmw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zI91Mw9UBBt+vaFtc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV8vzWbveCZeMW/7kfMDYytQl2MnBwSAiYSv5f8Z4Ow
	xSQu3FsPZgsJLGOUWLMlEKbmb/86li5GLqD4IkaJiw1vGSGcf4wSc2cvBOtgE9CSWD33OFhC
	RKCXUeJC/1cmEIdZ4AejxOI3b5hBqoQFYiQ29B5lB7FZBFQldvz7B1TEwcErYCtxZb4CSJhX
	QFDix+R7LCA2M9DQ9TuPM0HY8hKb17xlBimXEFCXePRXFyQsIqAnsWnmOahyEYl9L94xQkwX
	kPg2+RALRLmsxKYDzCDXSAhMZ5c4/nEu1MeSEgdX3GCZwCg2C8nmWUg2z0KyeRaSFQsYWVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525ihESN9A7GVQ0WhxgFOBiVeHgfJqwKEGJNLCuuzD3E
	KMHBrCTC21QOFOJNSaysSi3Kjy8qzUktPsToA3T5RGYp0eR8YETnlcQbGhubmJmYmphbmpqb
	4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cC4JFD0gKgat5KmwCPbub8zL70OnvRgY5nF
	5ZwnCvtiuZq1d+4p3D3tcPMH9T3vMxY+09U//WH5i+vf+AQOLbL6rCPiNtX0t+iF3tOCzE0n
	7Np08zeuT/qwofOxrNh7G51z7IZrTnhYX9J9W5VevS84Ofrn1stOlYFh5REXmV55byzODG+t
	dpupxFKckWioxVxUnAgAbsDg5ccCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd1Mw9UBBkfvqVlc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmfL81m73gmXjF
	v+5HzA2MrUJdjJwcEgImEn/717FA2GISF+6tZ+ti5OIQEljEKHGx4S0jhPOPUWLu7IVsIFVs
	AloSq+ceB0uICPQySlzo/8oE4jAL/GCUWPzmDTNIlbBAjMSG3qPsIDaLgKrEjn//gIo4OHgF
	bCWuzFcACfMKCEr8mHwPbDUz0ND1O48zQdjyEpvXvGUGKZcQUJd49FcXJCwioCexaeY5qHIR
	iX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwVH5
	THoH46oGi0OMAhyMSjy8DxNWBQixJpYVV+YeYpTgYFYS4W0qBwrxpiRWVqUW5ccXleakFh9i
	9AH6cyKzlGhyPjBh5JXEGxqbmBlZGplZGJmYm+MQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TB
	KdXAOPNZ/vMplgfXpU1aInCsKnaGjdjxBovk7wK+31yP/7mXElzsEXill8NzSlbcqtXW77T5
	Dm7f2HDnvMW0C/67owXCc3oMXy3evWRh4ueJXq2fJl6aWjmhb4/yjp0+BVtjzBS+zzgr9n7p
	pt6Vf56uSHJ631dkPlnm95mNfVXujVdL7ywoZq38qaLEUpyRaKjFXFScCABtwbvM9wIAAA==
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

Patch summary:
[PATCH v2 01/12] ARM: EXYNOS: remove system mmu initialization from arch/arm/ tree
[PATCH v2 02/12] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
[PATCH v2 03/12] ARM: EXYNOS: add System MMU definition to DT
[PATCH v2 04/12] iommu/exynos: support for device tree
[PATCH v2 05/12] iommu/exynos: pass version information from DT
[PATCH v2 06/12] iommu/exynos: allocate lv2 page table from own slab
[PATCH v2 07/12] iommu/exynos: change rwlock to spinlock
[PATCH v2 08/12] iommu/exynos: set System MMU as the parent of client device
[PATCH v2 09/12] iommu/exynos: add supoort for runtime pm and suspend/resume
[PATCH v2 10/12] iommu/exynos: add support for System MMU 3.2 and 3.3
[PATCH v2 11/12] iommu/exynos: add literal name of System MMU for debugging
[PATCH v2 12/12] iommu/exynos: add debugfs entries for System MMU

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
 drivers/iommu/exynos-iommu.c                       | 1423 +++++++++++++++-----
 16 files changed, 1720 insertions(+), 728 deletions(-)

