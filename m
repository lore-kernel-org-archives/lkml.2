Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2LIX6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:58:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54917 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2LIX6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 18:58:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-7f-50c525abdce3
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 1/3] ARM: MM: Add the workaround of Errata 774769
Date: Mon, 10 Dec 2012 08:58:35 +0900
Message-id: <001701cdd669$19e8cdd0$4dba6970$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3WZaq4ai+zcSB3TK2VBDX2Gj8fbAAABBCwAADNLPA=
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t8zA93VqkcDDD7+5rO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZPz6tZS74IFLxd+1mxgbGfQJdjJwcEgImEnvO/mCBsMUkLtxb
	z9bFyMUhJLCMUeLj+kYWmKIHLdeZQWwhgUWMEove6EIUzWOS2Px6AiNIgk1AU2LG9+nsILaI
	gJvEjcYOJpAiZoGVjBKTPoEUcQB1cEusbg4CqeEU4JFY96cTbKiwgKPE2QV/mUFKWARUJfqm
	CoGEeQVsJVb8m8UGEpYQUJd49FcXYrqVxNore1lBbGYBEYl9L96BXcAiICDxbfIhFohyWYlN
	B5hBDpAQ+MwmcbBpPyvEK5ISB1fcYJnAKDoLSfsCRsZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGCFhLL2DcVWDxSFGAQ5GJR7eAMWjAUKsiWXFlbmHGCU4mJVEeLmOHQkQ4k1JrKxKLcqP
	LyrNSS0+xOgDdNVEZinR5HxgjOWVxBsaG5uYmZiamFuampviEFYS5232SAkQEkhPLEnNTk0t
	SC2CGcfEwSnVwKie1GJtN6FUr/5eNMP7LGnH5bv/Tj8e7LdrIds33UX7L0jZC0pWsmsu97jz
	/Gzkdb65h/6ai7E41R6wynlvF2fIccWGsa7jsdo27bsf58yr6BdakqJwdbLMBJ/Zsxc3f6rI
	5zlcYKHNeZtl1eLqfWG3VvM+2Jql06zU9PSf4iP3xEkNhx7PZ1NiKc5INNRiLipOBABTu0yM
	kAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jAd3VqkcDDD61cVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjB+f1jIXfBCp+Lt2M2MD
	4z6BLkZODgkBE4kHLdeZIWwxiQv31rOB2EICixglFr3R7WLkArLnMUlsfj2BESTBJqApMeP7
	dHYQW0TATeJGYwcTSBGzwEpGiUmfQIo4gDq4JVY3B4HUcArwSKz70wm2QFjAUeLsgr/MICUs
	AqoSfVOFQMK8ArYSK/7NYgMJSwioSzz6qwsx3Upi7ZW9rCA2s4CIxL4X7xgnMPLPQuIuYGRc
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcJc+kdzCuarA4xCjAwajEwxugeDRAiDWxrLgy
	9xCjBAezkggv17EjAUK8KYmVValF+fFFpTmpxYcYfYDum8gsJZqcD4zgvJJ4Q2MTMyNLIzML
	IxNzcxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYDSLM3q2/kH2SSyfTUU43OTPGRSl3
	GqOIheCutrMx349GmXx9njIrcP4Bi+l2H4M7HtzbKtH/LGzbzLnblBe1tj09/OJjo9GUO3KL
	vxkklz7+fUv7nkFKhtmn9ZsjHnu4rBRSc/jONbdsq5Sp6PTnPyttP8055GOqHfD/znSROOkN
	7Htmy5yMUGIpzkg01GIuKk4EAFwnZWm/AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the workaround of Errata 774769 that configures write streaming
on versions of A15 affected by this erratum such that no streaming-write ever
allocates into the L2 cache.

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 arch/arm/Kconfig             |   11 +++++++++++
 arch/arm/mach-exynos/Kconfig |    1 +
 arch/arm/mm/proc-v7.S        |   16 ++++++++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9759fec..11a57e2 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1417,6 +1417,17 @@ config ARM_ERRATA_775420
 	 to deadlock. This workaround puts DSB before executing ISB if
 	 an abort may occur on cache maintenance.

+config ARM_ERRATA_774769
+	bool "ARM errata: data corruption may occur with store streaming in a system"
+	depends on CPU_V7
+	help
+	  This option enables the workaround for the erratum 774769 affecting
+	  Cortex-A15 (r0p4).
+	  External memory may be corrupted on erratum 774769.
+	  The workaround is to configure write streaming on versions of A15
+	  affected by this erratum such that no streaming-write ever allocates
+	  into the L2 cache.
+
 endmenu

 source "arch/arm/common/Kconfig"
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index da55107..e1168fb 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -22,6 +22,7 @@ config ARCH_EXYNOS4
 config ARCH_EXYNOS5
 	bool "SAMSUNG EXYNOS5"
 	select HAVE_SMP
+	select ARM_ERRATA_774769
 	help
 	  Samsung EXYNOS5 (Cortex-A15) SoC based systems

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 846d279..06cbdfa 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -208,7 +208,7 @@ __v7_setup:
 	orreq	r10, r10, #(1 << 22)		@ set the Write Allocate disable bit
 	mcreq	p15, 1, r10, c9, c0, 2		@ write the L2 cache aux ctrl register
 #endif
-	b	3f
+	b	4f

 	/* Cortex-A9 Errata */
 2:	ldr	r10, =0x00000c09		@ Cortex-A9 primary part number
@@ -243,8 +243,20 @@ __v7_setup:
 	mcrlt	p15, 0, r10, c15, c0, 1		@ write diagnostic register
 1:
 #endif
+	b	4f

-3:	mov	r10, #0
+	/* Cortex-A15 Errata */
+3:	ldr	r10, =0x00000c0f		@ Cortex-A15 primary part number
+	teq	r0, r10
+	bne	4f
+#ifdef CONFIG_ARM_ERRATA_774769
+	teq	r6, #0x4			@ present in r0p4
+	mrceq	p15, 0, r10, c1, c0, 1		@ read aux control register
+	orreq	r10, r10, #1 << 25		@ set bit #25
+	mcreq	p15, 0, r10, c1, c0, 1		@ write aux control register
+#endif
+
+4:	mov	r10, #0
 	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
 	dsb
 #ifdef CONFIG_MMU
--
1.7.5.4



