Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2K2K4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:56:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9544 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2K2K4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:56:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-59-50b73f3e1c5b
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
Date: Thu, 29 Nov 2012 19:55:57 +0900
Message-id: <008601cdce20$1ccffb00$566ff100$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpPvetdNb3LV1RpCMPgotQ+4VCAAqXvJAAImPLkAAAPnVIACptxag
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zQ107++0BBv8Pyllc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUcWr+TpWCWXsWf+2eYGxg7lLoYOTkkBEwkth6ZygZh
	i0lcuLceyObiEBJYxijx41wTO0zR9b7/rBCJRYwSF592Qjn/GCUm7DjMBFLFJqAlsXrucUaQ
	hIjAfUaJt8e3M4E4zAIXGCWOt04EWyIkUCjx+swsFhCbU4BHYt2fTmYQW1ggUeLZz/2sIDaL
	gKrEttk3wWp4BWwlfv/7DGULSvyYfA/MZgbatnlbEyuELS+xec1boDkcQLeqSzz6qwsSFhFw
	k5i7+CxUiYjEvhfvGCHGC0h8m3yIBaJcVmLTAWaQMyUE1rFL/Nl0gQniZUmJgytusExglJiF
	ZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzFCIk16B+OqBotDjAIc
	jEo8vBsttwUIsSaWFVfmHmKU4GBWEuE9qLY9QIg3JbGyKrUoP76oNCe1+BCjD9DlE5mlRJPz
	gUkgryTe0NjYxMzE1MTc0tTcFIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQZGq3/L/y4w
	WCuW+ltaSFmm4fv9hxdkvxbsetDic3SS75WEf/G3/NOZrz70aY46HNnleER14YegEo5P688W
	Xr4r3royadZFtv5bizOP3F+24evhhKscHP5HGBdPc3SdnbrE6taE6m1851Y6VyyYJHim5mDr
	PT71x4VL3Up94mJ1TJbuYgmw+PowRYmlOCPRUIu5qDgRAPfnYRzhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAV07++0BBoc2iVlc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmHFq/k6Vgll7F
	n/tnmBsYO5S6GDk5JARMJK73/WeFsMUkLtxbz9bFyMUhJLCIUeLi005WCOcfo8SEHYeZQKrY
	BLQkVs89zgiSEBG4zyjx9vh2JhCHWeACo8Tx1olsIFVCAoUSr8/MYgGxOQV4JNb96WQGsYUF
	EiWe/dwPto9FQFVi2+ybYDW8ArYSv/99hrIFJX5MvgdmMwNt27ytiRXClpfYvOYt0BwOoFvV
	JR791QUJiwi4ScxdfBaqRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwHD+T3sG4qsHiEKMAB6MSD+9Gy20BQqyJZcWVuYcYJTiYlUR4D6pt
	DxDiTUmsrEotyo8vKs1JLT7E6AP06ERmKdHkfGCKySuJNzQ2MTOyNDKzMDIxN8chrCTO2+yR
	EiAkkJ5YkpqdmlqQWgQzjomDU6qBkX31BPeVubrPGX/USweXzn0gaHs0S2jb9XRhmbOLZjxh
	CNiUb3iSjSEw/46OTbZgzGeFZIN1Nnm+KVvyax3Olcj/k2O6qj95Rv+zBTmHZbT/9kWZiqw2
	3H5K+TSL8vn/vvfU3pqunH7bfaVQubbnO9fFYu+K6iNnlgq2Fpa7nq/jW9FaeX6vEktxRqKh
	FnNRcSIAGl3gphADAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Cho KyongHo [mailto:pullip.cho@samsung.com]
