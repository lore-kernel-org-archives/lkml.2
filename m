Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2LJAAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 19:00:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55123 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab2LJAAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 19:00:01 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-ab-50c52600ebc9
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Boojin Kim'" <boojin.kim@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 3/3] ARM: MM: Add the workaround of Errata 766421
Date: Mon, 10 Dec 2012 09:00:01 +0900
Message-id: <001901cdd669$4cd77070$e6865150$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3WZaq4ai+zcSB3TK2VBDX2Gj8fbAAABBCwAAAY9EAAAMZlIA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t8zA10GtaMBBjuea1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mo2eb2Qp+Cla8bOpkb2C8xNfFyMEhIWAicX6naBcjJ5ApJnHh
	3nq2LkYuDiGBZYwSW45fYoRImEhcbW9nArGFBKYzSixaEAxRNI9J4tOf92wgCTYBTYkZ36ez
	g9giAm4SNxo7mECKmAUuMErs3PeNHWSbkAC3xOrmIJAaTgEeiXV/OplBwsICjhITzoOZLAKq
	Epcv6IBU8ArYSmy8dIsR4kx1iUd/dUFMEQEniUNH1UAqmAVEJPa9eAd2JIuAgMS3yYdYIKpl
	JTYdYAZZLyHwmU3i4L2NrBCPSEocXHGDZQKj6Cwk7QsYGVcxiqYWJBcUJ6XnGuoVJ+YWl+al
	6yXn525ihASw1A7GlQ0WhxgFOBiVeHgDFI8GCLEmlhVX5h5ilOBgVhLh5Tp2JECINyWxsiq1
	KD++qDQntfgQow/QVROZpUST84HRlVcSb2hsbGJmYmpibmlqbopDWEmct9kjJUBIID2xJDU7
	NbUgtQhmHBMHp1QDo+tM2cnsl35kCG1aFci75AKzfiKDhf13i+sfrd4z9a7ZoZYfdVxo9jIb
	vZi7ZpNOd+cxsvRPEtWVf76r7V31O9aVed55Wr35baXbfp2f4skkv6C1/nEqz9yZZR3cGxtr
	5vFN0tl8OiPt5FqDp4tEUpIOz7BSc8h1ui56ovNsodVameAVpxNnKrEUZyQaajEXFScCANOQ
	502NAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQV0GtaMBBgsPKFtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjKNnm9kKfgpWvGzqZG9g
	vMTXxcjJISFgInG1vZ0JwhaTuHBvPRuILSQwnVFi0YLgLkYuIHsek8SnP+/BEmwCmhIzvk9n
	B7FFBNwkbjR2MIEUMQtcYJTYue8bUIIDqINbYnVzEEgNpwCPxLo/ncwgYWEBR4kJ58FMFgFV
	icsXdEAqeAVsJTZeusUIEpYQUJd49FcXxBQRcJI4dFQNpIJZQERi34t3jBMY+WchcRcwMq5i
	FE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6QZ1I7GFc2WBxiFOBgVOLhDVA8GiDEmlhWXJl7
	iFGCg1lJhJfr2JEAId6UxMqq1KL8+KLSnNTiQ4w+QOdNZJYSTc4HRm9eSbyhsYmZkaWRmYWR
	ibk5DmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYws2Uy+0w7oHv06o/GbTJvWO/Xy7j/V
	tZEnBZXa5+aofwupsKyqyJlz6oPZiajP5fprp3rvPCtxIF/r2pnpjgpJpwL2/F3Hv61mneHL
	ZUYpFrtkG2ZrqZzS2ORk238/nzXg0a3IKcdkbLcm3zt1b9EkFYZfPt47jm9WPaL14nz8qt9n
	VsasP+euxFKckWioxVxUnAgA88uWir0CAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the workaround of errata 766421 that adds 'dmb' when changing
the translation regime after conditions that the errata 766421 may occur.
Concretely, Add 'dmb' when changing ASID and secure state for cortex-A15 r0p4.

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 arch/arm/Kconfig             |   13 +++++++++++++
 arch/arm/mach-exynos/Kconfig |    1 +
 arch/arm/mm/proc-v7-2level.S |    2 ++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 93397da..9bd34dd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1417,6 +1417,19 @@ config ARM_ERRATA_775420
 	 to deadlock. This workaround puts DSB before executing ISB if
 	 an abort may occur on cache maintenance.

+config ARM_ERRATA_766421
+	bool "ARM errata: Strongly-Ordered/Device load or NC LDREX could return incorrect data"
+	depends on CPU_V7
+	help
+	  This option enables the workaround for the erratum 766421 affecting
+	  Cortex-A15 erratum (r0p4).
+	  In certain situations, a strongly ordered or device load instruction,
+	  or a non-cacheable normal memory load-exclusive instruction could
+	  match multiple fill buffers and return incorrect data.
+	  This workaround is add DMB instruction when making any change to the
+	  translation regime and before doing any new loads/stores/preloads
+	  in the new translation regime.
+
 config ARM_ERRATA_773022
 	bool "ARM errata: incorrect instructions may be executed from loop buffer"
 	depends on CPU_V7
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index bb92f4c..4e28e1c 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -66,6 +66,7 @@ config SOC_EXYNOS5250
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select SAMSUNG_DMADEV
+	select ARM_ERRATA_766421
 	help
 	  Enable EXYNOS5250 SoC support

diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
index fd045e7..c663b2e 100644
--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -53,6 +53,8 @@ ENTRY(cpu_v7_switch_mm)
 #endif
 #ifdef CONFIG_ARM_ERRATA_754322
 	dsb
+#elif CONFIG_ARM_ERRATA_766421
+	dmb
 #endif
 	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
 	isb
--
1.7.5.4



