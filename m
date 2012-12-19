Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2LSELU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 23:11:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23221 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2LSELM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 23:11:12 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b5-50d13e5ee9f1
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Dae Inki'" <inki.dae@samsung.com>, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahun Sharma'" <rahul.sharma@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'SWKim'" <sw0312.kim@samsung.com>
References: <003001cdd78f$a9bb1e00$fd315a00$%cho@samsung.com>
In-reply-to: <003001cdd78f$a9bb1e00$fd315a00$%cho@samsung.com>
Subject: RE: [PATCH v5 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Tue, 18 Dec 2012 20:11:05 -0800
Message-id: <002301cddd9e$dfe265a0$9fa730e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFDY0ixsenLN/FHJIL5plcPOuWeXZk0danA
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zfd04u4sBBnv+cFtc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcnzyDqWC9csXV22fZGxh3S3UxcnBICJhILNzI2cXI
	CWSKSVy4t54NxBYSWMYo8X26KUTcROLtxoWMXYxcQPHpjBJTXjQyQzh/GSXufe1jBKliE9CQ
	OPz+GTtIQkSgnUni6PsJ7CAJZoF5TBLb99hBjLWVmPJuL9gKTgE7iW2vu8FqhAUSJZa/vAdm
	swioSmz4fgSshlfAUqKt/zQ7hC0o8WPyPRaImVoSm7c1sULY8hKb17xlhjhVQWLH2ddgB4kI
	GEnc3LeLDaJGXGLSg4dQ8wUkvk0+xALxvazEpgNgz0gIrGKXmLl7KyvEHEmJgytusExglJiF
	ZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzFCokxqB+PKBotDjAIc
	jEo8vAWrLgQIsSaWFVfmHmKU4GBWEuHlVb0YIMSbklhZlVqUH19UmpNafIjRB+jyicxSosn5
	wASQVxJvaGxsYmZiamJuaWpuikNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAOjukLtx9yK
	Kvb1QXIOaT/+Pj9Xq8BSyyt//kbjp59HHZNfSd07nKP9hnnb02ltHIWrXbsUOh+mCrhturE+
	1dTgbuO+s1b2a8pXyb1yVrnyvvN75YPzUfPEYgp2vD65P+/5jVyR5Or+907RBzlXhOR6P553
	/OZu30PKVrM0P5mLLrtlZsCybIuTEktxRqKhFnNRcSIAvbL4NN8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd04u4sBBrfPsFhc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3J88g6lgvXLF
	1dtn2RsYd0t1MXJySAiYSLzduJARwhaTuHBvPVsXIxeHkMB0RokpLxqZIZy/jBL3vvaBVbEJ
	aEgcfv+MHSQhItDOJHH0/QR2kASzwDwmie177EBsIQFbiSnv9rKB2JwCdhLbXneD1QgLJEos
	f3kPzGYRUJXY8P0IWA2vgKVEW/9pdghbUOLH5HssEDO1JDZva2KFsOUlNq95ywxxqoLEjrOv
	wQ4SETCSuLlvFxtEjbjEpAcP2ScwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE
	3OLSvHS95PzcTYzgOH4mtYNxZYPFIUYBDkYlHt6CVRcChFgTy4orcw8xSnAwK4nw8qpeDBDi
	TUmsrEotyo8vKs1JLT7E6AP06URmKdHkfGCKySuJNzQ2MTOyNDKzMDIxN8chrCTO2+yREiAk
	kJ5YkpqdmlqQWgQzjomDU6qB0T9lr2vYAs55vhN2Bj8sWHz6frd/844baVweFzim/2Zc8VQz
	UKG+PXFl8ltvhxQ3Vn620PXmeRuuHEx3+67KW5WxN17Jw8w7Smx9svGSxwrq7mcc8/hjk66s
	TZ6Xk3jb1T2juEt139Z/ZU0b49zdvqrMYH5XdGjOZVY5k0nqpTOcMi6GMj5SYinOSDTUYi4q
	TgQAMwsetBADAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cho KyoungHo wrote:
> 
> The current exynos-iommu(System MMU) driver does not work
> autonomously
> since it is lack of support for power management of peripheral blocks.
> For example, MFC device driver must ensure that its System MMU is
> disabled
> before MFC block is power-down not to invalidate IOTLB in the System MMU
> when I/O memory mapping is changed. Because A System MMU is resides in
> the
> same H/W block, access to control registers of System MMU while the H/W
> block is turned off must be prohibited.
> 
> This set of changes solves the above problem with setting each System
> MMUs
> as the parent of the device which owns the System MMU to receive the
> information when the device is turned off or turned on.
> 
> Another big change to the driver is the support for devicetree.
> The bindings for System MMU is described in
> Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
> 
> In addition, this patchset also includes several bug fixes and
enhancements
> of the current driver.
> 
> Change log:
> v5:
> - new bugfix: patch 01
> - Reordered patches
>   * patch 01 ~ 05: Bugfix and enhancements of the existing driver
>   * patch 06 ~ 10: Device Tree support and callbacks for power management
>   * patch 11     : System MMU 3.2 and 3.3 support
>   * patch 12 ~ 14: Debugging features
> - Additional code compaction
> 
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
> [PATCH v5 01/14] iommu/exynos: add missing cache flush for removed
> pagetable entries
> [PATCH v5 02/14] iommu/exynos: always use iommu fault handler
> [PATCH v5 03/14] iommu/exynos: allocate lv2 page table from own slab
> [PATCH v5 04/14] iommu/exynos: change rwlock to spinlock
> [PATCH v5 05/14] ARM: EXYNOS: Add clk_ops for gating clocks of System
> MMU
> [PATCH v5 06/14] ARM: EXYNOS: add System MMU definition to DT
> [PATCH v5 07/14] iommu/exynos: support for device tree
> [PATCH v5 08/14] iommu/exynos: set System MMU as the parent of client
> device
> [PATCH v5 09/14] ARM: EXYNOS: remove system mmu initialization from
> exynos tree
> [PATCH v5 10/14] iommu/exynos: add support for runtime pm and
> suspend/resume
> [PATCH v5 11/14] iommu/exynos: add support for System MMU 3.2 and 3.3
> [PATCH v5 12/14] iommu/exynos: pass version information from DT
> [PATCH v5 13/14] iommu/exynos: add literal name of System MMU for
> debugging
> [PATCH v5 14/14] iommu/exynos: add debugfs entries for System MMU
> 
> Diffstats:
>  .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   96 ++
>  arch/arm/boot/dts/exynos4x12.dtsi                  |  124 ++
>  arch/arm/boot/dts/exynos5250.dtsi                  |  154 +-
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
>  drivers/iommu/Makefile                             |    2 +-
>  drivers/iommu/exynos-iommu.c                       | 1477
+++++++++++++++-----
>  17 files changed, 1745 insertions(+), 765 deletions(-)

Hmm, the 5th and 6th patches which were 1st and 2nd patches in previous
version are not merged into mainline via Samsung tree yet. Just merged into
Samsung tree. But if Joerg is ok on this series, this series should be
merged into both tree...Joerg, how do you think?

- Kukjin