> Sent: Monday, November 26, 2012 10:54 AM
> > -----Original Message-----
> > From: Cho KyongHo [mailto:pullip.cho@samsung.com]
> > Sent: Monday, November 26, 2012 10:28 AM
> >
> > > -----Original Message-----
> > > From: Kukjin Kim [mailto:kgene.kim@samsung.com]
> > > Sent: Friday, November 23, 2012 5:08 PM
> > > Subject: RE: [PATCH v4 00/12] iommu/exynos: Fixes and Enhancements of System MMU driver with DT
> > >
> > > Cho KyongHo wrote:
> > > >
> > > > The current exynos-iommu(System MMU) driver does not work autonomously
> > > > since it is lack of support for power management of peripheral blocks.
> > > > For example, MFC device driver must ensure that its System MMU is disabled
> > > > before MFC block is power-down not to invalidate IOTLB in the System MMU
> > > > when I/O memory mapping is changed. Because A System MMU is resides in the
> > > > same H/W block, access to control registers of System MMU while the H/W
> > > > block is turned off must be prohibited.
> > > >
> > > > This set of changes solves the above problem with setting each System MMUs
> > > > as the parent of the device which owns the System MMU to recieve the
> > > > information when the device is turned off or turned on.
> > > >
> > > > Another big change to the driver is the support for devicetree.
> > > > The bindings for System MMU is described in
> > > > Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
> > > >
> > > > In addition, this patchset also includes several bug fixes and
> > > > enhancements
> > > > of the current driver.
> > > >
> > > > Change log:
> > > > v4:
> > > > - Remove Change-Id from v3 patches
> > > > - Change the order of the third and the first patch
> > > >   Thanks to Kukjin Kim.
> > > > - Fix memory leak when allocating and assigning exynos_iommu_owner to
> > > > client
> > > >   device if the client device has multiple System MMUs.
> > > >   Thanks to Rahul Sharma.
> > > >
> > > > v3:
> > > > - Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
> > > > - Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
> > > >   Thanks to Prathyush.
> > > >
> > > > v2:
> > > > - Split the patch to iommu/exynos into 9 patches
> > > > - Support for System MMU 3.3
> > > > - Some code compaction
> > > >
> > > > Patch summary:
> > > > [PATCH v4 01/12] ARM: EXYNOS: Add clk_ops for gating clocks of System MMU
> > > > [PATCH v4 02/12] ARM: EXYNOS: add System MMU definition to DT
> > > > [PATCH v4 03/12] ARM: EXYNOS: remove system mmu initialization from exynos
> > > > tree
> > > > [PATCH v4 04/12] iommu/exynos: support for device tree
> > > > [PATCH v4 05/12] iommu/exynos: pass version information from DT
> > > > [PATCH v4 06/12] iommu/exynos: allocate lv2 page table from own slab
> > > > [PATCH v4 07/12] iommu/exynos: change rwlock to spinlock
> > > > [PATCH v4 08/12] iommu/exynos: set System MMU as the parent of client
> > > > device
> > > > [PATCH v4 09/12] iommu/exynos: add support for runtime pm and
> > > > suspend/resume
> > > > [PATCH v4 10/12] iommu/exynos: add support for System MMU 3.2 and 3.3
> > > > [PATCH v4 11/12] iommu/exynos: add literal name of System MMU for
> > > > debugging
> > > > [PATCH v4 12/12] iommu/exynos: add debugfs entries for System MMU
> > > >
> > > > Diffstats:
> > > >  .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++
> > > >  arch/arm/boot/dts/exynos4210.dtsi                  |   96 ++
> > > >  arch/arm/boot/dts/exynos4x12.dtsi                  |  124 ++
> > > >  arch/arm/boot/dts/exynos5250.dtsi                  |  147 +-
> > > >  arch/arm/mach-exynos/Kconfig                       |    5 -
> > > >  arch/arm/mach-exynos/Makefile                      |    1 -
> > > >  arch/arm/mach-exynos/clock-exynos4.c               |   41 +-
> > > >  arch/arm/mach-exynos/clock-exynos4210.c            |    9 +-
> > > >  arch/arm/mach-exynos/clock-exynos4212.c            |   23 +-
> > > >  arch/arm/mach-exynos/clock-exynos5.c               |   86 +-
> > > >  arch/arm/mach-exynos/dev-sysmmu.c                  |  274 ----
> > > >  arch/arm/mach-exynos/include/mach/sysmmu.h         |   66 -
> > > >  arch/arm/mach-exynos/mach-exynos4-dt.c             |   34 +
> > > >  arch/arm/mach-exynos/mach-exynos5-dt.c             |   30 +
> > > >  drivers/iommu/Kconfig                              |    2 +-
> > > >  drivers/iommu/exynos-iommu.c                       | 1428
> > > +++++++++++++++-----
> > > >  16 files changed, 1720 insertions(+), 732 deletions(-)
> > >
> > > Looks good to me 1st~3rd patches. After quick review, I think, 1st and 2nd
> > > patches can go to upstream for v3.8 without any dependency. So I will.
> > >
> > > The 3rd patch has a dependency with other driver changes (4th ~ 12th), so it
> > > should be sent to upstream with others.
> > >
> > > BTW since the 3rd patch touches many Samsung stuff in arch/arm/ so I'd
> > > prefer to take it in Samsung tree. If Joerg is ok on iommu/exynos driver
> > > changes for v3.8...
> > >
> > > Joerg, please let me know about iommu/exynos stuff so that I can decide to
> > > take 3rd patch or not for v3.8.
> > >
> >
> > Hi, Kukjin Kim.
> >
> > I found that control bit fields of clock gating of System MMU of MFC L/R is inversed.
> > That is reported by Prathyush Kalashwaram.
> >
> > I will post v5 patchset that solves this.
> >
> 
> I did not posted v5 patchset.
> Instead, I posted just the fix for the 03/12 patch mentioned above
> as the reply to the 03/12 patch.
> 

Hi, Joerg.

I am waiting for your comment about the patchset.
The latest version is v4.
And a fix of [patch v4 03/12] mentioned above is posted as a reply.

If you have any concern about the patches, please let me know

Thank you.

Cho KyongHo.

