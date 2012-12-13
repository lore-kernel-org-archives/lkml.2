Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2LMQ34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:29:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41990 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab2LMQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:29:54 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c0-50ca0280ee79
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, jg1.han@samsung.com,
        thomas.abraham@linaro.org
Subject: [PATCH v3 0/2] Enable ehci and ohci devices for exynos5250
Date: Thu, 13 Dec 2012 22:06:00 +0530
Message-id: <1355416562-25539-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkRreB6VSAQd8XC4vLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4Mtbef81W8Jej4kDjXZYGxgnsXYwcHBICJhJv
	3wOZnECmmMSFe+vZuhi5OIQEljJKLDn/gwUiYSLx5vdRFojEdEaJT/O3MkM4k5kklhyZDVbF
	JqAr0fR2FyOILSJQJLFv/g+wImaBhYwS71+eZAZJCAs4S7xZPJkVxGYRUJW4tW0NWAOvgIdE
	04RDUHcoSLy5/YwZokZA4tvkQywQp8pKbDoANlNC4AibxN0/C6DqJSUOrrjBMoFRcAEjwypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2MwEA7/e+Z1A7GlQ0WhxgFOBiVeHgLwk8GCLEmlhVX
	5h5ilOBgVhLhvfEaKMSbklhZlVqUH19UmpNafIjRB+iSicxSosn5wCjIK4k3NDYxNzU2tTQy
	MjM1xSGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoExR26paNsCj61HnxS9yV2xxmbbCb5y
	9j6lKTKsP7b9PP/OY/93//qAexcsNkr9evKY8VZ7iZ+VbZDwpPALvzbN/HPjMktSVkPV/ydC
	ao81FnAJfpxet9Urw93xzqbYOd8aVMrrduTObbzJss/SLUjso9DcoBR95x97fnAv/S+5rMxm
	BV9HyZUNSizFGYmGWsxFxYkAcqCs4WECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jQd0GplMBBgcualtc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix9v5r
	toK/HBUHGu+yNDBOYO9i5OSQEDCRePP7KAuELSZx4d56ti5GLg4hgemMEp/mb2WGcCYzSSw5
	Mhusik1AV6Lp7S5GEFtEoEhi3/wfYEXMAgsZJd6/PMkMkhAWcJZ4s3gyK4jNIqAqcWvbGrAG
	XgEPiaYJh6BWK0i8uf2MeQIj9wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwYH8TGoH
	48oGi0OMAhyMSjy8BeEnA4RYE8uKK3MPMUpwMCuJ8N54DRTiTUmsrEotyo8vKs1JLT7E6AO0
	fSKzlGhyPjDK8kriDY1NzE2NTS1NLEzMLHEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg
	9DGxaOVr38qsa8Dl/5ubp5s1JFFT1fVD+MYPu5Tsrif37ktz876ywOf0qrkdMsmlW6b+9Flg
	xCwRJd/BlR8ffWwv/xuGr9/ehERYlM811+WR0/y1ZebxdosKM8cDFXWJgRHWGz9//WeUsPlh
	/BeNCQZLFoYm/Ar+I9ZSOWl1f0OQegezpaQSS3FGoqEWc1FxIgAtTqR2kQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2:
 - Changed the compatible string to chip specific(samsung,exynos4210),
   since ehci-s5p and ohci-exynos are being used from exynso4210 onwards.
 - Based on changes for drivers available at:
   http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg23218.html

Changes from v1:
 - Changed the device node names from 'ehci' and 'ohci' to
   'usb@12110000' and 'usb@12120000' as per discussion for the
   change 'http://www.spinics.net/lists/linux-usb/msg73993.html'
 - Rebased on for-next branch of linux-samsung.

Vivek Gautam (2):
  ARM: Exynos5250: Enabling ehci-s5p driver
  ARM: Exynos5250: Enabling ohci-exynos driver

 .../devicetree/bindings/usb/exynos-usb.txt         |   40 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |   12 ++++++
 arch/arm/mach-exynos/include/mach/map.h            |    2 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    4 ++
 5 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/exynos-usb.txt

-- 
1.7.6.5

