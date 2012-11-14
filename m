Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab2KNIvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:51:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15890 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2KNIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:51:36 -0500
X-AuditID: cbfee61b-b7f616d00000319b-c0-50a35b70ad64
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH 0/4] iommu/exynos: Fixes and Enhancements of System MMU driver
 with DT
Date: Wed, 14 Nov 2012 17:50:56 +0900
Message-id: <002001cdc245$29256160$7b702420$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3CRSj8c2QZQFdaRbuh0XOaIKV9mA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zA92C6MUBBg3PFSwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL2HN/FWvBZqOLh7Y/MDYyvebsYOTkkBEwk1jxfwQxh
	i0lcuLeeDcQWEljGKDFvmiZMTfvieYxdjFxA8UWMEo+b/rFAFP1jlJi8iQnEZhPQklg99zhY
	kYhAL6PEhf6vTCAOs8ADRokVhx+CVQkLREhM/NbHCmKzCKhKtG84CbaaV8BWYtGBLSwQtqDE
	j8n3wGxmoKnrdx5ngrDlJTaveQtUzwF0krrEo7+6IKaIgJ7E+TX1EBUiEvtevGOEmC4g8W3y
	IRaIalmJTQeYQa6REJjMLvGn7QgbxGOSEgdX3GCZwCg2C8niWUgWz0KyeBaSFQsYWVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525ihMSM9A7GVQ0WhxgFOBiVeHgD+hcFCLEmlhVX5h5ilOBg
	VhLhjbVaHCDEm5JYWZValB9fVJqTWnyI0Qfo8onMUqLJ+cB4ziuJNzQ2NjEzMTUxtzQ1N8Uh
	rCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBsXT1YrlD7AfLisP2va+NvbfR9o793fNX2+7v
	tFY8deT/Tv2vVf/Wr/lt2+yxYeHEJqUDfVMdcmtFNb7kLc7hfvvfQLpo1YkjXMab7t30bOf1
	Kd+7UPFIXMIi1euKolqM3+x/F3qFKHumbJfj+N4quFRlmpAz3wddcf58sxtnLvB8f39sTSW3
	kBJLcUaioRZzUXEiAOryWxbGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd2C6MUBBvfvSlpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm7Dm+i7Xgs1DF
	w9sfmRsYX/N2MXJySAiYSLQvnscIYYtJXLi3nq2LkYtDSGARo8Tjpn8sIAkhgX+MEpM3MYHY
	bAJaEqvnHmcEKRIR6GWUuND/lQnEYRZ4wCix4vBDsCphgQiJid/6WEFsFgFVifYNJ5lBbF4B
	W4lFB7awQNiCEj8m3wOzmYGmrt95nAnClpfYvOYtUD0H0EnqEo/+6oKYIgJ6EufX1ENUiEjs
	e/GOcQKjwCwkg2YhGTQLyaBZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOyWfS
	OxhXNVgcYhTgYFTi4Q3oXxQgxJpYVlyZe4hRgoNZSYQ31mpxgBBvSmJlVWpRfnxRaU5q8SFG
	H6A/JzJLiSbnA9NFXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTByc
	Ug2MAm9uxkfsedKx4evZCeddfB8WiRg+MDh2eFG2gfyiXbJL171ibo1I+Df3klbW1FSB3HVb
	giQEj9roLjqvc2UywxaBwv/Tz5coRBdaaJsurvE5/zCPcVnXsT4/jtVqfy72NfZ4y8xM2eRX
	tKdt+8HjuSE2/k+nTNtbVmdRPlk+4nN5aD6H9ZsyJZbijERDLeai4kQAzoSqePYCAAA=
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

Patch summary:
[PATCH 1/4] ARM: EXYNOS: remove system mmu initialization from arch/arm/ tree
[PATCH 2/4] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
[PATCH 3/4] ARM: EXYNOS: add System MMU definition to DT
[PATCH 4/4] iommu/exynos: enhancements of System MMU driver with DT

Diffstats:
 .../devicetree/bindings/arm/samsung/system-mmu.txt |   42 +
 arch/arm/boot/dts/exynos4210.dtsi                  |   96 ++
 arch/arm/boot/dts/exynos4x12.dtsi                  |  124 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |  152 ++-
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
 drivers/iommu/Kconfig                              |   17 +-
 drivers/iommu/Makefile                             |    2 +-
 drivers/iommu/exynos-iommu.c                       | 1420 +++++++++++++++-----
 17 files changed, 1652 insertions(+), 771 deletions(-)

