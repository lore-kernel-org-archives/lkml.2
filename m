Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab2LaSTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 13:19:05 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34059 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2LaSTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 13:19:01 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-e2-50e1d7130d90
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
References: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
In-reply-to: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
Subject: RE: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Mon, 31 Dec 2012 10:18:46 -0800
Message-id: <032401cde783$485ae1a0$d910a4e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFIekVXHKw0ow7bnqULS98EzrZJiJk+EUBw
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zI12R6w8DDK5JWVzeNYfNYsb5fUwO
	TB6fN8kFMEZx2aSk5mSWpRbp2yVwZXx/385aMEu54sLms6wNjHOluxg5OSQETCRmX9nBDmGL
	SVy4t56ti5GLQ0hgGaNE84Y9jF2MHGBFdzbFQMSnM0qc27SPHcL5yyhx68kRJpBuNgENicPv
	n4ElRATamSSOvp8A5jALXGWU6Jg8iQ2kSkjAVuL0y2WMIDangJ3E5KkPwHYLCyRKrL6wE2wS
	i4CqxIVp3awgNq+ApcTTk6vYIGxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsM8YOCxI6zr8Hm
	iwgYSWzuaYGqF5eY9OAhO8R8AYlvkw+xQLwmK7HpADPInRICm9glDi3+AQ0LSYmDK26wTGCU
	mIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MULiTGoH48oGi0OM
	AhyMSjy8XEwPA4RYE8uKK3MPMUpwMCuJ8CYtAwrxpiRWVqUW5ccXleakFh9i9AG6fCKzlGhy
	PjAF5JXEGxobm5iZmJqYW5qam+IQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXAGKt/ITQx
	/5Xk1TMqy3g+SYlJpneLesdvZPsRuKXYSO6d37s1L02mMmp/SWzSOJw+v/Yxn8KaDZf+aSQn
	6hcf/OL3xkxp/SRN+9KL/Bb1VhMMXtSpT3sZaTs/u/WCadrd4Os2vAavDEpzw5m3aPk+eqa0
	plKZcaujzllt1rDKk5+zy9rWPGFRYinOSDTUYi4qTgQAGT+1keACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQV3h6w8DDHZvFrS4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+P6+nbVglnLF
	hc1nWRsY50p3MXJwSAiYSNzZFNPFyAlkiklcuLeerYuRi0NIYDqjxLlN+9ghnL+MEreeHGEC
	qWIT0JA4/P4ZWEJEoJ1J4uj7CWAOs8BVRomOyZPYQKqEBGwlTr9cxghicwrYSUye+oAdxBYW
	SJRYfWEn2CQWAVWJC9O6WUFsXgFLiacnV7FB2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhni
	VgWJHWdfg80XETCS2NzTAlUvLjHpwUP2CYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIziOn0ntYFzZYHGIUYCDUYmHl4vpYYAQa2JZcWXuIUYJDmYlEd6k
	ZUAh3pTEyqrUovz4otKc1OJDjD5An05klhJNzgemmLySeENjEzMjSyMzCyMTc3McwkrivM0e
	KQFCAumJJanZqakFqUUw45g4OKUaGBU+m0Tzit9YxSrw62DdFnUR+a2pa05Ih9t+nedyYZu5
	CN/8OR9nPbCcvKW5ZumM9bnRH0xOel/Z8t7cUXbSEW67Wa0FnWt+3V5RbdqSFL7h3PK9T/8w
	r/sz08zpD//MkzILObimPE/IP8TwyEAw/13tdqY7byT3a4Wvunnkv6vHubkPw84nzf2qxFKc
	kWioxVxUnAgADLDaRRADAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cho KyongHo wrote:
> 
> notice: v6 patch-set is rebased on next/iommu-exynos branch of
> linux-samsung.git.  This patch-set does not include 2 patches (05 and 06
> patches in v5 patch-se) because they alread exist already in the branch.
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
> as the parent of the device which owns the System MMU to recieve the
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
> v6:
> - Rebased on the branch, next/iommu-exynos of
>   git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> 
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
> [PATCH v6 01/12] iommu/exynos: add missing cache flush for removed
> pagetable entries
> [PATCH v6 02/12] iommu/exynos: always use iommu fault handler
> [PATCH v6 03/12] iommu/exynos: allocate lv2 page table from own slab
> [PATCH v6 04/12] iommu/exynos: change rwlock to spinlock
> [PATCH v6 05/12] iommu/exynos: support for device tree
> [PATCH v6 06/12] iommu/exynos: set System MMU as the parent of client
> device
> [PATCH v6 07/12] ARM: EXYNOS: remove system mmu initialization from
> exynos tree
> [PATCH v6 08/12] iommu/exynos: add support for runtime pm and
> suspend/resume
> [PATCH v6 09/12] iommu/exynos: add support for System MMU 3.2 and 3.3
> [PATCH v6 10/12] iommu/exynos: pass version information from DT
> [PATCH v6 11/12] iommu/exynos: add literal name of System MMU for
> debugging
> [PATCH v6 12/12] iommu/exynos: add debugfs entries for System MMU
> 
> Diffstats:
>  arch/arm/boot/dts/exynos5250-smdk5250.dts  |    2 +-
>  arch/arm/boot/dts/exynos5250.dtsi          |   27 +-
>  arch/arm/mach-exynos/Kconfig               |    5 -
>  arch/arm/mach-exynos/Makefile              |    1 -
>  arch/arm/mach-exynos/clock-exynos4.c       |   41 +-
>  arch/arm/mach-exynos/clock-exynos4210.c    |    9 +-
>  arch/arm/mach-exynos/clock-exynos4212.c    |   23 +-
>  arch/arm/mach-exynos/clock-exynos5.c       |   87 +-
>  arch/arm/mach-exynos/dev-sysmmu.c          |  274 ------
>  arch/arm/mach-exynos/include/mach/sysmmu.h |   66 --
>  arch/arm/mach-exynos/mach-exynos4-dt.c     |   34 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c     |   30 +
>  drivers/iommu/Kconfig                      |    2 +-
>  drivers/iommu/Makefile                     |    2 +-
>  drivers/iommu/exynos-iommu.c               | 1477 +++++++++++++++++++++--
> -----
>  15 files changed, 1284 insertions(+), 796 deletions(-)

Looks OK to me, and some guys tested this series on board.

Joerg, it's time to merge this. If you don't mind, let me pick up this whole
series into Samsung tree because this touches many Samsung stuff. 

Any problems/comments on this, let me know.

Happy new year, thanks.

- Kukjin

